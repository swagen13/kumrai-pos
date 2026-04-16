// ─────────────────────────────────────────────────────────────────────────────
// Output Device models — mirrors the `output_devices` table in the PRD
// ─────────────────────────────────────────────────────────────────────────────

enum OutputDeviceType {
  printer,
  cashDrawer,
  printerWithCashDrawer;

  bool get hasPrinter =>
      this == OutputDeviceType.printer ||
      this == OutputDeviceType.printerWithCashDrawer;
}

enum ConnectType {
  network,
  usb,
  bluetooth;
}

enum DeviceStatus {
  online,
  offline,
  connecting;
}

// Paper width maps to Gprinter models:
//   58mm → GP-58MBIII
//   80mm → GP-L80180I
enum PaperWidth {
  mm58,
  mm80;

  String get model =>
      this == PaperWidth.mm58 ? 'GP-58MBIII' : 'GP-L80180I';
  int get mm => this == PaperWidth.mm58 ? 58 : 80;
}

// ─────────────────────────────────────────────────────────────────────────────
// DisplayCategory — maps food categories to printer stations
// ─────────────────────────────────────────────────────────────────────────────
class DisplayCategory {
  const DisplayCategory({
    required this.id,
    required this.name,
    this.nameEn,
    this.color,
  });

  final String id;
  /// Primary label (Thai in mock data).
  final String name;
  final String? nameEn;
  final int? color; // ARGB hex int, optional accent colour

  String labelForLocale(String languageCode) {
    final useTh = languageCode.toLowerCase().startsWith('th');
    if (useTh) return name;
    return nameEn ?? name;
  }

  @override
  bool operator ==(Object other) =>
      other is DisplayCategory && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

// ─────────────────────────────────────────────────────────────────────────────
// OutputDevice — main device model
// ─────────────────────────────────────────────────────────────────────────────
class OutputDevice {
  OutputDevice({
    required this.id,
    required this.outputName,
    required this.outputType,
    required this.connectType,
    this.ipAddress = '',
    this.port = 9100,
    this.deviceAddress = '',
    this.paperWidth = PaperWidth.mm80,
    this.outputCalls = false,
    this.autoCutter = true,
    this.isActive = true,
    List<String>? displayCategoryIds,
    this.status = DeviceStatus.offline,
  }) : displayCategoryIds = displayCategoryIds ?? [];

  final String id;
  String outputName;
  OutputDeviceType outputType;
  ConnectType connectType;
  String ipAddress;
  int port;
  String deviceAddress; // USB path or Bluetooth MAC
  PaperWidth paperWidth;
  bool outputCalls; // buzzer on order
  bool autoCutter;
  bool isActive;
  List<String> displayCategoryIds; // which categories print here
  DeviceStatus status;

  OutputDevice copyWith({
    String? outputName,
    OutputDeviceType? outputType,
    ConnectType? connectType,
    String? ipAddress,
    int? port,
    String? deviceAddress,
    PaperWidth? paperWidth,
    bool? outputCalls,
    bool? autoCutter,
    bool? isActive,
    List<String>? displayCategoryIds,
    DeviceStatus? status,
  }) {
    return OutputDevice(
      id: id,
      outputName: outputName ?? this.outputName,
      outputType: outputType ?? this.outputType,
      connectType: connectType ?? this.connectType,
      ipAddress: ipAddress ?? this.ipAddress,
      port: port ?? this.port,
      deviceAddress: deviceAddress ?? this.deviceAddress,
      paperWidth: paperWidth ?? this.paperWidth,
      outputCalls: outputCalls ?? this.outputCalls,
      autoCutter: autoCutter ?? this.autoCutter,
      isActive: isActive ?? this.isActive,
      displayCategoryIds: displayCategoryIds ?? List.from(this.displayCategoryIds),
      status: status ?? this.status,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mock data
// ─────────────────────────────────────────────────────────────────────────────
final List<DisplayCategory> mockCategories = [
  const DisplayCategory(id: 'cat1', name: 'ห้องครัวหลัก', nameEn: 'Main kitchen', color: 0xFFE53935),
  const DisplayCategory(id: 'cat2', name: 'สถานีย่าง', nameEn: 'Grill station', color: 0xFFFF6D00),
  const DisplayCategory(id: 'cat3', name: 'บาร์เครื่องดื่ม', nameEn: 'Drinks bar', color: 0xFF1565C0),
  const DisplayCategory(id: 'cat4', name: 'ของหวาน', nameEn: 'Desserts', color: 0xFFE91E63),
  const DisplayCategory(id: 'cat5', name: 'สลัดบาร์', nameEn: 'Salad bar', color: 0xFF2E7D32),
  const DisplayCategory(id: 'cat6', name: 'อาหารทะเล', nameEn: 'Seafood', color: 0xFF00838F),
];

final List<OutputDevice> mockDevices = [
  OutputDevice(
    id: 'dev1',
    outputName: 'เครื่องพิมพ์ครัวหลัก',
    outputType: OutputDeviceType.printer,
    connectType: ConnectType.network,
    ipAddress: '192.168.1.101',
    port: 9100,
    paperWidth: PaperWidth.mm80,
    outputCalls: true,
    autoCutter: true,
    isActive: true,
    displayCategoryIds: ['cat1', 'cat2', 'cat6'],
    status: DeviceStatus.online,
  ),
  OutputDevice(
    id: 'dev2',
    outputName: 'เครื่องพิมพ์บาร์',
    outputType: OutputDeviceType.printer,
    connectType: ConnectType.usb,
    deviceAddress: '/dev/usb/lp0',
    paperWidth: PaperWidth.mm58,
    outputCalls: false,
    autoCutter: true,
    isActive: true,
    displayCategoryIds: ['cat3', 'cat4'],
    status: DeviceStatus.online,
  ),
  OutputDevice(
    id: 'dev3',
    outputName: 'ลิ้นชักเงิน',
    outputType: OutputDeviceType.cashDrawer,
    connectType: ConnectType.network,
    ipAddress: '192.168.1.110',
    port: 9100,
    isActive: true,
    status: DeviceStatus.offline,
  ),
  OutputDevice(
    id: 'dev4',
    outputName: 'เครื่องพิมพ์ใบเสร็จ',
    outputType: OutputDeviceType.printerWithCashDrawer,
    connectType: ConnectType.bluetooth,
    deviceAddress: 'AA:BB:CC:DD:EE:FF',
    paperWidth: PaperWidth.mm80,
    outputCalls: false,
    autoCutter: true,
    isActive: true,
    displayCategoryIds: [],
    status: DeviceStatus.connecting,
  ),
];
