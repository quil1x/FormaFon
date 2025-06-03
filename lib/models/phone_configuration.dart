// lib/models/phone_configuration.dart
import './phone_component.dart';
import './component_category.dart';

class PhoneConfiguration {
  Map<ComponentCategory, PhoneComponent?> selectedComponents;

  PhoneConfiguration() : selectedComponents = {
    for (var category in ComponentCategory.values) category: null,
  };

  double get totalPrice {
    double total = 0;
    selectedComponents.forEach((category, component) {
      if (component != null) {
        total += component.price;
      }
    });
    return total;
  }

  void selectComponent(PhoneComponent component) {
    selectedComponents[component.category] = component;
  }

  void clearComponent(ComponentCategory category) {
    selectedComponents[category] = null;
  }

  PhoneComponent? getComponentForCategory(ComponentCategory category) {
    return selectedComponents[category];
  }
}