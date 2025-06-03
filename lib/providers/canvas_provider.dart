import 'package:flutter/foundation.dart';
import '../models/lean_canvas_data.dart';

class CanvasProvider with ChangeNotifier {
  final List<CanvasSection> _sections = getInitialCanvasSections();

  List<CanvasSection> get sections => _sections;

  void updateSection(int sectionIndex, Map<String, String> updatedValues) {
    if (sectionIndex >= 0 && sectionIndex < _sections.length) {
      _sections[sectionIndex].values = Map.from(updatedValues); // Створюємо нову мапу
      notifyListeners();
    }
  }

  CanvasSection getSection(int index) {
    return _sections[index];
  }
}