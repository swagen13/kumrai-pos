import 'dart:async';
import 'package:flutter/material.dart';
import 'device_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kumrai_pos/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/kamrai_widgets.dart';
import 'device_l10n.dart';
import 'models/output_device.dart';

// ─────────────────────────────────────────────────────────────────────────────
// HardwareScreen — Master-Detail layout for device configuration
// ─────────────────────────────────────────────────────────────────────────────
class HardwareScreen extends StatefulWidget {
  const HardwareScreen({super.key});

  @override
  State<HardwareScreen> createState() => _HardwareScreenState();
}

class _HardwareScreenState extends State<HardwareScreen> {
  final List<OutputDevice> _devices = List.from(mockDevices);
  String? _selectedId;

  OutputDevice? get _selected =>
      _selectedId == null
          ? null
          : _devices.firstWhere((d) => d.id == _selectedId,
              orElse: () => _devices.first);

  void _selectDevice(String id) => setState(() => _selectedId = id);

  void _addDevice() {
    final l10n = AppLocalizations.of(context)!;
    final newId = 'dev${DateTime.now().millisecondsSinceEpoch}';
    final device = OutputDevice(
      id: newId,
      outputName: l10n.hardwareNewDevice,
      outputType: OutputDeviceType.printer,
      connectType: ConnectType.network,
    );
    setState(() {
      _devices.add(device);
      _selectedId = newId;
    });
  }

  void _deleteDevice(String id) {
    setState(() {
      _devices.removeWhere((d) => d.id == id);
      _selectedId = _devices.isNotEmpty ? _devices.first.id : null;
    });
  }

  void _updateDevice(OutputDevice updated) {
    setState(() {
      final idx = _devices.indexWhere((d) => d.id == updated.id);
      if (idx >= 0) _devices[idx] = updated;
    });
  }

  int get _onlineCount =>
      _devices.where((d) => d.status == DeviceStatus.online).length;

  @override
  Widget build(BuildContext context) {
    if (_selectedId == null && _devices.isNotEmpty) {
      _selectedId = _devices.first.id;
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          _NavBar(
            deviceCount: _devices.length,
            onlineCount: _onlineCount,
            onAdd: _addDevice,
          ),
          Expanded(
            child: Row(
              children: [
                // ── Sidebar ──────────────────────────────────────────
                SizedBox(
                  width: 300,
                  child: _DeviceSidebar(
                    devices: _devices,
                    selectedId: _selectedId,
                    onSelect: _selectDevice,
                  ),
                ),
                // ── Divider ──────────────────────────────────────────
                Container(
                  width: 1,
                  color: AppColors.outlineVariant,
                ),
                // ── Detail Panel ─────────────────────────────────────
                Expanded(
                  child: _selected == null
                      ? _EmptyState(onAdd: _addDevice)
                      : _DeviceDetailPanel(
                          key: ValueKey(_selected!.id),
                          device: _selected!,
                          allCategories: mockCategories,
                          onUpdate: _updateDevice,
                          onDelete: () => _deleteDevice(_selected!.id),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _NavBar
// ─────────────────────────────────────────────────────────────────────────────
class _NavBar extends StatelessWidget {
  const _NavBar({
    required this.deviceCount,
    required this.onlineCount,
    required this.onAdd,
  });

  final int deviceCount;
  final int onlineCount;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.outlineVariant),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
            style: IconButton.styleFrom(
              foregroundColor: AppColors.onSurface,
              backgroundColor: const Color(0xFFF5F7F9),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              fixedSize: const Size(40, 40),
            ),
          ),
          const SizedBox(width: 16),
          // Title
          Text(
            l10n.moduleHardwareTitle,
            style: GoogleFonts.prompt(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(width: 12),
          // Device stats pill
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7F9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: Row(
              children: [
                const _StatusDot(color: Color(0xFF00B96B)),
                const SizedBox(width: 6),
                Text(
                  l10n.hardwareOnlineCount(onlineCount, deviceCount),
                  style: GoogleFonts.prompt(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          KamraiButton(
            label: l10n.hardwareAddDevice,
            icon: Icons.add_rounded,
            onPressed: onAdd,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _DeviceSidebar
// ─────────────────────────────────────────────────────────────────────────────
class _DeviceSidebar extends StatelessWidget {
  const _DeviceSidebar({
    required this.devices,
    required this.selectedId,
    required this.onSelect,
  });

  final List<OutputDevice> devices;
  final String? selectedId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              l10n.hardwareAllDevices,
              style: GoogleFonts.prompt(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceVariant,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 16),
              itemCount: devices.length,
              separatorBuilder: (context, i) => const SizedBox(height: 4),
              itemBuilder: (context, i) {
                final d = devices[i];
                return _SidebarCard(
                  device: d,
                  selected: d.id == selectedId,
                  onTap: () => onSelect(d.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarCard extends StatefulWidget {
  const _SidebarCard({
    required this.device,
    required this.selected,
    required this.onTap,
  });

  final OutputDevice device;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_SidebarCard> createState() => _SidebarCardState();
}

class _SidebarCardState extends State<_SidebarCard> {
  bool _hovered = false;

  Color get _statusColor {
    switch (widget.device.status) {
      case DeviceStatus.online:
        return const Color(0xFF00B96B);
      case DeviceStatus.offline:
        return const Color(0xFFABADAF);
      case DeviceStatus.connecting:
        return const Color(0xFFFFB300);
    }
  }

  IconData get _typeIcon {
    switch (widget.device.outputType) {
      case OutputDeviceType.printer:
        return Icons.print_rounded;
      case OutputDeviceType.cashDrawer:
        return Icons.point_of_sale_rounded;
      case OutputDeviceType.printerWithCashDrawer:
        return Icons.receipt_long_rounded;
    }
  }

  IconData get _connectIcon {
    switch (widget.device.connectType) {
      case ConnectType.network:
        return Icons.lan_outlined;
      case ConnectType.usb:
        return Icons.usb_rounded;
      case ConnectType.bluetooth:
        return Icons.bluetooth_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selected = widget.selected;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFFE8F5EE)
                : _hovered
                    ? const Color(0xFFF5F7F9)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? AppColors.primary
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              // Type icon box
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF006A30)
                      : const Color(0xFFF0F2F4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _typeIcon,
                  size: 20,
                  color: selected ? Colors.white : AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.device.outputName,
                      style: GoogleFonts.prompt(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(_connectIcon,
                            size: 11, color: AppColors.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(
                          widget.device.connectType.l10nLabel(l10n),
                          style: GoogleFonts.prompt(
                            fontSize: 11,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        if (widget.device.outputType.hasPrinter) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F2F4),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              widget.device.paperWidth.model,
                              style: GoogleFonts.prompt(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Status dot
              _StatusDot(color: _statusColor),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _DeviceDetailPanel — scrollable right panel
// ─────────────────────────────────────────────────────────────────────────────
class _DeviceDetailPanel extends StatefulWidget {
  const _DeviceDetailPanel({
    super.key,
    required this.device,
    required this.allCategories,
    required this.onUpdate,
    required this.onDelete,
  });

  final OutputDevice device;
  final List<DisplayCategory> allCategories;
  final ValueChanged<OutputDevice> onUpdate;
  final VoidCallback onDelete;

  @override
  State<_DeviceDetailPanel> createState() => _DeviceDetailPanelState();
}

class _DeviceDetailPanelState extends State<_DeviceDetailPanel> {
  late OutputDevice _draft;

  late final TextEditingController _nameCtrl;
  late final TextEditingController _ipCtrl;
  late final TextEditingController _portCtrl;
  late final TextEditingController _addressCtrl;

  @override
  void initState() {
    super.initState();
    _draft = widget.device.copyWith();
    _nameCtrl = TextEditingController(text: _draft.outputName);
    _ipCtrl = TextEditingController(text: _draft.ipAddress);
    _portCtrl =
        TextEditingController(text: _draft.port.toString());
    _addressCtrl = TextEditingController(text: _draft.deviceAddress);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ipCtrl.dispose();
    _portCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final l10n = AppLocalizations.of(context)!;
    _draft
      ..outputName = _nameCtrl.text.trim().isEmpty
          ? l10n.hardwareUnnamedDevice
          : _nameCtrl.text.trim()
      ..ipAddress = _ipCtrl.text.trim()
      ..port = int.tryParse(_portCtrl.text) ?? 9100
      ..deviceAddress = _addressCtrl.text.trim();
    widget.onUpdate(_draft.copyWith(
      outputName: _draft.outputName,
      ipAddress: _draft.ipAddress,
      port: _draft.port,
      deviceAddress: _draft.deviceAddress,
    ));
  }

  void _toggleCategory(String catId) {
    setState(() {
      final ids = List<String>.from(_draft.displayCategoryIds);
      if (ids.contains(catId)) {
        ids.remove(catId);
      } else {
        ids.add(catId);
      }
      _draft = _draft.copyWith(displayCategoryIds: ids);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasPrinter = _draft.outputType.hasPrinter;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Panel header ──────────────────────────────────────────
          _PanelHeader(
            device: _draft,
            onTestPrint: hasPrinter ? _onTestPrint : null,
            onDelete: widget.onDelete,
          ),
          const SizedBox(height: 20),

          // ── Identification ────────────────────────────────────────
          KamraiCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KamraiSectionLabel(l10n.hardwareSectionNameAndType),
                KamraiTextField(
                  label: l10n.hardwareDeviceName,
                  hint: l10n.hardwareDeviceNameHint,
                  controller: _nameCtrl,
                  onChanged: (_) => _save(),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.hardwareOutputType,
                  style: GoogleFonts.prompt(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 6),
                KamraiSegmented<OutputDeviceType>(
                  selected: _draft.outputType,
                  onChanged: (v) {
                    setState(() => _draft = _draft.copyWith(outputType: v));
                    _save();
                  },
                  options: [
                    KamraiSegmentedOption(
                      value: OutputDeviceType.printer,
                      label: l10n.deviceTypePrinter,
                      icon: Icons.print_rounded,
                    ),
                    KamraiSegmentedOption(
                      value: OutputDeviceType.cashDrawer,
                      label: l10n.deviceTypeCashDrawer,
                      icon: Icons.point_of_sale_rounded,
                    ),
                    KamraiSegmentedOption(
                      value: OutputDeviceType.printerWithCashDrawer,
                      label: l10n.deviceTypePrinterWithDrawer,
                      icon: Icons.receipt_long_rounded,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Connectivity ──────────────────────────────────────────
          KamraiCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KamraiSectionLabel(l10n.hardwareConnectSection),
                KamraiSegmented<ConnectType>(
                  selected: _draft.connectType,
                  onChanged: (v) {
                    setState(() => _draft = _draft.copyWith(connectType: v));
                    _save();
                  },
                  options: [
                    KamraiSegmentedOption(
                      value: ConnectType.network,
                      label: l10n.connectTypeNetwork,
                      icon: Icons.lan_outlined,
                      sublabel: l10n.connectSublabelTcpIp,
                    ),
                    KamraiSegmentedOption(
                      value: ConnectType.usb,
                      label: l10n.connectTypeUsb,
                      icon: Icons.usb_rounded,
                      sublabel: l10n.connectSublabelDirect,
                    ),
                    KamraiSegmentedOption(
                      value: ConnectType.bluetooth,
                      label: l10n.connectTypeBluetooth,
                      icon: Icons.bluetooth_rounded,
                      sublabel: l10n.connectSublabelBt40,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _ConnectFields(
                  connectType: _draft.connectType,
                  ipCtrl: _ipCtrl,
                  portCtrl: _portCtrl,
                  addressCtrl: _addressCtrl,
                  onChanged: _save,
                  onScan: _onScan,
                  l10n: l10n,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Printer Settings + Print Routing side by side ─────────
          if (hasPrinter) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Printer Settings
                Expanded(
                  child: KamraiCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        KamraiSectionLabel(l10n.hardwarePrinterSettings),
                        // Paper width
                        Text(
                          l10n.hardwarePaperSize,
                          style: GoogleFonts.prompt(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 6),
                        KamraiSegmented<PaperWidth>(
                          compact: true,
                          selected: _draft.paperWidth,
                          onChanged: (v) {
                            setState(
                                () => _draft = _draft.copyWith(paperWidth: v));
                            _save();
                          },
                          options: [
                            KamraiSegmentedOption(
                              value: PaperWidth.mm58,
                              label: PaperWidth.mm58.l10nLabel(l10n),
                              sublabel: PaperWidth.mm58.model,
                            ),
                            KamraiSegmentedOption(
                              value: PaperWidth.mm80,
                              label: PaperWidth.mm80.l10nLabel(l10n),
                              sublabel: PaperWidth.mm80.model,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Encoding badge
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F2F4),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: AppColors.outlineVariant),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.translate_rounded,
                                      size: 12,
                                      color: AppColors.onSurfaceVariant),
                                  const SizedBox(width: 4),
                                  Text(
                                    l10n.hardwareEncodingCp874,
                                    style: GoogleFonts.prompt(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 1, color: Color(0xFFEEF1F3)),
                        const SizedBox(height: 16),
                        KamraiSwitch(
                          label: l10n.hardwareAutoCutter,
                          sublabel: l10n.hardwareAutoCutterSub,
                          value: _draft.autoCutter,
                          onChanged: (v) {
                            setState(
                                () => _draft = _draft.copyWith(autoCutter: v));
                            _save();
                          },
                        ),
                        const SizedBox(height: 8),
                        KamraiSwitch(
                          label: l10n.hardwareBuzzer,
                          sublabel: l10n.hardwareBuzzerSub,
                          value: _draft.outputCalls,
                          onChanged: (v) {
                            setState(() =>
                                _draft = _draft.copyWith(outputCalls: v));
                            _save();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Print Routing
                Expanded(
                  child: KamraiCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        KamraiSectionLabel(l10n.hardwarePrintRouting),
                        Text(
                          l10n.hardwarePrintRoutingHint,
                          style: GoogleFonts.prompt(
                            fontSize: 12,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...widget.allCategories.map((cat) {
                          final checked = _draft.displayCategoryIds
                              .contains(cat.id);
                          return _CategoryCheckTile(
                            category: cat,
                            checked: checked,
                            onToggle: () => _toggleCategory(cat.id),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // ── Active toggle ─────────────────────────────────────────
          KamraiCard(
            child: KamraiSwitch(
              label: l10n.hardwareEnableDevice,
              sublabel: l10n.hardwareEnableDeviceSub,
              value: _draft.isActive,
              onChanged: (v) {
                setState(() => _draft = _draft.copyWith(isActive: v));
                _save();
              },
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _onTestPrint() {
    showDialog(
      context: context,
      builder: (_) => _TestPrintDialog(device: _draft),
    );
  }

  void _onScan() {
    showDialog(
      context: context,
      builder: (_) => _ScanDeviceDialog(
        connectType: _draft.connectType,
        onSelected: (address) {
          setState(() {
            if (_draft.connectType == ConnectType.network) {
              _ipCtrl.text = address.split(':')[0];
              if (address.contains(':')) {
                _portCtrl.text = address.split(':')[1];
              }
            } else {
              _addressCtrl.text = address;
            }
          });
          _save();
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _PanelHeader — device name + status + action buttons
// ─────────────────────────────────────────────────────────────────────────────
class _PanelHeader extends StatelessWidget {
  const _PanelHeader({
    required this.device,
    required this.onDelete,
    this.onTestPrint,
  });

  final OutputDevice device;
  final VoidCallback? onTestPrint;
  final VoidCallback onDelete;

  Color get _statusColor {
    switch (device.status) {
      case DeviceStatus.online:
        return const Color(0xFF00B96B);
      case DeviceStatus.offline:
        return const Color(0xFFABADAF);
      case DeviceStatus.connecting:
        return const Color(0xFFFFB300);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                device.outputName,
                style: GoogleFonts.prompt(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _StatusDot(color: _statusColor),
                  const SizedBox(width: 6),
                  Text(
                    device.status.l10nLabel(l10n),
                    style: GoogleFonts.prompt(
                      fontSize: 13,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '·',
                    style: GoogleFonts.prompt(
                        fontSize: 13, color: AppColors.outlineVariant),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    device.outputType.l10nLabel(l10n),
                    style: GoogleFonts.prompt(
                      fontSize: 13,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (onTestPrint != null) ...[
          KamraiButton(
            label: l10n.hardwareTestPrint,
            icon: Icons.print_rounded,
            variant: KamraiButtonVariant.secondary,
            onPressed: onTestPrint,
          ),
          const SizedBox(width: 12),
        ],
        KamraiButton(
          label: l10n.hardwareDeleteDevice,
          icon: Icons.delete_outline_rounded,
          variant: KamraiButtonVariant.danger,
          onPressed: () => _confirmDelete(context),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n.hardwareDeleteTitle,
          style: GoogleFonts.prompt(
              fontWeight: FontWeight.w700, color: AppColors.onSurface),
        ),
        content: Text(
          l10n.hardwareDeleteConfirm(device.outputName),
          style: GoogleFonts.prompt(color: AppColors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.commonCancel,
                style: GoogleFonts.prompt(color: AppColors.onSurfaceVariant)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onDelete();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(l10n.commonDelete,
                style: GoogleFonts.prompt(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ConnectFields — dynamic fields based on connect type
// ─────────────────────────────────────────────────────────────────────────────
class _ConnectFields extends StatelessWidget {
  const _ConnectFields({
    required this.connectType,
    required this.ipCtrl,
    required this.portCtrl,
    required this.addressCtrl,
    required this.onChanged,
    required this.onScan,
    required this.l10n,
  });

  final ConnectType connectType;
  final TextEditingController ipCtrl;
  final TextEditingController portCtrl;
  final TextEditingController addressCtrl;
  final VoidCallback onChanged;
  final VoidCallback onScan;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    switch (connectType) {
      case ConnectType.network:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: KamraiTextField(
                label: l10n.hardwareLabelIpAddress,
                hint: l10n.hardwareHintIp,
                controller: ipCtrl,
                keyboardType: TextInputType.number,
                onChanged: (_) => onChanged(),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 100,
              child: KamraiTextField(
                label: l10n.hardwareLabelPort,
                hint: l10n.hardwareHintPort,
                controller: portCtrl,
                keyboardType: TextInputType.number,
                onChanged: (_) => onChanged(),
              ),
            ),
          ],
        );
      case ConnectType.usb:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: KamraiTextField(
                label: l10n.hardwareLabelUsbPath,
                hint: l10n.hardwareHintUsb,
                controller: addressCtrl,
                onChanged: (_) => onChanged(),
              ),
            ),
            const SizedBox(width: 12),
            KamraiButton(
              label: l10n.hardwareScanUsb,
              icon: Icons.search_rounded,
              variant: KamraiButtonVariant.secondary,
              onPressed: onScan,
            ),
          ],
        );
      case ConnectType.bluetooth:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: KamraiTextField(
                label: l10n.hardwareLabelBtAddress,
                hint: l10n.hardwareHintBt,
                controller: addressCtrl,
                onChanged: (_) => onChanged(),
              ),
            ),
            const SizedBox(width: 12),
            KamraiButton(
              label: l10n.hardwareScanBt,
              icon: Icons.bluetooth_searching_rounded,
              variant: KamraiButtonVariant.secondary,
              onPressed: onScan,
            ),
          ],
        );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _CategoryCheckTile
// ─────────────────────────────────────────────────────────────────────────────
class _CategoryCheckTile extends StatelessWidget {
  const _CategoryCheckTile({
    required this.category,
    required this.checked,
    required this.onToggle,
  });

  final DisplayCategory category;
  final bool checked;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final accent = category.color != null
        ? Color(category.color!)
        : AppColors.primary;
    return GestureDetector(
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: checked ? accent : Colors.transparent,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: checked ? accent : AppColors.outlineVariant,
                  width: 1.5,
                ),
              ),
              child: checked
                  ? const Icon(Icons.check_rounded,
                      size: 13, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 10),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: accent,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              category.labelForLocale(lang),
              style: GoogleFonts.prompt(
                fontSize: 13,
                fontWeight:
                    checked ? FontWeight.w600 : FontWeight.w400,
                color: checked ? AppColors.onSurface : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _TestPrintDialog
// ─────────────────────────────────────────────────────────────────────────────
class _TestPrintDialog extends StatefulWidget {
  const _TestPrintDialog({required this.device});
  final OutputDevice device;

  @override
  State<_TestPrintDialog> createState() => _TestPrintDialogState();
}

class _TestPrintDialogState extends State<_TestPrintDialog> {
  bool _printing = false;
  bool _done = false;

  void _print() async {
    setState(() => _printing = true);
    await Future.delayed(const Duration(milliseconds: 1800));
    if (mounted) setState(() {_printing = false; _done = true;});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: _done
                    ? const Color(0xFFE8F5EE)
                    : const Color(0xFFF5F7F9),
                shape: BoxShape.circle,
              ),
              child: _printing
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary),
                    )
                  : Icon(
                      _done
                          ? Icons.check_circle_rounded
                          : Icons.print_rounded,
                      size: 32,
                      color: _done ? AppColors.primary : AppColors.onSurfaceVariant,
                    ),
            ),
            const SizedBox(height: 16),
            Text(
              _done
                  ? l10n.hardwareTestPrintSuccess
                  : _printing
                      ? l10n.hardwareTestPrintSending
                      : l10n.hardwareTestPrintDialogTitle,
              style: GoogleFonts.prompt(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _done
                  ? l10n.hardwareTestPrintCheckPaper(widget.device.outputName)
                  : l10n.hardwareTestPrintDeviceLine(widget.device.outputName),
              style: GoogleFonts.prompt(
                fontSize: 13,
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: KamraiButton(
                    label: l10n.commonClose,
                    variant: KamraiButtonVariant.secondary,
                    onPressed: () => Navigator.of(context).pop(),
                    width: double.infinity,
                  ),
                ),
                if (!_done) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: KamraiButton(
                      label: l10n.hardwarePrintTestAction,
                      icon: Icons.print_rounded,
                      loading: _printing,
                      onPressed: _printing ? null : _print,
                      width: double.infinity,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ScanDeviceDialog — real device discovery
// ─────────────────────────────────────────────────────────────────────────────
class _ScanDeviceDialog extends StatefulWidget {
  const _ScanDeviceDialog({
    required this.connectType,
    required this.onSelected,
  });

  final ConnectType connectType;
  final ValueChanged<String> onSelected;

  @override
  State<_ScanDeviceDialog> createState() => _ScanDeviceDialogState();
}

class _ScanDeviceDialogState extends State<_ScanDeviceDialog> {
  bool _scanning = true;
  List<_FoundDevice> _found = [];

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  Future<void> _startScan() async {
    final results = await DeviceScanner.scan(widget.connectType);
    if (!mounted) return;
    setState(() {
      _scanning = false;
      _found = results.map((d) => _FoundDevice(d.name, d.address)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final icon = widget.connectType == ConnectType.bluetooth
        ? Icons.bluetooth_searching_rounded
        : widget.connectType == ConnectType.usb
            ? Icons.usb_rounded
            : Icons.wifi_find_rounded;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 440,
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 22, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.hardwareScanDialogTitle,
                      style: GoogleFonts.prompt(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      widget.connectType.l10nLabel(l10n),
                      style: GoogleFonts.prompt(
                          fontSize: 12,
                          color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_scanning) ...[
              const LinearProgressIndicator(
                backgroundColor: Color(0xFFEEF1F3),
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
              const SizedBox(height: 12),
              Text(
                switch (widget.connectType) {
                  ConnectType.network => l10n.hardwareScanningNetwork,
                  ConnectType.usb => l10n.hardwareScanningUsb,
                  ConnectType.bluetooth => l10n.hardwareScanningBluetooth,
                },
                style: GoogleFonts.prompt(
                    fontSize: 13, color: AppColors.onSurfaceVariant),
              ),
            ] else if (_found.isEmpty) ...[
              Center(
                child: Text(
                  l10n.hardwareDevicesFoundNone,
                  style: GoogleFonts.prompt(
                      fontSize: 14, color: AppColors.onSurfaceVariant),
                ),
              ),
            ] else ...[
              Text(
                l10n.hardwareDevicesFoundCount(_found.length),
                style: GoogleFonts.prompt(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              ..._found.map((d) => _FoundDeviceTile(
                    device: d,
                    onSelect: () {
                      Navigator.of(context).pop();
                      widget.onSelected(d.address);
                    },
                  )),
            ],
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: KamraiButton(
                label: l10n.commonClose,
                variant: KamraiButtonVariant.ghost,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FoundDevice {
  const _FoundDevice(this.name, this.address);
  final String name;
  final String address;
}

class _FoundDeviceTile extends StatefulWidget {
  const _FoundDeviceTile({required this.device, required this.onSelect});
  final _FoundDevice device;
  final VoidCallback onSelect;

  @override
  State<_FoundDeviceTile> createState() => _FoundDeviceTileState();
}

class _FoundDeviceTileState extends State<_FoundDeviceTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onSelect,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: _hovered
                ? const Color(0xFFE8F5EE)
                : const Color(0xFFF5F7F9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _hovered
                  ? AppColors.primary
                  : const Color(0xFFDFE3E6),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.print_rounded,
                  size: 18, color: AppColors.onSurfaceVariant),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.device.name,
                        style: GoogleFonts.prompt(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface)),
                    Text(widget.device.address,
                        style: GoogleFonts.prompt(
                            fontSize: 11,
                            color: AppColors.onSurfaceVariant)),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: _hovered
                    ? AppColors.primary
                    : AppColors.outlineVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _EmptyState — shown when no device is selected
// ─────────────────────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F2F4),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.devices_other_rounded,
                size: 36, color: AppColors.outlineVariant),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.hardwareEmptyTitle,
            style: GoogleFonts.prompt(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.hardwareEmptySubtitle,
            style: GoogleFonts.prompt(
                fontSize: 13, color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          KamraiButton(
            label: l10n.hardwareEmptyAddFirst,
            icon: Icons.add_rounded,
            onPressed: onAdd,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _StatusDot — small colored indicator dot
// ─────────────────────────────────────────────────────────────────────────────
class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 4),
        ],
      ),
    );
  }
}
