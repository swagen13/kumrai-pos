import 'dart:async';
import '../../../data/models/dining_table.dart';

// ─────────────────────────────────────────────────────────────────────────────
// TablesState
//
// Immutable snapshot of the Tables screen's data layer.
// Shaped to be compatible with Riverpod's StateNotifier<TablesState> when
// flutter_riverpod is added to pubspec.yaml.
// ─────────────────────────────────────────────────────────────────────────────
class TablesState {
  const TablesState({
    required this.zones,
    this.selectedZoneIndex = 0,
    this.lastTick,
  });

  final List<DiningZone> zones;
  final int selectedZoneIndex;

  /// Updated every second by the ticker — triggers buffet countdown rebuilds.
  final DateTime? lastTick;

  List<DiningTable> get allTables =>
      zones.expand((z) => z.tables).toList();

  TablesState copyWith({
    List<DiningZone>? zones,
    int? selectedZoneIndex,
    DateTime? lastTick,
  }) =>
      TablesState(
        zones: zones ?? this.zones,
        selectedZoneIndex: selectedZoneIndex ?? this.selectedZoneIndex,
        lastTick: lastTick ?? this.lastTick,
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// TablesNotifier
//
// Business logic for the Tables screen.
//
// Riverpod migration path:
//   1. Add flutter_riverpod to pubspec.yaml
//   2. Change `class TablesNotifier` to
//      `class TablesNotifier extends StateNotifier<TablesState>`
//   3. Call `state = state.copyWith(...)` instead of `_state = ...`
//   4. Expose as:
//      final tablesProvider =
//        StateNotifierProvider<TablesNotifier, TablesState>(
//          (ref) => TablesNotifier(initialZones: mockZones),
//        );
// ─────────────────────────────────────────────────────────────────────────────
class TablesNotifier {
  TablesNotifier({required List<DiningZone> initialZones})
      : _state = TablesState(zones: initialZones);

  TablesState _state;
  TablesState get state => _state;

  Timer? _ticker;
  void Function()? _onTick;

  // ── Ticker (buffet countdown) ────────────────────────────────────────────

  /// Call from State.initState — starts 1-second buffet countdown ticker.
  void startTicker(void Function() onTick) {
    _onTick = onTick;
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      _state = _state.copyWith(lastTick: DateTime.now());
      _onTick?.call();
    });
  }

  /// Call from State.dispose.
  void stopTicker() => _ticker?.cancel();

  // ── Zone selection ───────────────────────────────────────────────────────

  void selectZone(int index) {
    _state = _state.copyWith(selectedZoneIndex: index);
  }

  // ── Derived queries ──────────────────────────────────────────────────────

  List<DiningTable> tablesOf(DiningZone zone) {
    final idx = _state.selectedZoneIndex;
    if (idx == 0) return zone.tables;
    return _state.zones[idx - 1] == zone ? zone.tables : [];
  }

  bool zoneVisible(DiningZone zone) {
    final idx = _state.selectedZoneIndex;
    return idx == 0 || _state.zones[idx - 1].id == zone.id;
  }

  int get visibleTableCount {
    final idx = _state.selectedZoneIndex;
    return idx == 0
        ? _state.allTables.length
        : _state.zones[idx - 1].tables.length;
  }

  int countStatus(TableStatus s) {
    final tables = _state.selectedZoneIndex == 0
        ? _state.allTables
        : _state.zones[_state.selectedZoneIndex - 1].tables;
    return tables.where((t) => t.status == s).length;
  }
}
