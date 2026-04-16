// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Kamrai POS';

  @override
  String get appNameNav => 'Kamrai POS';

  @override
  String get navPrinter => 'Printer';

  @override
  String get navDrawer => 'Drawer';

  @override
  String get navSystemStable => 'System Stable';

  @override
  String get branchSampleName => 'Branch A';

  @override
  String get userRoleStoreManager => 'Store Manager';

  @override
  String get userCompanyName => 'Kamrai Headquarters';

  @override
  String get userInitials => 'SM';

  @override
  String get welcomeTitle => 'Welcome, Manager';

  @override
  String get welcomeSubtitle => 'Choose a service to manage today';

  @override
  String get modulePosTitle => 'POS Terminal';

  @override
  String get modulePosDescription =>
      'Open food sales, pick tables, and check out';

  @override
  String get modulePosBadge => '5 Unpaid Bills';

  @override
  String get moduleTableTitle => 'Table Management';

  @override
  String get moduleTableDescription =>
      'Manage floor plan by zone and table status';

  @override
  String get moduleTableBadge => '12/24 Available';

  @override
  String get moduleMenuTitle => 'Menu & Buffet';

  @override
  String get moduleMenuDescription =>
      'Configure A-La-Carte, sets, and buffet packages';

  @override
  String get moduleMenuBadge => 'Standard List';

  @override
  String get moduleInventoryTitle => 'Inventory & Stock';

  @override
  String get moduleInventoryDescription =>
      'Check ingredient stock, expiry, and receiving';

  @override
  String get moduleInventoryBadge => '3 Items Low Stock';

  @override
  String get moduleLoyaltyTitle => 'Loyalty & CRM';

  @override
  String get moduleLoyaltyDescription =>
      'Customer data and centralized points history';

  @override
  String get moduleLoyaltyBadge => '2,450 Members';

  @override
  String get moduleEnterpriseTitle => 'Enterprise & Branch';

  @override
  String get moduleEnterpriseDescription =>
      'Company, branches, tax, and permissions';

  @override
  String get moduleEnterpriseBadge => 'Global Settings';

  @override
  String get moduleHardwareTitle => 'Hardware Settings';

  @override
  String get moduleHardwareDescription => 'Connect printers and cash drawer';

  @override
  String get moduleSalesTitle => 'Sales Report';

  @override
  String get moduleSalesDescription => 'Sales by channel and GP';

  @override
  String get moduleSalesBadge => '+12.5% Today';

  @override
  String get footerPremiumTag => 'PREMIUM EXPERIENCE';

  @override
  String get footerPremiumTitle => 'The Ethereal Merchant POS';

  @override
  String get footerPremiumBody =>
      'Elevate store operations with the smoothest,\nmost modern POS—built for today’s business.';

  @override
  String get footerLearnMore => 'Learn more';

  @override
  String get footerSupportTitle => '24/7 Support';

  @override
  String get footerSupportBody => 'Having trouble? Reach our experts anytime.';

  @override
  String get footerContactStaff => 'Contact staff';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonClose => 'Close';

  @override
  String get commonDelete => 'Delete';

  @override
  String get tablesFloorPlanTitle => 'Table map';

  @override
  String get tablesStatAvailable => 'Available';

  @override
  String get tablesStatOccupied => 'Occupied';

  @override
  String get tablesStatCleaning => 'Cleaning';

  @override
  String get tablesAllZones => 'All';

  @override
  String get tablesAddZone => 'Add zone';

  @override
  String tablesAvailOfTotal(int avail, int total) {
    return '$avail of $total available';
  }

  @override
  String get tablesSeatsUnit => 'seats';

  @override
  String tablesGuestCount(int guests, int capacity) {
    return '$guests/$capacity guests';
  }

  @override
  String tablesBuffetRemaining(String time) {
    return 'Remaining $time';
  }

  @override
  String get tablesTimeUp => 'Time’s up';

  @override
  String get tablesBuffet => 'Buffet';

  @override
  String get tablesBuffetExpired => 'Buffet — time’s up!';

  @override
  String get tablesAlaCarte => 'A-La-Carte';

  @override
  String get tablesStatusOccupiedBuffet => 'Occupied • Buffet';

  @override
  String get tablesStatusOccupiedAlaCarte => 'Occupied • A-La-Carte';

  @override
  String get tablesOpenBillAlaCarte => 'Open A-La-Carte bill';

  @override
  String get tablesOpenBillAlaCarteSub => 'Order à la carte';

  @override
  String get tablesOpenBillBuffet => 'Open buffet bill';

  @override
  String get tablesOpenBillBuffetSub => 'Choose a buffet package';

  @override
  String get tablesShowQrOrder => 'Show self-order QR';

  @override
  String get tablesShowQrOrderSub => 'Guests scan to order';

  @override
  String get tablesViewCurrentBill => 'View current bill';

  @override
  String get tablesViewCurrentBillSub => 'Open order taking';

  @override
  String get tablesMoveTable => 'Move table';

  @override
  String get tablesMoveTableSub => 'Move this bill to another table';

  @override
  String get tablesMergeTables => 'Merge tables';

  @override
  String get tablesMergeTablesSub => 'Combine with another bill';

  @override
  String get tablesSetCleaning => 'Start cleaning';

  @override
  String get tablesSetCleaningSub => 'After guests have paid';

  @override
  String get tablesMarkReady => 'Ready — mark available';

  @override
  String get tablesMarkReadySub => 'Clean and ready for guests';

  @override
  String get tablesOpenBillSkipClean => 'Open new bill now';

  @override
  String get tablesOpenBillSkipCleanSub => 'Skip cleaning step';

  @override
  String get deviceTypePrinter => 'Printer';

  @override
  String get deviceTypeCashDrawer => 'Cash drawer';

  @override
  String get deviceTypePrinterWithDrawer => 'Printer + drawer';

  @override
  String get connectTypeNetwork => 'Network';

  @override
  String get connectTypeUsb => 'USB';

  @override
  String get connectTypeBluetooth => 'Bluetooth';

  @override
  String get connectSublabelTcpIp => 'TCP/IP';

  @override
  String get connectSublabelDirect => 'Direct';

  @override
  String get connectSublabelBt40 => 'BT 4.0';

  @override
  String get deviceStatusOnline => 'Online';

  @override
  String get deviceStatusOffline => 'Offline';

  @override
  String get deviceStatusConnecting => 'Connecting';

  @override
  String get paperWidth58 => '58 mm';

  @override
  String get paperWidth80 => '80 mm';

  @override
  String hardwareOnlineCount(int online, int total) {
    return '$online/$total online';
  }

  @override
  String get hardwareAddDevice => 'Add device';

  @override
  String get hardwareAllDevices => 'All devices';

  @override
  String get hardwareNewDevice => 'New device';

  @override
  String get hardwareUnnamedDevice => 'Unnamed device';

  @override
  String get hardwareSectionNameAndType => 'Device name & type';

  @override
  String get hardwareDeviceName => 'Device name';

  @override
  String get hardwareDeviceNameHint => 'e.g. Main kitchen printer';

  @override
  String get hardwareOutputType => 'Device type';

  @override
  String get hardwareConnectSection => 'Connection';

  @override
  String get hardwarePrinterSettings => 'Printer settings';

  @override
  String get hardwarePaperSize => 'Paper width';

  @override
  String get hardwareEncodingCp874 => 'CP874 (Thai)';

  @override
  String get hardwareAutoCutter => 'Auto cutter';

  @override
  String get hardwareAutoCutterSub => 'Cut paper automatically after printing';

  @override
  String get hardwareBuzzer => 'Order buzzer';

  @override
  String get hardwareBuzzerSub => 'Beep when a new order arrives';

  @override
  String get hardwarePrintRouting => 'Print routing';

  @override
  String get hardwarePrintRoutingHint =>
      'Choose categories to print on this device';

  @override
  String get hardwareEnableDevice => 'Enable device';

  @override
  String get hardwareEnableDeviceSub =>
      'Turn off to pause print jobs temporarily';

  @override
  String get hardwareTestPrint => 'Test print';

  @override
  String get hardwareDeleteDevice => 'Delete device';

  @override
  String get hardwareDeleteTitle => 'Delete device';

  @override
  String hardwareDeleteConfirm(String name) {
    return 'Delete \"$name\"? This cannot be undone.';
  }

  @override
  String get hardwareLabelIpAddress => 'IP address';

  @override
  String get hardwareHintIp => '192.168.1.xxx';

  @override
  String get hardwareLabelPort => 'Port';

  @override
  String get hardwareHintPort => '9100';

  @override
  String get hardwareLabelUsbPath => 'USB device path';

  @override
  String get hardwareHintUsb => '/dev/usb/lp0';

  @override
  String get hardwareScanUsb => 'Scan USB';

  @override
  String get hardwareLabelBtAddress => 'Bluetooth address';

  @override
  String get hardwareHintBt => 'AA:BB:CC:DD:EE:FF';

  @override
  String get hardwareScanBt => 'Scan Bluetooth';

  @override
  String get hardwareTestPrintSuccess => 'Print job sent';

  @override
  String get hardwareTestPrintSending => 'Sending print job…';

  @override
  String get hardwareTestPrintDialogTitle => 'Test print';

  @override
  String hardwareTestPrintCheckPaper(String name) {
    return 'Check the paper from $name';
  }

  @override
  String hardwareTestPrintDeviceLine(String name) {
    return 'Device: $name';
  }

  @override
  String get hardwarePrintTestAction => 'Print test';

  @override
  String get hardwareScanDialogTitle => 'Scan for devices';

  @override
  String get hardwareScanningNetwork => 'Scanning network…';

  @override
  String get hardwareScanningUsb => 'Scanning USB…';

  @override
  String get hardwareScanningBluetooth => 'Scanning Bluetooth…';

  @override
  String get hardwareDevicesFoundNone => 'No devices found';

  @override
  String hardwareDevicesFoundCount(int count) {
    return 'Found $count devices';
  }

  @override
  String get hardwareEmptyTitle => 'No devices yet';

  @override
  String get hardwareEmptySubtitle =>
      'Add a printer or cash drawer to get started';

  @override
  String get hardwareEmptyAddFirst => 'Add first device';
}
