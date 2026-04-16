import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/kamrai_widgets.dart';
import '../../data/models/dining_table.dart';
import '../../l10n/app_localizations.dart';
import 'providers/tables_provider.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// TablesScreen
// ═══════════════════════════════════════════════════════════════════════════════

class TablesScreen extends StatefulWidget {
  const TablesScreen({super.key});

  @override
  State<TablesScreen> createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
  late final TablesNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = TablesNotifier(initialZones: mockZones);
    // Delegate the 1-second ticker to the provider. On each tick, rebuild the
    // widget so buffet countdown numbers update.
    _notifier.startTicker(() => setState(() {}));
  }

  @override
  void dispose() {
    _notifier.stopTicker();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = _notifier.state;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          // ── Decorative ambient blobs ──────────────────────────────────────
          IgnorePointer(
            child: Stack(children: [
              Positioned(
                top: -60,
                right: -60,
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x08006A30),
                  ),
                ),
              ),
              Positioned(
                bottom: -80,
                left: 40,
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x06FFB300),
                  ),
                ),
              ),
            ]),
          ),
          // ── Main layout ───────────────────────────────────────────────────
          Column(
            children: [
              _NavBar(
                visibleCount: _notifier.visibleTableCount,
                available: _notifier.countStatus(TableStatus.available),
                occupied: _notifier.countStatus(TableStatus.occupied),
                cleaning: _notifier.countStatus(TableStatus.cleaning),
                l10n: l10n,
              ),
              _ZoneTabBar(
                zones: state.zones,
                selectedIndex: state.selectedZoneIndex,
                onZoneSelected: (i) {
                  _notifier.selectZone(i);
                  setState(() {});
                },
                l10n: l10n,
              ),
              Expanded(
                child: _TableFloorPlan(
                  zones: state.zones,
                  zoneVisible: _notifier.zoneVisible,
                  tablesOf: _notifier.tablesOf,
                  onTableTap: (t) => _onTableTap(context, t),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onTableTap(BuildContext context, DiningTable table) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _TableActionSheet(table: table),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// _NavBar
// ═══════════════════════════════════════════════════════════════════════════════

class _NavBar extends StatelessWidget {
  const _NavBar({
    required this.visibleCount,
    required this.available,
    required this.occupied,
    required this.cleaning,
    required this.l10n,
  });

  final int visibleCount;
  final int available;
  final int occupied;
  final int cleaning;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: const BoxDecoration(
            color: Color(0xB3F5F7F9),
            boxShadow: [
              BoxShadow(
                color: Color(0x0F2C2F31),
                blurRadius: 30,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              // Back button — 44×44 touch target
              KamraiNavIconButton(
                icon: Icons.arrow_back_ios_new,
                onTap: () => Navigator.of(context).maybePop(),
              ),
              const SizedBox(width: 6),
              // Screen icon
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.table_restaurant,
                  color: Colors.white,
                  size: 17,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                l10n.tablesFloorPlanTitle,
                style: GoogleFonts.prompt(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '($visibleCount)',
                style: GoogleFonts.prompt(
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 20),
              // Summary stat pills
              KamraiStatPill(
                count: available,
                label: l10n.tablesStatAvailable,
                color: AppColors.statusAvailable,
              ),
              const SizedBox(width: 6),
              KamraiStatPill(
                count: occupied,
                label: l10n.tablesStatOccupied,
                color: AppColors.statusOccupied,
              ),
              const SizedBox(width: 6),
              KamraiStatPill(
                count: cleaning,
                label: l10n.tablesStatCleaning,
                color: AppColors.statusCleaning,
              ),
              const Spacer(),
              KamraiNavIconButton(icon: Icons.qr_code, onTap: () {}),
              const SizedBox(width: 0),
              KamraiNavIconButton(icon: Icons.add_circle_outline, onTap: () {}),
              const SizedBox(width: 0),
              KamraiNavIconButton(icon: Icons.more_vert, onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// _ZoneTabBar
// ═══════════════════════════════════════════════════════════════════════════════

class _ZoneTabBar extends StatelessWidget {
  const _ZoneTabBar({
    required this.zones,
    required this.selectedIndex,
    required this.onZoneSelected,
    required this.l10n,
  });

  final List<DiningZone> zones;
  final int selectedIndex;
  final ValueChanged<int> onZoneSelected;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final allCount = zones.fold(0, (s, z) => s + z.tables.length);

    return Container(
      height: 52,
      decoration: const BoxDecoration(
        color: Color(0xE6FFFFFF),
        border: Border(bottom: BorderSide(color: Color(0x26ABABAF))),
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  _ZoneTab(
                    label: l10n.tablesAllZones,
                    count: allCount,
                    isSelected: selectedIndex == 0,
                    onTap: () => onZoneSelected(0),
                  ),
                  ...zones.asMap().entries.map((e) => _ZoneTab(
                        label: e.value.nameTh,
                        count: e.value.tables.length,
                        isSelected: selectedIndex == e.key + 1,
                        onTap: () => onZoneSelected(e.key + 1),
                      )),
                ],
              ),
            ),
          ),
          // Add zone button — 44px height minimum
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: SizedBox(
              height: 44,
              child: Center(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add, size: 14, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          l10n.tablesAddZone,
                          style: GoogleFonts.prompt(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ZoneTab extends StatelessWidget {
  const _ZoneTab({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: GoogleFonts.prompt(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0x33FFFFFF)
                      : AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  '$count',
                  style: GoogleFonts.prompt(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? Colors.white
                        : AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// _TableFloorPlan — zone-grouped grid using CustomScrollView + slivers
// ═══════════════════════════════════════════════════════════════════════════════

class _TableFloorPlan extends StatelessWidget {
  const _TableFloorPlan({
    required this.zones,
    required this.zoneVisible,
    required this.tablesOf,
    required this.onTableTap,
  });

  final List<DiningZone> zones;
  final bool Function(DiningZone) zoneVisible;
  final List<DiningTable> Function(DiningZone) tablesOf;
  final ValueChanged<DiningTable> onTableTap;

  @override
  Widget build(BuildContext context) {
    final visibleZones = zones.where(zoneVisible).toList();

    return CustomScrollView(
      slivers: [
        for (final zone in visibleZones) ...[
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
            sliver: SliverToBoxAdapter(
              child: _ZoneHeader(zone: zone, tables: tablesOf(zone)),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final table = tablesOf(zone)[i];
                  return _TableCard(
                    table: table,
                    onTap: () => onTableTap(table),
                  );
                },
                childCount: tablesOf(zone).length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
        ],
        const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
      ],
    );
  }
}

class _ZoneHeader extends StatelessWidget {
  const _ZoneHeader({required this.zone, required this.tables});

  final DiningZone zone;
  final List<DiningTable> tables;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final avail = tables.where((t) => t.status == TableStatus.available).length;
    final total = tables.length;

    return Row(
      children: [
        Container(
          width: 3,
          height: 18,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          zone.nameTh,
          style: GoogleFonts.prompt(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          zone.nameEn,
          style: GoogleFonts.prompt(
            fontSize: 12,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0x1A006A30),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            l10n.tablesAvailOfTotal(avail, total),
            style: GoogleFonts.prompt(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// _TableCard
// ═══════════════════════════════════════════════════════════════════════════════

class _TableCard extends StatefulWidget {
  const _TableCard({required this.table, required this.onTap});

  final DiningTable table;
  final VoidCallback onTap;

  @override
  State<_TableCard> createState() => _TableCardState();
}

class _TableCardState extends State<_TableCard> {
  bool _hovered = false;

  Color get _accent {
    switch (widget.table.status) {
      case TableStatus.available:
        return AppColors.statusAvailable;
      case TableStatus.cleaning:
        return AppColors.statusCleaning;
      case TableStatus.occupied:
        if (widget.table.isBuffet) {
          final rem = widget.table.buffetRemaining;
          if (rem.inSeconds <= 0) return AppColors.statusOccupied;
          if (rem.inMinutes <= 15) return AppColors.statusCleaning;
          return AppColors.primary;
        }
        return AppColors.statusOccupied;
    }
  }

  @override
  Widget build(BuildContext context) {
    final table = widget.table;
    final accent = _accent;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: const Color(0xA6FFFFFF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _hovered
                        ? accent.withValues(alpha: 0.5)
                        : accent.withValues(alpha: 0.25),
                    width: _hovered ? 1.5 : 1.0,
                  ),
                  boxShadow: _hovered
                      ? [
                          BoxShadow(
                            color: accent.withValues(alpha: 0.15),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          )
                        ]
                      : [],
                ),
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        KamraiPulseDot(
                          color: accent,
                          size: 8,
                          pulse: table.status != TableStatus.available,
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.people_alt_outlined,
                          size: 12,
                          color: AppColors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${table.capacity}',
                          style: GoogleFonts.prompt(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      table.nameTh,
                      style: GoogleFonts.prompt(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: _hovered ? accent : AppColors.onSurface,
                        height: 1.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    _buildStatusContent(context, table, accent),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusContent(
      BuildContext context, DiningTable table, Color accent) {
    final l10n = AppLocalizations.of(context)!;
    switch (table.status) {
      case TableStatus.available:
        return _StatusBadge(
          label: l10n.tablesStatAvailable,
          color: AppColors.statusAvailable,
        );
      case TableStatus.cleaning:
        return _StatusBadge(
          label: l10n.tablesStatCleaning,
          color: AppColors.statusCleaning,
        );
      case TableStatus.occupied:
        if (table.isBuffet) {
          return _BuffetTimerWidget(table: table, accent: accent, l10n: l10n);
        }
        return _AlaCarteInfo(table: table, l10n: l10n);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _StatusBadge
// ─────────────────────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.prompt(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _AlaCarteInfo
// ─────────────────────────────────────────────────────────────────────────────

class _AlaCarteInfo extends StatelessWidget {
  const _AlaCarteInfo({required this.table, required this.l10n});

  final DiningTable table;
  final AppLocalizations l10n;

  String _fmt(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(Icons.people_alt, size: 13, color: AppColors.statusOccupied),
            const SizedBox(width: 4),
            Text(
              l10n.tablesGuestCount(table.guestCount!, table.capacity),
              style: GoogleFonts.prompt(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.statusOccupied,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.access_time,
              size: 12,
              color: AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: 3),
            Text(
              _fmt(table.elapsed),
              style: GoogleFonts.prompt(
                fontSize: 11,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        _StatusBadge(
          label: l10n.tablesAlaCarte,
          color: AppColors.statusOccupied,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _BuffetTimerWidget
// ─────────────────────────────────────────────────────────────────────────────

class _BuffetTimerWidget extends StatelessWidget {
  const _BuffetTimerWidget({
    required this.table,
    required this.accent,
    required this.l10n,
  });

  final DiningTable table;
  final Color accent;
  final AppLocalizations l10n;

  String _fmt(Duration d) {
    if (d.inSeconds <= 0) return '00:00';
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final remaining = table.buffetRemaining;
    final totalSecs = table.buffetMinutes! * 60;
    final progress = (remaining.inSeconds / totalSecs).clamp(0.0, 1.0);
    final isExpired = remaining.inSeconds <= 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(Icons.people_alt, size: 13, color: accent),
            const SizedBox(width: 4),
            Text(
              l10n.tablesGuestCount(table.guestCount!, table.capacity),
              style: GoogleFonts.prompt(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: accent,
              ),
            ),
            const Spacer(),
            Icon(
              isExpired ? Icons.timer_off : Icons.timer,
              size: 12,
              color: accent,
            ),
            const SizedBox(width: 3),
            Text(
              isExpired
                  ? l10n.tablesTimeUp
                  : l10n.tablesBuffetRemaining(_fmt(remaining)),
              style: GoogleFonts.prompt(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: accent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: accent.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(accent),
            minHeight: 4,
          ),
        ),
        const SizedBox(height: 5),
        _StatusBadge(
          label: isExpired ? l10n.tablesBuffetExpired : l10n.tablesBuffet,
          color: accent,
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// _TableActionSheet — bottom sheet with contextual table actions
// ═══════════════════════════════════════════════════════════════════════════════

class _TableActionSheet extends StatelessWidget {
  const _TableActionSheet({required this.table});

  final DiningTable table;

  Color get _accent {
    switch (table.status) {
      case TableStatus.available:
        return AppColors.statusAvailable;
      case TableStatus.occupied:
        return AppColors.statusOccupied;
      case TableStatus.cleaning:
        return AppColors.statusCleaning;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accent = _accent;

    String statusLabel() {
      switch (table.status) {
        case TableStatus.available:
          return l10n.tablesStatAvailable;
        case TableStatus.occupied:
          return table.isBuffet
              ? l10n.tablesStatusOccupiedBuffet
              : l10n.tablesStatusOccupiedAlaCarte;
        case TableStatus.cleaning:
          return l10n.tablesStatCleaning;
      }
    }

    return Container(
      padding: EdgeInsets.fromLTRB(
          24, 16, 24, MediaQuery.of(context).padding.bottom + 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          // Table info header
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.table_restaurant, color: accent, size: 24),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    table.nameTh,
                    style: GoogleFonts.prompt(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                  Text(
                    '${table.capacity} ${l10n.tablesSeatsUnit}  •  ${statusLabel()}',
                    style: GoogleFonts.prompt(
                      fontSize: 13,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Bill info strip (occupied only)
          if (table.status == TableStatus.occupied) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: accent.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  _InfoChip(
                    icon: Icons.people_alt,
                    label: l10n.tablesGuestCount(
                        table.guestCount!, table.capacity),
                    color: accent,
                  ),
                  const SizedBox(width: 16),
                  if (table.isBuffet)
                    _InfoChip(
                      icon: Icons.timer,
                      label: l10n.tablesBuffetRemaining(
                          _fmtDur(table.buffetRemaining)),
                      color: accent,
                    )
                  else
                    _InfoChip(
                      icon: Icons.access_time,
                      label: _fmtDur(table.elapsed),
                      color: accent,
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0x26ABABAF)),
          const SizedBox(height: 8),
          ..._actions(context, l10n),
          const SizedBox(height: 4),
          // Cancel
          SizedBox(
            width: double.infinity,
            height: 44,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                l10n.commonCancel,
                style: GoogleFonts.prompt(
                  fontSize: 15,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _fmtDur(Duration d) {
    if (d.inSeconds <= 0) return '00:00';
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  List<Widget> _actions(BuildContext context, AppLocalizations l10n) {
    switch (table.status) {
      case TableStatus.available:
        return [
          _ActionTile(
            icon: Icons.receipt_long,
            color: AppColors.primary,
            label: l10n.tablesOpenBillAlaCarte,
            subtitle: l10n.tablesOpenBillAlaCarteSub,
            onTap: () => Navigator.pop(context),
          ),
          _ActionTile(
            icon: Icons.local_dining,
            color: const Color(0xFF9333EA),
            label: l10n.tablesOpenBillBuffet,
            subtitle: l10n.tablesOpenBillBuffetSub,
            onTap: () => Navigator.pop(context),
          ),
          _ActionTile(
            icon: Icons.qr_code,
            color: const Color(0xFF2563EB),
            label: l10n.tablesShowQrOrder,
            subtitle: l10n.tablesShowQrOrderSub,
            onTap: () => Navigator.pop(context),
          ),
        ];
      case TableStatus.occupied:
        return [
          _ActionTile(
            icon: Icons.visibility,
            color: AppColors.primary,
            label: l10n.tablesViewCurrentBill,
            subtitle: l10n.tablesViewCurrentBillSub,
            onTap: () => Navigator.pop(context),
          ),
          _ActionTile(
            icon: Icons.swap_horiz,
            color: const Color(0xFF2563EB),
            label: l10n.tablesMoveTable,
            subtitle: l10n.tablesMoveTableSub,
            onTap: () => Navigator.pop(context),
          ),
          _ActionTile(
            icon: Icons.call_merge,
            color: const Color(0xFFEA580C),
            label: l10n.tablesMergeTables,
            subtitle: l10n.tablesMergeTablesSub,
            onTap: () => Navigator.pop(context),
          ),
          _ActionTile(
            icon: Icons.cleaning_services,
            color: AppColors.statusCleaning,
            label: l10n.tablesSetCleaning,
            subtitle: l10n.tablesSetCleaningSub,
            onTap: () => Navigator.pop(context),
          ),
        ];
      case TableStatus.cleaning:
        return [
          _ActionTile(
            icon: Icons.check_circle,
            color: AppColors.statusAvailable,
            label: l10n.tablesMarkReady,
            subtitle: l10n.tablesMarkReadySub,
            onTap: () => Navigator.pop(context),
          ),
          _ActionTile(
            icon: Icons.receipt_long,
            color: AppColors.primary,
            label: l10n.tablesOpenBillSkipClean,
            subtitle: l10n.tablesOpenBillSkipCleanSub,
            onTap: () => Navigator.pop(context),
          ),
        ];
    }
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.prompt(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.color,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          // vertical 10 + icon 40 + bottom 10 = 60px — well above 44px minimum
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.prompt(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.prompt(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.outlineVariant,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
