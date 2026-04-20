import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'models/output_device.dart';

// ─────────────────────────────────────────────────────────────────────────────
// FoundDevice — result type returned by DeviceScanner
// ─────────────────────────────────────────────────────────────────────────────
class FoundDevice {
  const FoundDevice(this.name, this.address);
  final String name;
  final String address;
}

// ─────────────────────────────────────────────────────────────────────────────
// DeviceScanner — real device discovery for each ConnectType
// ─────────────────────────────────────────────────────────────────────────────
class DeviceScanner {
  static Future<List<FoundDevice>> scan(ConnectType type) {
    switch (type) {
      case ConnectType.network:
        return _scanNetwork();
      case ConnectType.usb:
        return _scanUsb();
      case ConnectType.bluetooth:
        return _scanBluetooth();
    }
  }

  // ── Network ────────────────────────────────────────────────────────────────
  // Probes every host on each local /24 subnet for an open port 9100 (raw
  // print).  All 254 connection attempts run concurrently so the scan
  // typically finishes within the single 300 ms timeout.
  static Future<List<FoundDevice>> _scanNetwork({int port = 9100}) async {
    if (kIsWeb) return [];

    final subnets = await _localSubnets();
    if (subnets.isEmpty) return [];

    final found = <FoundDevice>[];
    await Future.wait([
      for (final subnet in subnets)
        for (int i = 1; i <= 254; i++)
          _tryTcp('$subnet.$i', port).then((ok) {
            if (ok) {
              found.add(FoundDevice('Printer @ $subnet.$i', '$subnet.$i:$port'));
            }
          }),
    ]);
    found.sort((a, b) => a.address.compareTo(b.address));
    return found;
  }

  static Future<List<String>> _localSubnets() async {
    final subnets = <String>[];
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLoopback: false,
      );
      for (final iface in interfaces) {
        for (final addr in iface.addresses) {
          final parts = addr.address.split('.');
          if (parts.length == 4) {
            final subnet = '${parts[0]}.${parts[1]}.${parts[2]}';
            if (!subnets.contains(subnet)) subnets.add(subnet);
          }
        }
      }
    } catch (_) {}
    return subnets;
  }

  static Future<bool> _tryTcp(String host, int port) async {
    Socket? socket;
    try {
      socket = await Socket.connect(
        host,
        port,
        timeout: const Duration(milliseconds: 300),
      );
      return true;
    } catch (_) {
      return false;
    } finally {
      socket?.destroy();
    }
  }

  // ── USB ────────────────────────────────────────────────────────────────────
  // macOS : /dev/cu.usb* and /dev/tty.usb*
  // Linux : /dev/usb/lp* (USB printer class) and /dev/ttyUSB* / /dev/ttyACM*
  // Windows : Get-PnpDevice -Class Printer (USB) via PowerShell
  static Future<List<FoundDevice>> _scanUsb() async {
    if (kIsWeb) return [];

    final found = <FoundDevice>[];
    try {
      if (Platform.isMacOS) {
        await for (final entity in Directory('/dev').list()) {
          final name = entity.path.split('/').last;
          if (name.startsWith('cu.usb') || name.startsWith('tty.usb')) {
            found.add(FoundDevice(name, entity.path));
          }
        }
      } else if (Platform.isLinux) {
        final usbDir = Directory('/dev/usb');
        if (await usbDir.exists()) {
          await for (final entity in usbDir.list()) {
            final name = entity.path.split('/').last;
            if (name.startsWith('lp')) {
              found.add(FoundDevice('USB Printer ($name)', entity.path));
            }
          }
        }
        await for (final entity in Directory('/dev').list()) {
          final name = entity.path.split('/').last;
          if (name.startsWith('ttyUSB') || name.startsWith('ttyACM')) {
            found.add(FoundDevice(name, entity.path));
          }
        }
      } else if (Platform.isWindows) {
        // Primary: Windows print spooler — catches any printer installed with a
        // driver (USB port names are USB001, USB002, …).
        // Fallback: PnpDevice scan for USBPRINT\* devices whose driver is not
        // yet installed (shows as raw USB hardware).
        // runInShell: false — bypass cmd.exe so it does not intercept the
        // pipe characters inside the PowerShell script.
        final result = await Process.run(
          'powershell',
          [
            '-NoProfile',
            '-Command',
            r'$a=Get-Printer|Where-Object{$_.PortName -like "USB*"}|Select-Object @{N="FriendlyName";E={$_.Name}},@{N="InstanceId";E={$_.Name}};'
            r'$x="Mass Storage|Composite|Hub|Unknown|Bluetooth|Wireless|Adapter|Keyboard|Mouse|HID";'
            r'$b=Get-PnpDevice|Where-Object{$_.InstanceId -like "USBPRINT*" -or ($_.Class -eq "USB" -and $_.InstanceId -like "USB\VID_*" -and $_.FriendlyName -notmatch $x)}|Select-Object FriendlyName,InstanceId;'
            r'(@($a)+@($b))|ConvertTo-Json',
          ],
          runInShell: false,
        );
        if (result.exitCode == 0) {
          _parsePsJson(result.stdout as String, found);
        }
      }
    } catch (_) {}
    return found;
  }

  // ── Bluetooth ──────────────────────────────────────────────────────────────
  // macOS   : system_profiler SPBluetoothDataType (lists paired devices)
  // Linux   : bluetoothctl paired-devices
  // Windows : Get-PnpDevice -Class Bluetooth via PowerShell
  static Future<List<FoundDevice>> _scanBluetooth() async {
    if (kIsWeb) return [];

    final found = <FoundDevice>[];
    try {
      if (Platform.isMacOS) {
        final result = await Process.run(
          'system_profiler',
          ['SPBluetoothDataType'],
        );
        if (result.exitCode == 0) {
          _parseMacOsBluetooth(result.stdout as String, found);
        }
      } else if (Platform.isLinux) {
        final result = await Process.run('bluetoothctl', ['paired-devices']);
        if (result.exitCode == 0) {
          _parseBluetoothctl(result.stdout as String, found);
        }
      } else if (Platform.isWindows) {
        final result = await Process.run(
          'powershell',
          [
            '-NoProfile',
            '-Command',
            r'Get-PnpDevice -Class Bluetooth | Select-Object FriendlyName,DeviceID | ConvertTo-Json',
          ],
          runInShell: false,
        );
        if (result.exitCode == 0) {
          _parsePsJson(result.stdout as String, found);
        }
      }
    } catch (_) {}
    return found;
  }

  // ── Parsers ────────────────────────────────────────────────────────────────

  /// Parse `system_profiler SPBluetoothDataType` plain-text.
  /// Device name lines end with ':'; the next 'Address:' line has the MAC.
  static void _parseMacOsBluetooth(String output, List<FoundDevice> out) {
    final skipLabels = {
      'Bluetooth', 'Hardware', 'Devices', 'Services',
      'Address', 'Minor Type', 'Major Type',
    };
    String? currentName;
    for (final line in output.split('\n')) {
      final trimmed = line.trim();
      if (trimmed.endsWith(':')) {
        final label = trimmed.substring(0, trimmed.length - 1).trim();
        if (skipLabels.any((s) => label.startsWith(s))) continue;
        currentName = label;
      } else if (trimmed.startsWith('Address:') && currentName != null) {
        final mac =
            trimmed.replaceFirst('Address:', '').trim().replaceAll('-', ':');
        out.add(FoundDevice(currentName, mac));
        currentName = null;
      }
    }
  }

  /// Parse `bluetoothctl paired-devices`:
  /// "Device AA:BB:CC:DD:EE:FF DeviceName"
  static void _parseBluetoothctl(String output, List<FoundDevice> out) {
    final pattern = RegExp(
      r'Device\s+([0-9A-F:]{17})\s+(.+)',
      caseSensitive: false,
    );
    for (final m in pattern.allMatches(output)) {
      out.add(FoundDevice(m.group(2)!.trim(), m.group(1)!));
    }
  }

  /// Parse PowerShell `ConvertTo-Json` output for Get-PnpDevice.
  /// Handles both single-object {} and array [{}…] responses.
  static void _parsePsJson(String output, List<FoundDevice> out) {
    final nameRe = RegExp(r'"FriendlyName"\s*:\s*"([^"]+)"');
    final idRe = RegExp(r'"(?:InstanceId|DeviceID)"\s*:\s*"([^"]+)"');
    final names = nameRe.allMatches(output).map((m) => m.group(1)!).toList();
    final ids = idRe.allMatches(output).map((m) => m.group(1)!).toList();
    for (int i = 0; i < names.length && i < ids.length; i++) {
      out.add(FoundDevice(names[i], ids[i]));
    }
  }
}
