import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';

// ── DOC_INFO_1W ──────────────────────────────────────────────────────────────
final class _DocInfo1 extends Struct {
  external Pointer<Utf16> pDocName;
  external Pointer<Utf16> pOutputFile;
  external Pointer<Utf16> pDatatype;
}

// ─────────────────────────────────────────────────────────────────────────────
// WindowsRawPrinter
// Sends ESC/POS byte sequences to a Windows spooler printer via winspool.drv.
// All winspool.drv access is guarded by Platform.isWindows so this file is
// safe to import on Android / iOS / macOS / Linux.
// ─────────────────────────────────────────────────────────────────────────────
class WindowsRawPrinter {
  // Lazily opened — never touched on non-Windows platforms.
  static DynamicLibrary? _lib;

  static DynamicLibrary get _winspool =>
      _lib ??= DynamicLibrary.open('winspool.drv');

  /// Sends [data] as a RAW print job to [printerName] (Windows spooler name,
  /// e.g. "POS-58"). Returns true on success.
  static bool sendRaw(String printerName, Uint8List data) {
    if (!Platform.isWindows) return false;

    final openPrinter = _winspool.lookupFunction<
        Int32 Function(Pointer<Utf16>, Pointer<IntPtr>, Pointer<Void>),
        int Function(Pointer<Utf16>, Pointer<IntPtr>, Pointer<Void>)>(
        'OpenPrinterW');
    final closePrinter = _winspool.lookupFunction<
        Int32 Function(IntPtr), int Function(int)>('ClosePrinter');
    final startDocPrinter = _winspool.lookupFunction<
        Int32 Function(IntPtr, Uint32, Pointer<_DocInfo1>),
        int Function(int, int, Pointer<_DocInfo1>)>('StartDocPrinterW');
    final startPagePrinter = _winspool.lookupFunction<
        Int32 Function(IntPtr), int Function(int)>('StartPagePrinter');
    final writePrinter = _winspool.lookupFunction<
        Int32 Function(IntPtr, Pointer<Void>, Uint32, Pointer<Uint32>),
        int Function(int, Pointer<Void>, int, Pointer<Uint32>)>('WritePrinter');
    final endPagePrinter = _winspool.lookupFunction<
        Int32 Function(IntPtr), int Function(int)>('EndPagePrinter');
    final endDocPrinter = _winspool.lookupFunction<
        Int32 Function(IntPtr), int Function(int)>('EndDocPrinter');

    return using((arena) {
      final namePtr = printerName.toNativeUtf16(allocator: arena);
      final handlePtr = arena<IntPtr>();

      if (openPrinter(namePtr, handlePtr, nullptr) == 0) return false;
      final handle = handlePtr.value;

      try {
        final docInfo = arena<_DocInfo1>();
        docInfo.ref.pDocName =
            'Kumrai POS Print'.toNativeUtf16(allocator: arena);
        docInfo.ref.pOutputFile = nullptr;
        docInfo.ref.pDatatype = 'RAW'.toNativeUtf16(allocator: arena);

        if (startDocPrinter(handle, 1, docInfo) == 0) return false;
        startPagePrinter(handle);

        final buf = arena<Uint8>(data.length);
        for (var i = 0; i < data.length; i++) {
          buf[i] = data[i];
        }
        final written = arena<Uint32>();
        writePrinter(handle, buf.cast(), data.length, written);

        endPagePrinter(handle);
        endDocPrinter(handle);
        return true;
      } finally {
        closePrinter(handle);
      }
    });
  }

  /// ESC/POS test-print bytes for a 58 mm or 80 mm thermal receipt printer.
  static Uint8List testPrintBytes(String deviceName) {
    final now = DateTime.now();
    final dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final separator = '-' * 32;

    final lines = [
      '\x1B\x40',          // ESC @ — initialize
      '\x1B\x61\x01',      // ESC a 1 — center
      '\x1B\x21\x30',      // ESC ! 0x30 — double width + height
      'Kumrai POS\n',
      '\x1B\x21\x00',      // ESC ! 0 — normal size
      '$separator\n',
      '\x1B\x61\x00',      // ESC a 0 — left
      'Test Print\n',
      'Device : $deviceName\n',
      'Date   : $dateStr\n',
      '$separator\n',
      '  ** Print OK **\n',
      '\n\n\n',
      '\x1D\x56\x00',      // GS V 0 — full cut
    ];

    final bytes = lines.expand((s) => s.codeUnits).toList();
    return Uint8List.fromList(bytes);
  }
}
