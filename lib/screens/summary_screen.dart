// lib/screens/summary_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/configurator_provider.dart';
import '../models/component_category.dart';
import '../models/phone_component.dart';
import './shipping_details_screen.dart'; // <-- ПЕРЕВІРТЕ, ЩО ЦЕЙ ІМПОРТ Є І ФАЙЛ ІСНУЄ

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> with TickerProviderStateMixin {
  late AnimationController _listAnimationController;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();
    final categories = _categories();
    _listAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (categories.length * 70) + 200),
    );

    _slideAnimations = [];
    _fadeAnimations = [];

    final configurator = Provider.of<ConfiguratorProvider>(context, listen: false);
    final selectedCount = configurator.currentConfiguration.selectedComponents.values.where((c) => c != null).length;
    final totalDurationFactor = selectedCount > 0 ? (selectedCount * 0.07 + 0.2) : 0.2;

    for (int i = 0; i < categories.length; i++) {
      double startInterval = (i * 0.07) / totalDurationFactor;
      double endInterval = ((i * 0.07) + 0.2) / totalDurationFactor;
      
      endInterval = endInterval > 1.0 ? 1.0 : endInterval;
      startInterval = startInterval > endInterval ? endInterval : (startInterval < 0.0 ? 0.0 : startInterval) ;

      _slideAnimations.add(
        Tween<Offset>(begin: const Offset(0.2, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _listAnimationController,
            curve: Interval(startInterval, endInterval, curve: Curves.easeOutQuart),
          ),
        ),
      );
      _fadeAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _listAnimationController,
             curve: Interval(startInterval, endInterval, curve: Curves.easeIn),
          ),
        ),
      );
    }
    _listAnimationController.forward();
  }

  List<ComponentCategory> _categories() => ComponentCategory.values;

  @override
  void dispose() {
    _listAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final configurator = Provider.of<ConfiguratorProvider>(context, listen: false);
    final configuration = configurator.currentConfiguration;
    final theme = Theme.of(context);

    bool allEssentialComponentsSelected = true;
    List<String> missingComponentNames = [];
    for (var category in _categories()) {
      if (configuration.getComponentForCategory(category) == null) {
          allEssentialComponentsSelected = false;
          missingComponentNames.add(category.displayName);
      }
    }
    String missingComponentsText = missingComponentNames.join(', ');

    if (!allEssentialComponentsSelected && missingComponentNames.isNotEmpty && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
         if(mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Будь ласка, поверніться та оберіть: $missingComponentsText', style: TextStyle(color: theme.colorScheme.onError)),
              backgroundColor: theme.colorScheme.error.withAlpha((0.9 * 255).round()),
              duration: const Duration(seconds: 4),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(10),
            ),
          );
         }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ваш Персональний FormaFon'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _categories().length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0, top: 8.0),
                    child: Text(
                      'Підсумок Конфігурації:',
                      style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                    ),
                  );
                }
                if (index == _categories().length + 1) {
                   return Column(
                     children: [
                        Divider(height: 50, thickness: 1, indent: 10, endIndent: 10, color: theme.dividerColor.withAlpha((0.5*255).round())),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Загальна сума:', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 20)),
                              TweenAnimationBuilder<double>(
                                tween: Tween<double>(begin: 0, end: configurator.totalPrice),
                                duration: const Duration(milliseconds: 800),
                                builder: (context, value, child) {
                                  return Text(
                                    '${value.toStringAsFixed(0)} грн',
                                    style: theme.textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.primary,
                                          fontSize: 22,
                                          letterSpacing: 0.5
                                        ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                     ],
                   );
                }

                final categoryIndex = index - 1;
                final category = _categories()[categoryIndex];
                final PhoneComponent? component = configuration.getComponentForCategory(category);
                final bool isMissing = component == null;

                return FadeTransition(
                  opacity: _fadeAnimations[categoryIndex],
                  child: SlideTransition(
                    position: _slideAnimations[categoryIndex],
                    child: Card(
                      elevation: isMissing ? 1.0 : 2.5,
                      color: isMissing ? theme.colorScheme.surface.withAlpha((0.85 * 255).round()) : theme.cardTheme.color,
                       shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(
                          color: isMissing ? Colors.grey.shade300 : theme.colorScheme.primary.withAlpha((0.3 * 255).round()),
                          width: 0.8,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        leading: CircleAvatar(
                          radius: 22,
                          backgroundColor: isMissing ? Colors.grey.shade200 : component.placeholderColor.withAlpha(50), // Зробив placeholderColor світлішим
                          child: Icon(
                            category.icon,
                            color: isMissing ? Colors.grey.shade500 : component.placeholderColor, // Використовуємо сам placeholderColor для іконки
                            size: 24,
                          ),
                        ),
                        title: Text(
                          category.displayName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isMissing ? theme.textTheme.bodyMedium?.color?.withAlpha((0.6 * 255).round()) : theme.textTheme.bodyLarge?.color,
                            fontSize: 15.5
                          )
                        ),
                        subtitle: Text(
                          isMissing ? 'Не обрано' : component.name,
                          style: TextStyle(color: isMissing ? theme.textTheme.bodySmall?.color?.withAlpha((0.6 * 255).round()) : theme.textTheme.bodyMedium?.color, fontSize: 13.5)
                        ),
                        trailing: isMissing
                            ? null
                            : Text(
                                '+${component.price.toStringAsFixed(0)} грн',
                                style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 14.5)
                              ),
                      ),
                    ),
                  ),
                );
              }
            ),
          ),
           if (!allEssentialComponentsSelected && missingComponentNames.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal:16.0, vertical: 12.0),
              color: theme.colorScheme.error.withAlpha((0.15 * 255).round()),
              child: Text(
                'Будь ласка, поверніться та оберіть компоненти для: $missingComponentsText.',
                style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.w500, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 20.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.local_shipping_outlined, size: 22),
              label: const Text('Перейти до Відправки'),
              style: theme.elevatedButtonTheme.style?.copyWith(
                 backgroundColor: WidgetStateProperty.resolveWith<Color?>( // Виправлено
                  (Set<WidgetState> states) { // Виправлено
                    if (states.contains(WidgetState.disabled)) { // Виправлено
                      return Colors.grey.shade300;
                    }
                    return theme.colorScheme.primary;
                  },
                ),
                foregroundColor: WidgetStateProperty.resolveWith<Color?>( // Виправлено
                    (Set<WidgetState> states) { // Виправлено
                  if (states.contains(WidgetState.disabled)) { // Виправлено
                    return Colors.grey.shade500;
                  }
                  return theme.colorScheme.onPrimary;
                }),
                 padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 18)), // Виправлено
                textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), // Виправлено
              ),
              onPressed: allEssentialComponentsSelected ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ShippingDetailsScreen()),
                );
              } : null,
            ),
          ),
        ],
      ),
    );
  }
}