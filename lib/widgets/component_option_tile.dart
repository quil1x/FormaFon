// lib/widgets/component_option_tile.dart
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/phone_component.dart';

class ComponentOptionTile extends StatefulWidget {
  final PhoneComponent component;
  final bool isSelected;
  final VoidCallback onSelected;

  const ComponentOptionTile({
    super.key,
    required this.component,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  State<ComponentOptionTile> createState() => _ComponentOptionTileState();
}

class _ComponentOptionTileState extends State<ComponentOptionTile> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    if (widget.isSelected) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant ComponentOptionTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) _animationController.forward();
      else _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context)!;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => _animationController.forward(),
        onTapUp: (_) {
          if (!widget.isSelected) _animationController.reverse();
          widget.onSelected();
        },
        onTapCancel: () {
          if (!widget.isSelected) _animationController.reverse();
        },
        child: Card(
          color: widget.isSelected ? colorScheme.primary.withOpacity(0.1) : colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: widget.isSelected ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.1),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: widget.component.placeholderColor.withOpacity(0.1),
                  child: Icon(widget.component.category.icon, color: widget.component.placeholderColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.getComponentName(widget.component.id),
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        localizations.getComponentDescription(widget.component.id),
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.7)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: widget.isSelected
                      ? Icon(Icons.check_circle, color: colorScheme.primary, size: 24, key: const ValueKey('selected'))
                      : Icon(Icons.add_circle_outline, color: colorScheme.onSurface.withOpacity(0.3), size: 24, key: const ValueKey('unselected')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}