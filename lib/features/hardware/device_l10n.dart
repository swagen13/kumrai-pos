import 'package:kumrai_pos/l10n/app_localizations.dart';

import 'models/output_device.dart';

extension OutputDeviceTypeL10n on OutputDeviceType {
  String l10nLabel(AppLocalizations l10n) {
    switch (this) {
      case OutputDeviceType.printer:
        return l10n.deviceTypePrinter;
      case OutputDeviceType.cashDrawer:
        return l10n.deviceTypeCashDrawer;
      case OutputDeviceType.printerWithCashDrawer:
        return l10n.deviceTypePrinterWithDrawer;
    }
  }
}

extension ConnectTypeL10n on ConnectType {
  String l10nLabel(AppLocalizations l10n) {
    switch (this) {
      case ConnectType.network:
        return l10n.connectTypeNetwork;
      case ConnectType.usb:
        return l10n.connectTypeUsb;
      case ConnectType.bluetooth:
        return l10n.connectTypeBluetooth;
    }
  }
}

extension DeviceStatusL10n on DeviceStatus {
  String l10nLabel(AppLocalizations l10n) {
    switch (this) {
      case DeviceStatus.online:
        return l10n.deviceStatusOnline;
      case DeviceStatus.offline:
        return l10n.deviceStatusOffline;
      case DeviceStatus.connecting:
        return l10n.deviceStatusConnecting;
    }
  }
}

extension PaperWidthL10n on PaperWidth {
  String l10nLabel(AppLocalizations l10n) {
    switch (this) {
      case PaperWidth.mm58:
        return l10n.paperWidth58;
      case PaperWidth.mm80:
        return l10n.paperWidth80;
    }
  }
}
