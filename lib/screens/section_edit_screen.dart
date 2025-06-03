import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/canvas_provider.dart';
import '../models/lean_canvas_data.dart';

class SectionEditScreen extends StatefulWidget {
  final int sectionIndex;

  const SectionEditScreen({super.key, required this.sectionIndex}); // Використано super.key

  @override
  State<SectionEditScreen> createState() => _SectionEditScreenState();
}

class _SectionEditScreenState extends State<SectionEditScreen> {
  late CanvasSection _section;
  late Map<String, TextEditingController> _controllers;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _section = Provider.of<CanvasProvider>(context, listen: false).getSection(widget.sectionIndex);
    _controllers = {
      for (var key in _section.fieldKeys)
        key: TextEditingController(text: _section.values[key]),
    };
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); 
      
      Map<String, String> updatedValues = {};
      _controllers.forEach((key, controller) {
        updatedValues[key] = controller.text;
      });

      Provider.of<CanvasProvider>(context, listen: false)
          .updateSection(widget.sectionIndex, updatedValues);
      
      Navigator.pop(context);
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Секцію оновлено!')), // Змінено на const SnackBar
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _section = Provider.of<CanvasProvider>(context, listen: false).getSection(widget.sectionIndex);

    return Scaffold(
      appBar: AppBar(
        title: Text('Редагувати: ${_section.title}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
            tooltip: 'Зберегти',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(_section.description, style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey[700])),
              const SizedBox(height: 20), // Додано const
              ..._section.fieldKeys.asMap().entries.map((entry) {
                int idx = entry.key;
                String fieldKey = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    controller: _controllers[fieldKey],
                    decoration: InputDecoration(
                      labelText: fieldKey,
                      hintText: _section.fieldHints.length > idx ? _section.fieldHints[idx] : '',
                      border: const OutlineInputBorder(), // Додано const
                      helperText: _getFieldHelperText(fieldKey),
                    ),
                    maxLines: _isMultiLineField(fieldKey) ? 3 : 1,
                    // validator: (value) { // Базова валідація, можна розкоментувати
                    //   if (value == null || value.isEmpty) {
                    //     return 'Будь ласка, заповніть поле "$fieldKey"';
                    //   }
                    //   return null;
                    // },
                  ),
                );
              }), // Видалено .toList()
              const SizedBox(height: 20), // Додано const
              ElevatedButton(
                onPressed: _saveForm,
                style: ElevatedButton.styleFrom( // Переміщено style
                  padding: const EdgeInsets.symmetric(vertical: 15), // Додано const
                  textStyle: const TextStyle(fontSize: 16) // Додано const
                ),
                child: const Text('Зберегти зміни'), // Змінено порядок
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isMultiLineField(String fieldKey) {
    List<String> multiLineFields = [
      "Опис рішення", "Структура витрат", "Джерела доходу", "Канали",
      "Існуючі альтернативи", "Несправедлива перевага", "Цільові клієнти та користувачі", "Ранні послідовники (Early Adopters)"
    ];
    return multiLineFields.contains(fieldKey) || fieldKey.toLowerCase().contains("проблема");
  }

   String? _getFieldHelperText(String fieldKey) {
    if (fieldKey == "Унікальна ціннісна пропозиція") {
      return "Єдине, чітке, переконливе повідомлення.";
    }
    if (fieldKey == "Високорівнева концепція (High Level Concept)") {
      return "Наприклад, Flickr для відео.";
    }
    return null;
  }
}