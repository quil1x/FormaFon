// lib/widgets/component_option_tile.dart
import 'package:flutter/material.dart';
import '../models/phone_component.dart';
// import '../models/component_category.dart'; // Видалено, оскільки не використовується напряму

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
  Animation<Color?>? _borderColorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180), // Швидша анімація
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = Theme.of(context);
    _borderColorAnimation = ColorTween(
      begin: Colors.grey.shade300, // Колір неактивного бордюру
      end: theme.colorScheme.primary,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    if (widget.isSelected) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void didUpdateWidget(covariant ComponentOptionTile oldWidget) {
    super.didUpdateWidget(oldWidget);
     if (widget.isSelected != oldWidget.isSelected) {
        if (widget.isSelected) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
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
    final Color selectedColor = theme.colorScheme.primary;
    final Color defaultCardColor = theme.cardTheme.color ?? theme.colorScheme.surface;
    // Для світлої теми, фон обраної картки може бути трохи темнішим або з акцентним відтінком
    final Color selectedBgColor = selectedColor.withAlpha((0.08 * 255).round()); // Замінено withOpacity на withAlpha


    return ScaleTransition(
      scale: _scaleAnimation,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Card(
            elevation: widget.isSelected ? 4.0 : (theme.cardTheme.elevation ?? 1.5),
            color: widget.isSelected ? selectedBgColor : defaultCardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: BorderSide(
                color: _borderColorAnimation?.value ?? (widget.isSelected ? selectedColor : Colors.grey.shade300),
                width: widget.isSelected ? 2.0 : 1.0,
              ),
            ),
            margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 0),
            child: InkWell(
              onTap: widget.onSelected,
              borderRadius: BorderRadius.circular(11.0),
              splashColor: selectedColor.withAlpha((0.1 * 255).round()), // Замінено withOpacity на withAlpha
              highlightColor: selectedColor.withAlpha((0.05 * 255).round()), // Замінено withOpacity на withAlpha
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.isSelected ? selectedColor : widget.component.placeholderColor.withAlpha((0.15 * 255).round()), // Замінено withOpacity на withAlpha
                        border: Border.all(
                          color: widget.isSelected ? selectedColor.withAlpha((0.5 * 255).round()) : widget.component.placeholderColor.withAlpha((0.3 * 255).round()), // Замінено withOpacity на withAlpha
                          width: 1
                        )
                      ),
                      child: Icon(
                        widget.component.category.icon,
                        color: widget.isSelected ? theme.colorScheme.onPrimary : widget.component.placeholderColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.component.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600, // Жирніше
                              fontSize: 16,
                              color: widget.isSelected ? selectedColor : theme.textTheme.titleMedium?.color,
                            )
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.component.description,
                            style: theme.textTheme.bodySmall?.copyWith(fontSize: 13, height: 1.3, color: theme.textTheme.bodySmall?.color?.withAlpha((0.9 * 255).round())), // Замінено withOpacity на withAlpha
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${widget.component.price.toStringAsFixed(0)} грн', // ЗМІНЕНО ВАЛЮТУ
                            style: TextStyle(
                              color: widget.isSelected ? selectedColor : theme.colorScheme.primary,
                              fontWeight: FontWeight.bold, // Жирніше ціну
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(scale: animation, alignment: Alignment.center, child: child),
                        );
                      },
                      child: widget.isSelected
                          ? Icon(Icons.check_circle_rounded, color: selectedColor, size: 28, key: const ValueKey('selected_check_light_theme'))
                          : Icon(Icons.add_circle_outline_rounded, color: theme.iconTheme.color?.withAlpha((0.4 * 255).round()), size: 28, key: const ValueKey('unselected_add_light_theme')), // Замінено withOpacity на withAlpha
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}