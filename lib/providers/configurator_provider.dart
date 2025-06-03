// lib/providers/configurator_provider.dart
import 'package:flutter/foundation.dart';
import '../models/phone_component.dart';
import '../models/phone_configuration.dart';
import '../models/component_category.dart';
import '../data/mock_components.dart';

class ConfiguratorProvider with ChangeNotifier {
  PhoneConfiguration _currentConfiguration = PhoneConfiguration();
  final List<PhoneComponent> _availableComponents = mockComponents;

  PhoneConfiguration get currentConfiguration => _currentConfiguration;
  List<PhoneComponent> get availableComponents => _availableComponents;

  List<PhoneComponent> getComponentsForCategory(ComponentCategory category) {
    return _availableComponents.where((comp) => comp.category == category).toList();
  }

  PhoneComponent? getSelectedComponentForCategory(ComponentCategory category) {
    return _currentConfiguration.getComponentForCategory(category);
  }

  void selectComponent(PhoneComponent component) {
    _currentConfiguration.selectComponent(component);
    notifyListeners();
  }

  void clearComponentSelection(ComponentCategory category) {
    _currentConfiguration.clearComponent(category);
    notifyListeners();
  }

  double get totalPrice => _currentConfiguration.totalPrice;

  void resetConfiguration() {
    _currentConfiguration = PhoneConfiguration();
    notifyListeners();
  }
}