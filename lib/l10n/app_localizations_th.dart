// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'Kamrai POS';

  @override
  String get appNameNav => 'Kamrai POS';

  @override
  String get navPrinter => 'เครื่องพิมพ์';

  @override
  String get navDrawer => 'ลิ้นชักเงิน';

  @override
  String get navSystemStable => 'ระบบเสถียร';

  @override
  String get branchSampleName => 'สาขา A';

  @override
  String get userRoleStoreManager => 'ผู้จัดการร้าน';

  @override
  String get userCompanyName => 'สำนักงานใหญ่ Kamrai';

  @override
  String get userInitials => 'SM';

  @override
  String get welcomeTitle => 'ยินดีต้อนรับ, ผู้จัดการ';

  @override
  String get welcomeSubtitle => 'เลือกบริการที่ต้องการจัดการวันนี้';

  @override
  String get modulePosTitle => 'เทอร์มินัล POS';

  @override
  String get modulePosDescription => 'เปิดหน้าขายอาหาร, เลือกโต๊ะ และคิดเงิน';

  @override
  String get modulePosBadge => 'บิลค้างชำระ 5 รายการ';

  @override
  String get moduleTableTitle => 'จัดการโต๊ะ';

  @override
  String get moduleTableDescription => 'จัดการผังโต๊ะ แยกตามโซน และสถานะโต๊ะ';

  @override
  String get moduleTableBadge => 'ว่าง 12/24';

  @override
  String get moduleMenuTitle => 'เมนู & บุฟเฟต์';

  @override
  String get moduleMenuDescription =>
      'ตั้งค่าเมนู A-La-Carte, เซ็ตอาหาร และแพ็กเกจบุฟเฟต์';

  @override
  String get moduleMenuBadge => 'รายการมาตรฐาน';

  @override
  String get moduleInventoryTitle => 'คลัง & สต็อก';

  @override
  String get moduleInventoryDescription =>
      'ตรวจสอบสต็อกวัตถุดิบ, วันหมดอายุ และการรับเข้า';

  @override
  String get moduleInventoryBadge => 'สินค้าใกล้หมด 3 รายการ';

  @override
  String get moduleLoyaltyTitle => 'สะสมแต้ม & CRM';

  @override
  String get moduleLoyaltyDescription =>
      'จัดการข้อมูลลูกค้าและประวัติการสะสมแต้มส่วนกลาง';

  @override
  String get moduleLoyaltyBadge => 'สมาชิก 2,450 คน';

  @override
  String get moduleEnterpriseTitle => 'องค์กร & สาขา';

  @override
  String get moduleEnterpriseDescription =>
      'ตั้งค่าบริษัท, สาขา, ภาษี และสิทธิ์การใช้งาน';

  @override
  String get moduleEnterpriseBadge => 'ตั้งค่าระบบ';

  @override
  String get moduleHardwareTitle => 'ตั้งค่าฮาร์ดแวร์';

  @override
  String get moduleHardwareDescription =>
      'เชื่อมต่อเครื่องพิมพ์ และลิ้นชักเก็บเงิน';

  @override
  String get moduleSalesTitle => 'รายงานยอดขาย';

  @override
  String get moduleSalesDescription => 'ดูยอดขายแยกตามช่องทาง และค่า GP';

  @override
  String get moduleSalesBadge => '+12.5% วันนี้';

  @override
  String get footerPremiumTag => 'ประสบการณ์พรีเมียม';

  @override
  String get footerPremiumTitle => 'POS ร้านค้าระดับพรีเมียม';

  @override
  String get footerPremiumBody =>
      'ยกระดับการจัดการร้านค้าด้วยระบบ POS ที่ลื่นไหล\nและทันสมัยที่สุด ออกแบบมาเพื่อธุรกิจยุคใหม่';

  @override
  String get footerLearnMore => 'เรียนรู้เพิ่มเติม';

  @override
  String get footerSupportTitle => 'ฝ่ายสนับสนุน 24/7';

  @override
  String get footerSupportBody =>
      'มีปัญหาการใช้งาน? ติดต่อทีมผู้เชี่ยวชาญของเราได้ทันที';

  @override
  String get footerContactStaff => 'ติดต่อเจ้าหน้าที่';

  @override
  String get commonCancel => 'ยกเลิก';

  @override
  String get commonClose => 'ปิด';

  @override
  String get commonDelete => 'ลบ';

  @override
  String get tablesFloorPlanTitle => 'ผังโต๊ะ';

  @override
  String get tablesStatAvailable => 'ว่าง';

  @override
  String get tablesStatOccupied => 'ไม่ว่าง';

  @override
  String get tablesStatCleaning => 'ทำความสะอาด';

  @override
  String get tablesAllZones => 'ทั้งหมด';

  @override
  String get tablesAddZone => 'เพิ่มโซน';

  @override
  String tablesAvailOfTotal(int avail, int total) {
    return 'ว่าง $avail/$total';
  }

  @override
  String get tablesSeatsUnit => 'ที่นั่ง';

  @override
  String tablesGuestCount(int guests, int capacity) {
    return '$guests/$capacity คน';
  }

  @override
  String tablesBuffetRemaining(String time) {
    return 'เหลือ $time';
  }

  @override
  String get tablesTimeUp => 'หมดเวลา';

  @override
  String get tablesBuffet => 'บุฟเฟต์';

  @override
  String get tablesBuffetExpired => 'บุฟเฟต์ หมดเวลา!';

  @override
  String get tablesAlaCarte => 'A-La-Carte';

  @override
  String get tablesStatusOccupiedBuffet => 'ไม่ว่าง • บุฟเฟต์';

  @override
  String get tablesStatusOccupiedAlaCarte => 'ไม่ว่าง • A-La-Carte';

  @override
  String get tablesOpenBillAlaCarte => 'เปิดบิล A-La-Carte';

  @override
  String get tablesOpenBillAlaCarteSub => 'สั่งอาหารรายการ';

  @override
  String get tablesOpenBillBuffet => 'เปิดบิลบุฟเฟต์';

  @override
  String get tablesOpenBillBuffetSub => 'เลือกแพ็กเกจบุฟเฟต์';

  @override
  String get tablesShowQrOrder => 'แสดง QR สั่งอาหารเอง';

  @override
  String get tablesShowQrOrderSub => 'ลูกค้าสแกนสั่งได้ทันที';

  @override
  String get tablesViewCurrentBill => 'ดูบิลปัจจุบัน';

  @override
  String get tablesViewCurrentBillSub => 'เข้าหน้ารับออเดอร์';

  @override
  String get tablesMoveTable => 'ย้ายโต๊ะ';

  @override
  String get tablesMoveTableSub => 'ย้ายบิลนี้ไปโต๊ะอื่น';

  @override
  String get tablesMergeTables => 'รวมโต๊ะ';

  @override
  String get tablesMergeTablesSub => 'รวมบิลกับโต๊ะอื่น';

  @override
  String get tablesSetCleaning => 'ทำความสะอาด';

  @override
  String get tablesSetCleaningSub => 'ตั้งสถานะหลังลูกค้าจ่ายแล้ว';

  @override
  String get tablesMarkReady => 'พร้อมแล้ว — ตั้งเป็นว่าง';

  @override
  String get tablesMarkReadySub => 'โต๊ะสะอาดพร้อมรับลูกค้า';

  @override
  String get tablesOpenBillSkipClean => 'เปิดบิลใหม่ทันที';

  @override
  String get tablesOpenBillSkipCleanSub => 'ข้ามขั้นตอนทำความสะอาด';

  @override
  String get deviceTypePrinter => 'เครื่องพิมพ์';

  @override
  String get deviceTypeCashDrawer => 'ลิ้นชักเงิน';

  @override
  String get deviceTypePrinterWithDrawer => 'พิมพ์+ลิ้นชัก';

  @override
  String get connectTypeNetwork => 'เครือข่าย';

  @override
  String get connectTypeUsb => 'USB';

  @override
  String get connectTypeBluetooth => 'บลูทูธ';

  @override
  String get connectSublabelTcpIp => 'TCP/IP';

  @override
  String get connectSublabelDirect => 'ตรง';

  @override
  String get connectSublabelBt40 => 'BT 4.0';

  @override
  String get deviceStatusOnline => 'ออนไลน์';

  @override
  String get deviceStatusOffline => 'ออฟไลน์';

  @override
  String get deviceStatusConnecting => 'กำลังเชื่อมต่อ';

  @override
  String get paperWidth58 => '58 มม.';

  @override
  String get paperWidth80 => '80 มม.';

  @override
  String hardwareOnlineCount(int online, int total) {
    return '$online/$total ออนไลน์';
  }

  @override
  String get hardwareAddDevice => 'เพิ่มอุปกรณ์';

  @override
  String get hardwareAllDevices => 'อุปกรณ์ทั้งหมด';

  @override
  String get hardwareNewDevice => 'อุปกรณ์ใหม่';

  @override
  String get hardwareUnnamedDevice => 'อุปกรณ์ไม่มีชื่อ';

  @override
  String get hardwareSectionNameAndType => 'ชื่ออุปกรณ์และประเภท';

  @override
  String get hardwareDeviceName => 'ชื่ออุปกรณ์';

  @override
  String get hardwareDeviceNameHint => 'เช่น เครื่องพิมพ์ครัวหลัก';

  @override
  String get hardwareOutputType => 'ประเภทอุปกรณ์';

  @override
  String get hardwareConnectSection => 'การเชื่อมต่อ';

  @override
  String get hardwarePrinterSettings => 'ตั้งค่าเครื่องพิมพ์';

  @override
  String get hardwarePaperSize => 'ขนาดกระดาษ';

  @override
  String get hardwareEncodingCp874 => 'CP874 (Thai)';

  @override
  String get hardwareAutoCutter => 'Auto Cutter';

  @override
  String get hardwareAutoCutterSub => 'ตัดกระดาษอัตโนมัติหลังพิมพ์';

  @override
  String get hardwareBuzzer => 'บัซเซอร์แจ้งเตือน';

  @override
  String get hardwareBuzzerSub => 'ส่งเสียงเมื่อมีออเดอร์ใหม่';

  @override
  String get hardwarePrintRouting => 'เส้นทางการพิมพ์';

  @override
  String get hardwarePrintRoutingHint => 'เลือกหมวดหมู่ที่จะพิมพ์ที่อุปกรณ์นี้';

  @override
  String get hardwareEnableDevice => 'เปิดใช้งานอุปกรณ์';

  @override
  String get hardwareEnableDeviceSub => 'ปิดเพื่อหยุดส่งงานพิมพ์ชั่วคราว';

  @override
  String get hardwareTestPrint => 'ทดสอบพิมพ์';

  @override
  String get hardwareDeleteDevice => 'ลบอุปกรณ์';

  @override
  String get hardwareDeleteTitle => 'ลบอุปกรณ์';

  @override
  String hardwareDeleteConfirm(String name) {
    return 'ต้องการลบ \"$name\" ใช่หรือไม่?\nการกระทำนี้ไม่สามารถย้อนกลับได้';
  }

  @override
  String get hardwareLabelIpAddress => 'IP Address';

  @override
  String get hardwareHintIp => '192.168.1.xxx';

  @override
  String get hardwareLabelPort => 'Port';

  @override
  String get hardwareHintPort => '9100';

  @override
  String get hardwareLabelUsbPath => 'USB Device Path';

  @override
  String get hardwareHintUsb => '/dev/usb/lp0';

  @override
  String get hardwareScanUsb => 'สแกน USB';

  @override
  String get hardwareLabelBtAddress => 'Bluetooth Address';

  @override
  String get hardwareHintBt => 'AA:BB:CC:DD:EE:FF';

  @override
  String get hardwareScanBt => 'สแกน BT';

  @override
  String get hardwareTestPrintSuccess => 'ส่งงานพิมพ์สำเร็จ';

  @override
  String get hardwareTestPrintSending => 'กำลังส่งงานพิมพ์...';

  @override
  String get hardwareTestPrintDialogTitle => 'ทดสอบพิมพ์';

  @override
  String hardwareTestPrintCheckPaper(String name) {
    return 'ตรวจสอบกระดาษที่ออกจาก $name';
  }

  @override
  String hardwareTestPrintDeviceLine(String name) {
    return 'อุปกรณ์: $name';
  }

  @override
  String get hardwarePrintTestAction => 'พิมพ์ทดสอบ';

  @override
  String get hardwareScanDialogTitle => 'สแกนหาอุปกรณ์';

  @override
  String get hardwareScanningNetwork => 'กำลังสแกนเครือข่าย...';

  @override
  String get hardwareScanningUsb => 'กำลังสแกน USB...';

  @override
  String get hardwareScanningBluetooth => 'กำลังสแกน Bluetooth...';

  @override
  String get hardwareDevicesFoundNone => 'ไม่พบอุปกรณ์';

  @override
  String hardwareDevicesFoundCount(int count) {
    return 'พบ $count อุปกรณ์';
  }

  @override
  String get hardwareEmptyTitle => 'ยังไม่มีอุปกรณ์';

  @override
  String get hardwareEmptySubtitle =>
      'เพิ่มเครื่องพิมพ์หรือลิ้นชักเงินเพื่อเริ่มต้น';

  @override
  String get hardwareEmptyAddFirst => 'เพิ่มอุปกรณ์แรก';
}
