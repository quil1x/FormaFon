// lib/screens/configurator_screen.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import '../providers/configurator_provider.dart';
import '../models/component_category.dart';
import '../models/phone_component.dart';
import '../widgets/component_option_tile.dart';
import '../widgets/phone_module_area.dart';
import './summary_screen.dart';

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

  // ОНОВЛЕНЕ розташування та розміри для задньої панелі, щоб **гарантовано уникнути накладання**
  // і щоб добре виглядало на телефоні.
  final List<Map<String, dynamic>> _backModulesLayout = [
    // Верхній ряд (3 модулі)
    // Збільшено відступи, щоб модулі були чітко розділені
    {'category': ComponentCategory.rearCamera, 'label': 'Камера', 'pos': const Alignment(-0.65, -0.7), 'size': const Size(0.28, 0.15)}, // Ширина 28%, Висота 15%
    {'category': ComponentCategory.processor, 'label': 'CPU', 'pos': const Alignment(0.0, -0.7), 'size': const Size(0.38, 0.18), 'isPrimary': true}, // Ширина 38%, Висота 18% (трохи більше)
    {'category': ComponentCategory.ram, 'label': 'RAM', 'pos': const Alignment(0.65, -0.7), 'size': const Size(0.28, 0.15)}, // Ширина 28%, Висота 15%

    // Середній ряд (2 модулі)
    // Збільшено відступи, щоб вони не конфліктували
    {'category': ComponentCategory.storage, 'label': 'Пам\'ять', 'pos': const Alignment(-0.4, -0.2), 'size': const Size(0.35, 0.15)}, // Ширина 35%, Висота 15%
    {'category': ComponentCategory.audioChip, 'label': 'Аудіо', 'pos': const Alignment(0.4, -0.2), 'size': const Size(0.35, 0.15)}, // Ширина 35%, Висота 15%

    // Нижній ряд / Центральна частина (1 модуль - Батарея)
    // Батарея займає більшість нижньої частини
    {'category': ComponentCategory.battery, 'label': 'Батарея', 'pos': const Alignment(0, 0.35), 'size': const Size(0.7, 0.4)}, // Ширина 70%, Висота 40%
  ];


  @override
  void initState() {
    super.initState();
    _flipAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipAnimationController, curve: Curves.easeInOutSine)
    );

    _hotspotAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _hotspotFadeAnimations = List.generate(_backModulesLayout.length, (index) =>
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _hotspotAnimationController,
          curve: Interval((0.15 * index) / (_backModulesLayout.length * 0.15 + 0.4), 1.0, curve: Curves.easeOut)
        )
      )
    );

    if (!_isFrontView) {
      Future.delayed(_flipAnimationController.duration ?? const Duration(milliseconds: 600), (){
        if(mounted && !_isFrontView) _hotspotAnimationController.forward();
      });
    }
  }

  void _toggleView() {
    setState(() {
      _isFrontView = !_isFrontView;
      if (_isFrontView) {
        if (_flipAnimationController.status == AnimationStatus.completed) {
           _flipAnimationController.reverse();
        }
        _hotspotAnimationController.reverse();
      } else {
        if (_flipAnimationController.status == AnimationStatus.dismissed) {
           _flipAnimationController.forward();
        }
        _flipAnimationController.forward().then((_) {
          if (mounted && !_isFrontView) {
            _hotspotAnimationController.forward();
          }
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

  void _showComponentSelectionSheet(BuildContext context, ComponentCategory category) {
    final configurator = Provider.of<ConfiguratorProvider>(context, listen: false);
    final componentsForCategory = configurator.getComponentsForCategory(category);
    final selectedComponent = configurator.getSelectedComponentForCategory(category);
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      elevation: 5,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      isScrollControlled: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.65, minChildSize: 0.4, maxChildSize: 0.9, expand: false,
          builder: (_, scrollController) {
            return Column(
              children: [
                 Padding(
                  padding: const EdgeInsets.only(top:12.0, bottom: 4.0),
                  child: Container( height: 5, width: 40, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0, top: 8.0),
                  child: Text(
                    'Оберіть ${category.displayName}',
                    style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary),
                  ),
                ),
                Divider(color: Colors.grey[300], height: 1),
                Expanded(
                  child: componentsForCategory.isEmpty
                      ? const Center(child: Padding(padding: EdgeInsets.all(20.0), child: Text('Немає доступних опцій.', textAlign: TextAlign.center)))
                      : ListView.builder(
                          controller: scrollController,
                          itemCount: componentsForCategory.length,
                          padding: const EdgeInsets.fromLTRB(16,12,16,16),
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

  Widget _buildPhoneFrontView(BuildContext context, ThemeData theme, ConfiguratorProvider configurator) {
    final PhoneComponent? selectedDisplay = configurator.getSelectedComponentForCategory(ComponentCategory.display);
    final PhoneComponent? selectedFrontCamera = configurator.getSelectedComponentForCategory(ComponentCategory.frontCamera);

    return Container(
      key: const ValueKey('front_view_container'),
      width: 260, // Фіксована ширина телефону для симуляції
      height: 520, // Фіксована висота телефону для симуляції
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade800, width: 10),
         boxShadow: [
          BoxShadow(color: Colors.black.withAlpha((0.1 * 255).round()), blurRadius: 12, offset: const Offset(4,4))
        ]
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.grey[900],
          child: InkWell(
            onTap: () => _showComponentSelectionSheet(context, ComponentCategory.display),
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
                          selectedDisplay?.name ?? 'Торкніться, щоб обрати Дисплей',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600], fontSize: 15, fontWeight: FontWeight.w500),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 25,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () => _showComponentSelectionSheet(context, ComponentCategory.frontCamera),
                      customBorder: const CircleBorder(),
                      child: Tooltip(
                        message: "Фронтальна камера: ${selectedFrontCamera?.name ?? 'Не обрано'}",
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: selectedFrontCamera != null ? theme.colorScheme.primary.withAlpha((0.2 * 255).round()) : Colors.black.withAlpha((0.2 * 255).round()),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selectedFrontCamera != null ? theme.colorScheme.primary : Colors.grey.shade700,
                              width: 1.5
                            )
                          ),
                          child: Icon(
                            ComponentCategory.frontCamera.icon,
                            size: selectedFrontCamera != null ? 14 : 12,
                            color: selectedFrontCamera != null ? theme.colorScheme.primary : Colors.grey.shade600
                          ),
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

 Widget _buildPhoneBackView(BuildContext context, ThemeData theme, ConfiguratorProvider configurator) {
    return Container(
      key: const ValueKey('back_view_container'),
      width: 260, // Фіксована ширина телефону для симуляції
      height: 520, // Фіксована висота телефону для симуляції
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade400, width: 3),
         boxShadow: [
          BoxShadow(color: Colors.black.withAlpha((0.1 * 255).round()), blurRadius: 12, offset: const Offset(4,4))
        ]
      ),
      child: Stack(
        children: _backModulesLayout.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> moduleData = entry.value;
          ComponentCategory category = moduleData['category'];
          String label = moduleData['label'];
          AlignmentGeometry pos = moduleData['pos'];
          Size size = moduleData['size'];
          bool isPrimary = moduleData['isPrimary'] ?? false;

          return FadeTransition(
            opacity: _hotspotFadeAnimations[index],
            child: PhoneModuleArea(
              category: category,
              areaName: label,
              alignment: pos,
              widthFactor: size.width,
              heightFactor: size.height,
              isPrimaryHotspot: isPrimary,
              onTap: () => _showComponentSelectionSheet(context, category),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final configurator = Provider.of<ConfiguratorProvider>(context);
    final theme = Theme.of(context);

    final List<ComponentCategory> otherSettingsCategories = [
        ComponentCategory.operatingSystem,
        ComponentCategory.phoneCase,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('FormaFon Конструктор'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 120),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: SegmentedButton<bool>(
              segments: const <ButtonSegment<bool>>[
                ButtonSegment<bool>(value: true, label: Text('Екран'), icon: Icon(Icons.stay_current_portrait)),
                ButtonSegment<bool>(value: false, label: Text('Компоненти'), icon: Icon(Icons.developer_board)),
              ],
              selected: <bool>{_isFrontView},
              onSelectionChanged: (Set<bool> newSelection) {
                if (_isFrontView != newSelection.first) {
                  _toggleView();
                }
              },
              style: SegmentedButton.styleFrom(
                backgroundColor: theme.colorScheme.surface,
                foregroundColor: theme.colorScheme.primary,
                selectedForegroundColor: theme.colorScheme.onPrimary,
                selectedBackgroundColor: theme.colorScheme.primary,
                side: BorderSide(color: theme.colorScheme.primary.withAlpha((0.3 * 255).round())),
                textStyle: const TextStyle(fontWeight: FontWeight.w500)
              ),
            ),
          ),
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
                      child: Opacity(
                        opacity: angle < math.pi / 2 ? 1.0 : 0.0,
                        child: _buildPhoneFrontView(context, theme, configurator),
                      ),
                    ),
                    Transform(
                      transform: transformBack,
                      alignment: Alignment.center,
                      child: Opacity(
                        opacity: angle > math.pi / 2 ? 1.0 : 0.0,
                        child: _buildPhoneBackView(context, theme, configurator),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          if (otherSettingsCategories.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 10.0),
              child: Text("Програмне Забезпечення та Зовнішній Вигляд:", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ),
          ...otherSettingsCategories.map((category) {
              final PhoneComponent? selectedComponent = configurator.getSelectedComponentForCategory(category);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Card(
                  elevation: 1.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.grey.shade300, width: 0.8)
                  ),
                  child: ListTile(
                      leading: Icon(category.icon, color: theme.colorScheme.primary, size: 26),
                      title: Text(category.displayName, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 15.5)),
                      subtitle: Text(selectedComponent?.name ?? 'Обрати', style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13.5, color: theme.textTheme.bodyMedium?.color?.withAlpha((0.7 * 255).round()))),
                      trailing: Icon(Icons.arrow_drop_down_circle_outlined, size: 22, color: theme.iconTheme.color?.withAlpha((0.6 * 255).round())),
                      onTap: () => _showComponentSelectionSheet(context, category),
                  ),
                ),
              );
          }),
          const SizedBox(height: 30),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.checklist_rtl_rounded, size: 24),
          label: const Text('Переглянути Підсумок'),
          style: theme.elevatedButtonTheme.style,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SummaryScreen()),
            );
          },
        ),
      ),
    );
  }
}