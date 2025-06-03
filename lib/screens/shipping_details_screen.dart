// lib/screens/shipping_details_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/configurator_provider.dart';
// import 'package:flutter/foundation.dart'; // Видалено, оскільки debugPrint є у material.dart

class ShippingDetailsScreen extends StatefulWidget {
  const ShippingDetailsScreen({super.key});

  @override
  State<ShippingDetailsScreen> createState() => _ShippingDetailsScreenState();
}

class _ShippingDetailsScreenState extends State<ShippingDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _cityController = TextEditingController(text: 'Львів');
  final _addressController = TextEditingController();
  final _commentsController = TextEditingController();

  String? _selectedDeliveryService;
  final List<String> _deliveryServices = ['Нова Пошта', 'Укрпошта', 'Meest Express', 'Самовивіз (Львів)'];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final configurator = Provider.of<ConfiguratorProvider>(context, listen: false);
      final shippingData = { /* ... (як було раніше) ... */ };
      debugPrint('Дані для відправки: $shippingData'); // Змінено на debugPrint

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Дякуємо! Ваше замовлення та дані доставки "прийнято"!'),
          backgroundColor: Colors.green.withAlpha((0.7 * 255).round()), // Замінено withOpacity на withAlpha
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 3),
        ),
      );

      configurator.resetConfiguration();
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Будь ласка, виправте помилки у формі.'),
          backgroundColor: Theme.of(context).colorScheme.error,
           behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(10),
        ),
      );
    }
  }

  Widget _buildTextField(BuildContext context, {
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
    String? prefixText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixText: prefixText,
          alignLabelWithHint: maxLines > 1,
        ),
        keyboardType: keyboardType,
        validator: validator,
        maxLines: maxLines,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Дані для Відправки'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Text(
                  'Заповніть для доставки вашого FormaFon',
                  style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary),
                  textAlign: TextAlign.center,
                ),
              ),

              _buildTextField(context, controller: _nameController, label: 'ПІБ (Повністю)', validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Будь ласка, вкажіть ваше ПІБ';
                if (value.trim().split(' ').length < 2) return 'Вкажіть прізвище та ім\'я';
                return null;
              }),
              _buildTextField(context, controller: _phoneController, label: 'Номер телефону', prefixText: '+380 ', keyboardType: TextInputType.phone, validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Вкажіть номер телефону';
                if (!RegExp(r'^\d{9}$').hasMatch(value.replaceAll(RegExp(r'\D'),''))) return 'Введіть 9 цифр після +380';
                return null;
              }),
              _buildTextField(context, controller: _emailController, label: 'Електронна пошта (Email)', keyboardType: TextInputType.emailAddress, validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Вкажіть ваш email';
                if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) return 'Введіть коректний email';
                return null;
              }),
              _buildTextField(context, controller: _cityController, label: 'Місто', validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Вкажіть місто';
                return null;
              }),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Служба доставки'),
                  dropdownColor: theme.colorScheme.surface, // Колір фону випадаючого списку
                  value: _selectedDeliveryService,
                  hint: Text('Оберіть службу', style: TextStyle(color: Colors.grey[500])),
                  items: _deliveryServices.map((String service) {
                    return DropdownMenuItem<String>(
                      value: service,
                      child: Text(service),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() { _selectedDeliveryService = newValue; });
                  },
                  validator: (value) => value == null ? 'Оберіть службу доставки' : null,
                ),
              ),
              _buildTextField(context, controller: _addressController, label: 'Номер відділення / Ваша адреса', maxLines: 2, validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Вкажіть деталі доставки';
                return null;
              }),
              _buildTextField(context, controller: _commentsController, label: 'Коментар до замовлення (необов\'язково)', maxLines: 3),

              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.local_shipping_rounded, size: 22),
                label: const Text('Підтвердити Відправку'),
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}