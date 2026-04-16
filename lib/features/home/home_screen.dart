import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/kamrai_widgets.dart';
import '../../l10n/app_localizations.dart';
import '../tables/tables_screen.dart';
import '../hardware/hardware_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// _Module — descriptor for each home-screen card
// ─────────────────────────────────────────────────────────────────────────────
class _Module {
  const _Module({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.iconBgHover,
    required this.iconColorHover,
    required this.title,
    required this.description,
    required this.badge,
    this.onTap,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Color iconBgHover;
  final Color iconColorHover;
  final String title;
  final String description;
  final Widget badge;
  final void Function(BuildContext)? onTap;
}

// ─────────────────────────────────────────────────────────────────────────────
// Badge helpers (private, used only by the module list builder)
// ─────────────────────────────────────────────────────────────────────────────

Widget _redBadge(String text) => _Chip(
      bg: const Color(0x1AB02500),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.error,
          ),
        ),
        const SizedBox(width: 5),
        _labelText(text, AppColors.error),
      ]),
    );

Widget _secondaryBadge(String text) => _Chip(
      bg: AppColors.secondaryContainer,
      child: _labelText(text, AppColors.onSecondaryContainer),
    );

Widget _grayBadge(String text) => _Chip(
      bg: AppColors.surfaceContainerHigh,
      child: _labelText(text, AppColors.onSurfaceVariant),
    );

Widget _textBadge(String text, Color color) => Text(
      text,
      style: GoogleFonts.prompt(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );

Widget _trendBadge(String text) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.trending_up, size: 14, color: AppColors.primary),
        const SizedBox(width: 4),
        _textBadge(text, AppColors.primary),
      ],
    );

Widget _dotsBadge({required List<bool> dots}) => Row(
      mainAxisSize: MainAxisSize.min,
      children: dots
          .map((on) => Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: on ? AppColors.online : AppColors.outlineVariant,
                ),
              ))
          .toList(),
    );

class _Chip extends StatelessWidget {
  const _Chip({required this.bg, required this.child});
  final Color bg;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
        ),
        child: child,
      );
}

Text _labelText(String t, Color c) => Text(
      t.toUpperCase(),
      style: GoogleFonts.prompt(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: c,
        letterSpacing: 0.6,
      ),
    );

// ─────────────────────────────────────────────────────────────────────────────
// Module list builder — reads l10n from context so strings are localised
// ─────────────────────────────────────────────────────────────────────────────
List<_Module> _buildModules(AppLocalizations l10n) => [
      _Module(
        icon: Icons.point_of_sale,
        iconBg: const Color(0x1A006A30),
        iconColor: AppColors.primary,
        iconBgHover: AppColors.primary,
        iconColorHover: Colors.white,
        title: l10n.modulePosTitle,
        description: l10n.modulePosDescription,
        badge: _redBadge(l10n.modulePosBadge),
      ),
      _Module(
        icon: Icons.table_restaurant,
        iconBg: const Color(0x1A705900),
        iconColor: const Color(0xFF624D00),
        iconBgHover: const Color(0xFF705900),
        iconColorHover: const Color(0xFF584500),
        title: l10n.moduleTableTitle,
        description: l10n.moduleTableDescription,
        badge: _secondaryBadge(l10n.moduleTableBadge),
        onTap: (ctx) => Navigator.of(ctx).push(
          MaterialPageRoute(builder: (_) => const TablesScreen()),
        ),
      ),
      _Module(
        icon: Icons.restaurant_menu,
        iconBg: const Color(0xFFFFEDD5),
        iconColor: const Color(0xFFEA580C),
        iconBgHover: const Color(0xFFF97316),
        iconColorHover: Colors.white,
        title: l10n.moduleMenuTitle,
        description: l10n.moduleMenuDescription,
        badge: _grayBadge(l10n.moduleMenuBadge),
      ),
      _Module(
        icon: Icons.inventory,
        iconBg: const Color(0xFFDBEAFE),
        iconColor: const Color(0xFF2563EB),
        iconBgHover: const Color(0xFF3B82F6),
        iconColorHover: Colors.white,
        title: l10n.moduleInventoryTitle,
        description: l10n.moduleInventoryDescription,
        badge: _redBadge(l10n.moduleInventoryBadge),
      ),
      _Module(
        icon: Icons.groups,
        iconBg: const Color(0xFFF3E8FF),
        iconColor: const Color(0xFF9333EA),
        iconBgHover: const Color(0xFFA855F7),
        iconColorHover: Colors.white,
        title: l10n.moduleLoyaltyTitle,
        description: l10n.moduleLoyaltyDescription,
        badge: _textBadge(l10n.moduleLoyaltyBadge, AppColors.primary),
      ),
      _Module(
        icon: Icons.domain,
        iconBg: const Color(0xFFF1F5F9),
        iconColor: const Color(0xFF475569),
        iconBgHover: const Color(0xFF1E293B),
        iconColorHover: Colors.white,
        title: l10n.moduleEnterpriseTitle,
        description: l10n.moduleEnterpriseDescription,
        badge:
            _textBadge(l10n.moduleEnterpriseBadge, AppColors.onSurfaceVariant),
      ),
      _Module(
        icon: Icons.settings_remote,
        iconBg: const Color(0xFFF3F4F6),
        iconColor: const Color(0xFF4B5563),
        iconBgHover: const Color(0xFF6B7280),
        iconColorHover: Colors.white,
        title: l10n.moduleHardwareTitle,
        description: l10n.moduleHardwareDescription,
        badge: _dotsBadge(dots: [true, true, false]),
        onTap: (ctx) => Navigator.of(ctx).push(
          MaterialPageRoute(builder: (_) => const HardwareScreen()),
        ),
      ),
      _Module(
        icon: Icons.analytics,
        iconBg: const Color(0x1A006A30),
        iconColor: AppColors.primary,
        iconBgHover: AppColors.primary,
        iconColorHover: Colors.white,
        title: l10n.moduleSalesTitle,
        description: l10n.moduleSalesDescription,
        badge: _trendBadge(l10n.moduleSalesBadge),
      ),
    ];

// ═══════════════════════════════════════════════════════════════════════════════
// HomeScreen
// ═══════════════════════════════════════════════════════════════════════════════

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          // ── Ambient decorative blobs ──────────────────────────────────────
          IgnorePointer(
            child: Stack(children: [
              Positioned(
                top: size.height * 0.1,
                right: size.width * 0.05,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x0A006A30),
                  ),
                ),
              ),
              Positioned(
                bottom: size.height * 0.1,
                left: size.width * 0.05,
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x0A705900),
                  ),
                ),
              ),
            ]),
          ),
          // ── Main layout ───────────────────────────────────────────────────
          Column(
            children: [
              const _NavBar(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 20, 32, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _WelcomeHeader(),
                      const SizedBox(height: 14),
                      const Expanded(child: _ModuleGrid()),
                      const SizedBox(height: 18),
                      const SizedBox(height: 180, child: _FooterSection()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// _NavBar
// ═══════════════════════════════════════════════════════════════════════════════

class _NavBar extends StatelessWidget {
  const _NavBar();

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 32),
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
              const _NavLogo(),
              const Spacer(),
              const _HardwareStatusBar(),
              const Spacer(),
              const _UserSection(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _NavLogo
// ─────────────────────────────────────────────────────────────────────────────

class _NavLogo extends StatelessWidget {
  const _NavLogo();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Color(0x40006A30),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.storefront, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 10),
        ShaderMask(
          shaderCallback: (b) =>
              AppColors.primaryGradient.createShader(b),
          child: Text(
            l10n.appNameNav,
            style: GoogleFonts.prompt(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _HardwareStatusBar
// ─────────────────────────────────────────────────────────────────────────────

class _HardwareStatusBar extends StatelessWidget {
  const _HardwareStatusBar();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0x80EEF1F3),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StatusItem(
            icon: Icons.print,
            label: l10n.navPrinter,
            showDot: true,
          ),
          _NavDivider(),
          _StatusItem(
            icon: Icons.account_balance_wallet,
            label: l10n.navDrawer,
            showDot: true,
          ),
          _NavDivider(),
          _StatusItem(
            icon: Icons.wifi,
            label: l10n.navSystemStable,
            showDot: false,
          ),
        ],
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  const _StatusItem({
    required this.icon,
    required this.label,
    required this.showDot,
  });

  final IconData icon;
  final String label;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.online, size: 17),
        const SizedBox(width: 6),
        Text(
          label.toUpperCase(),
          style: GoogleFonts.prompt(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurfaceVariant,
            letterSpacing: 0.8,
          ),
        ),
        if (showDot) ...[
          const SizedBox(width: 6),
          const KamraiPulseDot(color: AppColors.online, size: 6),
        ],
      ],
    );
  }
}

class _NavDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 1,
        height: 12,
        margin: const EdgeInsets.symmetric(horizontal: 14),
        color: const Color(0x4DABABAF),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// _UserSection
// ─────────────────────────────────────────────────────────────────────────────

class _UserSection extends StatelessWidget {
  const _UserSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Branch selector
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0x80D0D4D7),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.sync, size: 14, color: AppColors.onSurfaceVariant),
              const SizedBox(width: 6),
              Text(
                l10n.branchSampleName,
                style: GoogleFonts.prompt(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Container(width: 1, height: 24, color: const Color(0x4DABABAF)),
        const SizedBox(width: 16),
        // User info
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              l10n.userRoleStoreManager,
              style: GoogleFonts.prompt(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
                height: 1.2,
              ),
            ),
            Text(
              l10n.userCompanyName,
              style: GoogleFonts.prompt(
                fontSize: 10,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        // Avatar with online indicator
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: const [
                  BoxShadow(color: Color(0x1A000000), blurRadius: 4),
                ],
              ),
              child: Center(
                child: Text(
                  l10n.userInitials,
                  style: GoogleFonts.prompt(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -1,
              right: -1,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.online,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// _WelcomeHeader
// ═══════════════════════════════════════════════════════════════════════════════

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.welcomeTitle,
          style: GoogleFonts.prompt(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          l10n.welcomeSubtitle,
          style: GoogleFonts.prompt(
            fontSize: 14,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// _ModuleGrid
// ═══════════════════════════════════════════════════════════════════════════════

class _ModuleGrid extends StatelessWidget {
  const _ModuleGrid();

  @override
  Widget build(BuildContext context) {
    final modules = _buildModules(AppLocalizations.of(context)!);
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.35,
      ),
      itemCount: modules.length,
      itemBuilder: (context, i) => _ModuleCard(module: modules[i]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ModuleCard
// ─────────────────────────────────────────────────────────────────────────────

class _ModuleCard extends StatefulWidget {
  const _ModuleCard({required this.module});
  final _Module module;

  @override
  State<_ModuleCard> createState() => _ModuleCardState();
}

class _ModuleCardState extends State<_ModuleCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final m = widget.module;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => widget.module.onTap?.call(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
          child: KamraiGlassCard(
            padding: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon box — 44×44px minimum touch / visual target
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _hovered ? m.iconBgHover : m.iconBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      m.icon,
                      size: 22,
                      color: _hovered ? m.iconColorHover : m.iconColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    m.title,
                    style: GoogleFonts.prompt(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _hovered ? AppColors.primary : AppColors.onSurface,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Expanded(
                    child: Text(
                      m.description,
                      style: GoogleFonts.prompt(
                        fontSize: 11,
                        color: AppColors.onSurfaceVariant,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 6),
                  m.badge,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// _FooterSection
// ═══════════════════════════════════════════════════════════════════════════════

class _FooterSection extends StatelessWidget {
  const _FooterSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        // ── Promo card ──────────────────────────────────────────────────────
        Expanded(
          flex: 2,
          child: KamraiGlassCard(
            borderRadius: 20,
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 110,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF004D23), AppColors.primaryContainer],
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.storefront,
                        size: 36,
                        color: Color(0x80FFFFFF),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.footerPremiumTag,
                        style: GoogleFonts.prompt(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.footerPremiumTitle,
                        style: GoogleFonts.prompt(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.onSurface,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.footerPremiumBody,
                        style: GoogleFonts.prompt(
                          fontSize: 12,
                          color: AppColors.onSurfaceVariant,
                          height: 1.45,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      _GradientButton(
                        label: l10n.footerLearnMore,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 20),
        // ── Support card ────────────────────────────────────────────────────
        SizedBox(
          width: 240,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33006A30),
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.footerSupportTitle,
                  style: GoogleFonts.prompt(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onPrimaryVariant,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.footerSupportBody,
                  style: GoogleFonts.prompt(
                    fontSize: 12,
                    color: const Color(0xCCCEFFD2),
                    height: 1.45,
                  ),
                  maxLines: 3,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    // 44px minimum touch target
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(
                      color: const Color(0x1AFFFFFF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0x33FFFFFF)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.headset_mic,
                            color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            l10n.footerContactStaff,
                            style: GoogleFonts.prompt(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _GradientButton
// ─────────────────────────────────────────────────────────────────────────────

class _GradientButton extends StatefulWidget {
  const _GradientButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hovered ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.all(Radius.circular(999)),
              boxShadow: [
                BoxShadow(
                  color: Color(0x33006A30),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
            child: Text(
              widget.label,
              style: GoogleFonts.prompt(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
