// lib/widgets/phone_slot_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/component_category.dart';
import '../models/phone_component.dart';
import '../providers/configurator_provider.dart';

class PhoneSlotWidget extends StatelessWidget {
  final ComponentCategory category;
  final VoidCallback onTap;

  const PhoneSlotWidget({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final configurator = Provider.of<ConfiguratorProvider>(context);
    final PhoneComponent? selectedComponent = configurator.getSelectedComponentForCategory(category);

    return AspectRatio(
      aspectRatio: 3 / 2, // Співвідношення сторін для слота
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        splashColor: theme.colorScheme.secondary.withAlpha((0.3 * 255).round()), // Замінено withOpacity на withAlpha
        highlightColor: theme.colorScheme.secondary.withAlpha((0.2 * 255).round()), // Замінено withOpacity на withAlpha
        child: Card(
          elevation: selectedComponent != null ? 6 : 3,
          color: selectedComponent != null 
                 ? theme.colorScheme.secondary.withAlpha((0.1 * 255).round()) // Замінено withOpacity на withAlpha
                 : theme.colorScheme.surface.withAlpha((0.8 * 255).round()), // Замінено withOpacity на withAlpha
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(
              color: selectedComponent != null ? theme.colorScheme.secondary : theme.colorScheme.surface,
              width: selectedComponent != null ? 2.0 : 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  category.icon,
                  size: 30, // Розмір іконки категорії
                  color: selectedComponent != null ? theme.colorScheme.secondary : theme.iconTheme.color?.withAlpha((0.7 * 255).round()), // Замінено withOpacity на withAlpha
                ),
                const SizedBox(height: 8),
                Text(
                  category.displayName,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: selectedComponent != null ? theme.colorScheme.secondary : theme.textTheme.bodySmall?.color,
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: Text(
                    selectedComponent?.name ?? 'Не обрано',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      color: selectedComponent != null 
                             ? theme.textTheme.bodyMedium?.color 
                             : theme.textTheme.bodySmall?.color?.withAlpha((0.6 * 255).round()),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}