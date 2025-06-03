// lib/widgets/phone_module_area.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/component_category.dart';
import '../models/phone_component.dart';
import '../providers/configurator_provider.dart';

class PhoneModuleArea extends StatelessWidget {
  final ComponentCategory category;
  final VoidCallback onTap;
  final String areaName;
  final AlignmentGeometry alignment;
  final double widthFactor;
  final double heightFactor;
  final bool isPrimaryHotspot; // Для виділення головного слоту, наприклад, процесора

  const PhoneModuleArea({
    super.key,
    required this.category,
    required this.onTap,
    required this.areaName,
    this.alignment = Alignment.center,
    required this.widthFactor,
    required this.heightFactor,
    this.isPrimaryHotspot = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final configurator = Provider.of<ConfiguratorProvider>(context);
    final PhoneComponent? selectedComponent = configurator.getSelectedComponentForCategory(category);

    return Align(
      alignment: alignment,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.0),
          splashColor: theme.colorScheme.primary.withAlpha((0.1 * 255).round()), // Замінено withOpacity на withAlpha
          highlightColor: theme.colorScheme.primary.withAlpha((0.05 * 255).round()), // Замінено withOpacity на withAlpha
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.all(3.0),
            padding: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              color: selectedComponent != null ? theme.colorScheme.primary.withAlpha((0.08 * 255).round()) : Colors.grey.shade200.withAlpha((0.7 * 255).round()), // Замінено withOpacity на withAlpha
              border: Border.all(
                color: selectedComponent != null ? theme.colorScheme.primary : Colors.grey.shade400,
                width: selectedComponent != null ? 1.8 : 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: selectedComponent != null || isPrimaryHotspot
                  ? [
                      BoxShadow(
                        color: theme.colorScheme.primary.withAlpha(
                            ((isPrimaryHotspot ? 0.25 : 0.15) * 255).round()), // Corrected alpha calculation
                        blurRadius: isPrimaryHotspot ? 6.0 : 4.0, // Blur radius is double
                        spreadRadius: isPrimaryHotspot ? 1.0 : 0.0, // Spread radius is double
                      )
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.03 * 255).round()),
                        blurRadius: 3.0,
                        offset: const Offset(1, 1),
                      )
                    ],
            ),
            child: FittedBox( // Дозволяє вмісту масштабуватися
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    category.icon,
                    size: 22, // Трохи менше для компактності
                    color: selectedComponent != null ? theme.colorScheme.primary : theme.iconTheme.color?.withAlpha((0.6 * 255).round()), // Замінено withOpacity на withAlpha
                  ),
                  const SizedBox(height: 4),
                  Text(
                    areaName,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600, // Жирніше для назви зони
                      fontSize: 10.5,
                      color: selectedComponent != null ? theme.colorScheme.primary : theme.textTheme.bodySmall?.color?.withAlpha((0.8 * 255).round()), // Замінено withOpacity на withAlpha
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AnimatedSize( // Анімація розміру для тексту обраного компонента
                    duration: const Duration(milliseconds: 200),
                    child: selectedComponent != null ? Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Text(
                        selectedComponent.name,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(fontSize: 9, color: theme.textTheme.bodyMedium?.color?.withAlpha((0.9 * 255).round())), // Замінено withOpacity на withAlpha
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ) : Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Text(
                      'тап', // Натисни
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 9, color: theme.textTheme.bodyMedium?.color?.withAlpha((0.5 * 255).round())), // Замінено withOpacity на withAlpha
                      maxLines: 1,
                    ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}