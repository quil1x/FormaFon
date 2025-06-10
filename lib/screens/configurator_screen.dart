// lib/screens/configurator_screen.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/configurator_provider.dart';
import '../models/component_category.dart';
import '../models/phone_component.dart';
import '../widgets/component_option_tile.dart';
import '../widgets/phone_module_area.dart';
import 'summary_screen.dart';

class ConfiguratorScreen extends StatefulWidget {
  const ConfiguratorScreen({super.key});

  @override
  State<ConfiguratorScreen> createState() => _ConfiguratorScreenState();
}

class _ConfiguratorScreenState extends State<ConfiguratorScreen> with TickerProviderStateMixin {
  bool _isFrontView = true;
  late AnimationController _flipAnimationController;
  late Animation<double> _flipAnimation;

  late AnimationController _hotspotAnimationController;
  late List<Animation<double>> _hotspotFadeAnimations;

  final List<Map<String, dynamic>> _backModulesLayout = [
    {'category': ComponentCategory.ram, 'label': 'RAM', 'pos': const Alignment(-0.7, -0.9), 'size': const Size(0.3, 0.15)},
    {'category': ComponentCategory.rearCamera, 'label': 'Камера', 'pos': const Alignment(0.7, -0.9), 'size': const Size(0.3, 0.15)},
    {'category': ComponentCategory.storage, 'label': 'Пам\'ять', 'pos': const Alignment(-0.7, -0.55), 'size': const Size(0.3, 0.15)},
    {'category': ComponentCategory.processor, 'label': 'CPU', 'pos': const Alignment(0.7, -0.55), 'size': const Size(0.3, 0.15), 'isPrimary': true},
    {'category': ComponentCategory.audioChip, 'label': 'Аудіо', 'pos': const Alignment(0.0, -0.2), 'size': const Size(0.3, 0.15)},
    // FIX: Позицію акумулятора змінено з 0.5 на 0.6, щоб посунути його нижче
    {'category': ComponentCategory.battery, 'label': 'Батарея', 'pos': const Alignment(0.0, 0.6), 'size': const Size(0.85, 0.35)},
  ];

  @override
  void initState() {
    super.initState();
    _flipAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _flipAnimationController, curve: Curves.easeInOutSine));

    _hotspotAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _hotspotFadeAnimations = List.generate(
      _backModulesLayout.length,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _hotspotAnimationController, curve: Interval((0.15 * index) / (_backModulesLayout.length * 0.15 + 0.4), 1.0, curve: Curves.easeOut)),
      ),
    );

    if (!_isFrontView) {
      Future.delayed(_flipAnimationController.duration ?? const Duration(milliseconds: 600), () {
        if (mounted && !_isFrontView) _hotspotAnimationController.forward();
      });
    }
  }

  void _toggleView(bool isFront) {
    setState(() {
      _isFrontView = isFront;
      if (_isFrontView) {
        if (_flipAnimationController.status == AnimationStatus.completed) _flipAnimationController.reverse();
        _hotspotAnimationController.reverse();
      } else {
        if (_flipAnimationController.status == AnimationStatus.dismissed) _flipAnimationController.forward();
        _flipAnimationController.forward().then((_) {
          if (mounted && !_isFrontView) _hotspotAnimationController.forward();
        });
      }
    });
  }

  @override
  void dispose() {
    _flipAnimationController.dispose();
    _hotspotAnimationController.dispose();
    super.dispose();
  }

  void _showComponentSelectionSheet(BuildContext context, ComponentCategory category, String localizedCategoryName) {
    final configurator = Provider.of<ConfiguratorProvider>(context, listen: false);
    final componentsForCategory = configurator.getComponentsForCategory(category);
    final selectedComponent = configurator.getSelectedComponentForCategory(category);
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.scaffoldBackgroundColor,
      isScrollControlled: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.65,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
                  child: Container(
                    height: 5,
                    width: 40,
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0, top: 8.0),
                  child: Text(
                    '${localizations.get('component_sheet_title')} ${localizedCategoryName.toLowerCase()}',
                    style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary),
                  ),
                ),
                Divider(color: theme.dividerColor.withOpacity(0.1), height: 1),
                Expanded(
                  child: componentsForCategory.isEmpty
                      ? Center(child: Padding(padding: const EdgeInsets.all(20.0), child: Text(localizations.get('no_options_available'))))
                      : ListView.builder(
                          controller: scrollController,
                          itemCount: componentsForCategory.length,
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                          itemBuilder: (listViewCtx, i) {
                            final component = componentsForCategory[i];
                            return ComponentOptionTile(
                              component: component,
                              isSelected: selectedComponent?.id == component.id,
                              onSelected: () {
                                configurator.selectComponent(component);
                                Navigator.of(ctx).pop();
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(localizations.get('configurator_title')),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          const _GeometricBackground(),
          ListView(
            padding: EdgeInsets.only(
              top: kToolbarHeight + MediaQuery.of(context).padding.top + 20,
              bottom: 120,
            ),
            children: [
              _ViewToggle(
                isFrontView: _isFrontView,
                onToggle: (isFront) => _toggleView(isFront),
              ),
              const SizedBox(height: 20),
              Center(
                child: AnimatedBuilder(
                  animation: _flipAnimationController,
                  builder: (context, child) {
                    final angle = _flipAnimation.value * math.pi;
                    final transformFront = Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(angle > math.pi / 2 ? math.pi / 2 : angle);
                    final transformBack = Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(angle < math.pi / 2 ? math.pi / 2 + math.pi : angle + math.pi);

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform(
                          transform: transformFront,
                          alignment: Alignment.center,
                          child: Opacity(opacity: angle < math.pi / 2 ? 1.0 : 0.0, child: _buildPhoneFrontView(context)),
                        ),
                        Transform(
                          transform: transformBack,
                          alignment: Alignment.center,
                          child: Opacity(opacity: angle > math.pi / 2 ? 1.0 : 0.0, child: _buildPhoneBackView(context)),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  localizations.get('software_and_appearance'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              ...[ComponentCategory.operatingSystem, ComponentCategory.phoneCase].map((category) {
                final localizedName = localizations.get(category.agetLocalizationKey);
                return _OptionItem(
                  category: category,
                  onTap: () => _showComponentSelectionSheet(context, category, localizedName),
                );
              }),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextButton.icon(
          icon: const Icon(Icons.checklist_rtl_rounded, size: 20),
          label: Text(localizations.get('summary_button')),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.8),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SummaryScreen())),
        ),
      ),
    );
  }

  Widget _buildPhoneFrontView(BuildContext context) {
    final theme = Theme.of(context);
    final configurator = Provider.of<ConfiguratorProvider>(context);
    final localizations = AppLocalizations.of(context)!;
    final displayCategoryName = localizations.get(ComponentCategory.display.agetLocalizationKey);

    final PhoneComponent? selectedDisplay = configurator.getSelectedComponentForCategory(ComponentCategory.display);
    final PhoneComponent? selectedFrontCamera = configurator.getSelectedComponentForCategory(ComponentCategory.frontCamera);

    final String frontCameraName = selectedFrontCamera != null ? localizations.getComponentName(selectedFrontCamera.id) : localizations.get('unselected');

    return GestureDetector(
      onTap: () => _showComponentSelectionSheet(context, ComponentCategory.display, displayCategoryName),
      child: Container(
        key: const ValueKey('front_view_container'),
        width: 260,
        height: 520,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.grey.shade800, width: 12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, spreadRadius: -5),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Container(
            color: Colors.grey[900],
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(ComponentCategory.display.icon, size: 50, color: Colors.grey[700]),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          selectedDisplay != null ? localizations.getComponentName(selectedDisplay.id) : localizations.get('tap_to_select_display'),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600], fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 25,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Tooltip(
                      message: "${localizations.get('front_camera_tooltip')}: $frontCameraName",
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneBackView(BuildContext context) {
    return Container(
      key: const ValueKey('back_view_container'),
      width: 260,
      height: 520,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.grey.shade400, width: 3),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, spreadRadius: -5),
        ],
      ),
      child: Stack(
        children: _backModulesLayout.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> moduleData = entry.value;
          final localizedName = AppLocalizations.of(context)!.get(
            (moduleData['category'] as ComponentCategory).agetLocalizationKey,
          );
          return FadeTransition(
            opacity: _hotspotFadeAnimations[index],
            child: PhoneModuleArea(
              category: moduleData['category'],
              areaName: localizedName,
              alignment: moduleData['pos'],
              widthFactor: moduleData['size'].width,
              heightFactor: moduleData['size'].height,
              isPrimaryHotspot: moduleData['isPrimary'] ?? false,
              onTap: () => _showComponentSelectionSheet(context, moduleData['category'], localizedName),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ViewToggle extends StatelessWidget {
  final bool isFrontView;
  final Function(bool) onToggle;

  const _ViewToggle({required this.isFrontView, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    final selectedColor = theme.colorScheme.primary;
    final unselectedColor = theme.textTheme.bodyMedium?.color?.withOpacity(0.6);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onToggle(true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isFrontView ? selectedColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  localizations.get('view_screen'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isFrontView ? theme.colorScheme.onPrimary : unselectedColor,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onToggle(false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: !isFrontView ? selectedColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  localizations.get('view_components'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: !isFrontView ? theme.colorScheme.onPrimary : unselectedColor,
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

class _GeometricBackground extends StatelessWidget {
  const _GeometricBackground();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.surface;
    final shadow = theme.colorScheme.shadow.withOpacity(0.1);

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Stack(
        children: [
          Positioned(
            top: -100,
            left: -150,
            child: _Shape(color: color, shadow: shadow, size: 300),
          ),
          Positioned(
            top: 200,
            right: -200,
            child: _Shape(color: color, shadow: shadow, size: 400),
          ),
          Positioned(
            bottom: -50,
            left: -100,
            child: _Shape(color: color, shadow: shadow, size: 250),
          ),
        ],
      ),
    );
  }
}

class _Shape extends StatelessWidget {
  final Color color;
  final Color shadow;
  final double size;

  const _Shape({required this.color, required this.shadow, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(color: shadow, blurRadius: 50, spreadRadius: 10),
        ],
      ),
    );
  }
}

class _OptionItem extends StatelessWidget {
  final ComponentCategory category;
  final VoidCallback onTap;

  const _OptionItem({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final configurator = Provider.of<ConfiguratorProvider>(context);
    final localizations = AppLocalizations.of(context)!;
    final selectedComponent = configurator.getSelectedComponentForCategory(category);
    final localizedCategoryName = localizations.get(category.agetLocalizationKey);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(category.icon, color: theme.colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(localizedCategoryName, style: theme.textTheme.titleMedium),
                  Text(
                    selectedComponent != null
                        ? localizations.getComponentName(selectedComponent.id)
                        : localizations.get('select_option'),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ],
        ),
      ),
    );
  }
}