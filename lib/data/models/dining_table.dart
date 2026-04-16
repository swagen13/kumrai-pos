// ─────────────────────────────────────────────────────────────────────────────
// Dining Table models — mirrors the PRD schema (tables / table_zones tables)
// ─────────────────────────────────────────────────────────────────────────────

enum TableStatus {
  available,
  occupied,
  cleaning;

  String get labelTh {
    switch (this) {
      case TableStatus.available:
        return 'ว่าง';
      case TableStatus.occupied:
        return 'ไม่ว่าง';
      case TableStatus.cleaning:
        return 'ทำความสะอาด';
    }
  }
}

enum BillType {
  alaCarte,
  buffet;
}

class DiningTable {
  const DiningTable({
    required this.id,
    required this.nameTh,
    required this.nameEn,
    required this.capacity,
    required this.status,
    this.billType,
    this.guestCount,
    this.billStartAt,
    this.buffetMinutes,
  });

  /// Matches `table_id` in PRD schema
  final int id;
  final String nameTh;
  final String nameEn;
  final int capacity;
  final TableStatus status;
  final BillType? billType;
  final int? guestCount;
  final DateTime? billStartAt;
  final int? buffetMinutes;

  bool get isBuffet =>
      status == TableStatus.occupied &&
      billType == BillType.buffet &&
      billStartAt != null &&
      buffetMinutes != null;

  Duration get buffetRemaining {
    if (!isBuffet) return Duration.zero;
    final end = billStartAt!.add(Duration(minutes: buffetMinutes!));
    final r = end.difference(DateTime.now());
    return r.isNegative ? Duration.zero : r;
  }

  Duration get elapsed {
    if (billStartAt == null) return Duration.zero;
    return DateTime.now().difference(billStartAt!);
  }
}

class DiningZone {
  const DiningZone({
    required this.id,
    required this.nameTh,
    required this.nameEn,
    required this.tables,
  });

  /// Matches `zone_id` in PRD schema
  final int id;
  final String nameTh;
  final String nameEn;
  final List<DiningTable> tables;
}

// ─────────────────────────────────────────────────────────────────────────────
// Mock data — replace with repository calls once backend is connected
// ─────────────────────────────────────────────────────────────────────────────

final _now = DateTime.now();

final mockZones = <DiningZone>[
  DiningZone(id: 1, nameTh: 'ในร้าน', nameEn: 'Indoor', tables: [
    DiningTable(id: 1, nameTh: 'A1', nameEn: 'A1', capacity: 2, status: TableStatus.available),
    DiningTable(
      id: 2, nameTh: 'A2', nameEn: 'A2', capacity: 4,
      status: TableStatus.occupied, billType: BillType.alaCarte,
      guestCount: 3, billStartAt: _now.subtract(const Duration(minutes: 45)),
    ),
    DiningTable(
      id: 3, nameTh: 'A3', nameEn: 'A3', capacity: 4,
      status: TableStatus.occupied, billType: BillType.buffet,
      guestCount: 4, billStartAt: _now.subtract(const Duration(minutes: 75)),
      buffetMinutes: 120,
    ),
    DiningTable(id: 4, nameTh: 'A4', nameEn: 'A4', capacity: 6, status: TableStatus.available),
    DiningTable(
      id: 5, nameTh: 'A5', nameEn: 'A5', capacity: 6,
      status: TableStatus.occupied, billType: BillType.buffet,
      guestCount: 6, billStartAt: _now.subtract(const Duration(minutes: 108)),
      buffetMinutes: 120,
    ),
    DiningTable(id: 6, nameTh: 'A6', nameEn: 'A6', capacity: 4, status: TableStatus.cleaning),
    DiningTable(id: 7, nameTh: 'A7', nameEn: 'A7', capacity: 4, status: TableStatus.available),
    DiningTable(
      id: 8, nameTh: 'A8', nameEn: 'A8', capacity: 8,
      status: TableStatus.occupied, billType: BillType.alaCarte,
      guestCount: 6, billStartAt: _now.subtract(const Duration(minutes: 20)),
    ),
  ]),
  DiningZone(id: 2, nameTh: 'ระเบียง', nameEn: 'Terrace', tables: [
    DiningTable(id: 9, nameTh: 'B1', nameEn: 'B1', capacity: 2, status: TableStatus.available),
    DiningTable(
      id: 10, nameTh: 'B2', nameEn: 'B2', capacity: 2,
      status: TableStatus.occupied, billType: BillType.alaCarte,
      guestCount: 2, billStartAt: _now.subtract(const Duration(minutes: 30)),
    ),
    DiningTable(id: 11, nameTh: 'B3', nameEn: 'B3', capacity: 4, status: TableStatus.available),
    DiningTable(id: 12, nameTh: 'B4', nameEn: 'B4', capacity: 4, status: TableStatus.cleaning),
    DiningTable(id: 13, nameTh: 'B5', nameEn: 'B5', capacity: 6, status: TableStatus.available),
    DiningTable(
      id: 14, nameTh: 'B6', nameEn: 'B6', capacity: 6,
      status: TableStatus.occupied, billType: BillType.buffet,
      guestCount: 4, billStartAt: _now.subtract(const Duration(minutes: 115)),
      buffetMinutes: 120,
    ),
  ]),
  DiningZone(id: 3, nameTh: 'ห้อง VIP', nameEn: 'VIP Room', tables: [
    DiningTable(id: 15, nameTh: 'VIP 1', nameEn: 'VIP 1', capacity: 8, status: TableStatus.available),
    DiningTable(
      id: 16, nameTh: 'VIP 2', nameEn: 'VIP 2', capacity: 10,
      status: TableStatus.occupied, billType: BillType.alaCarte,
      guestCount: 8, billStartAt: _now.subtract(const Duration(minutes: 60)),
    ),
    DiningTable(id: 17, nameTh: 'VIP 3', nameEn: 'VIP 3', capacity: 12, status: TableStatus.available),
    DiningTable(id: 18, nameTh: 'VIP 4', nameEn: 'VIP 4', capacity: 10, status: TableStatus.cleaning),
  ]),
];
