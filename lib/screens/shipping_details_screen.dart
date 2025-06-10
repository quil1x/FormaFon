// lib/screens/shipping_details_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/configurator_provider.dart';

class ShippingDetailsScreen extends StatefulWidget {
  const ShippingDetailsScreen({super.key});

  @override
  State<ShippingDetailsScreen> createState() => _ShippingDetailsScreenState();
}

class _ShippingDetailsScreenState extends State<ShippingDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.get('shipping_title')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(localizations.get('shipping_subtitle'), textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 32),
              TextFormField(
                decoration: InputDecoration(labelText: localizations.get('full_name')),
                validator: (value) => (value?.trim().isEmpty ?? true) ? 'Required field' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: localizations.get('phone_number'), prefixText: '+380 '),
                keyboardType: TextInputType.phone,
                validator: (value) => (value?.trim().isEmpty ?? true) ? 'Required field' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: localizations.get('email')),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => (value?.contains('@') ?? false) ? null : 'Invalid email',
              ),
              const SizedBox(height: 24),
              Divider(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1)),
              const SizedBox(height: 24),
              TextFormField(
                initialValue: 'Львів',
                decoration: InputDecoration(labelText: localizations.get('city')),
                validator: (value) => (value?.trim().isEmpty ?? true) ? 'Required field' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: localizations.get('address_department')),
                validator: (value) => (value?.trim().isEmpty ?? true) ? 'Required field' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: localizations.get('comments')),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.check_rounded, size: 20),
          label: Text(localizations.get('confirm_button')),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Provider.of<ConfiguratorProvider>(context, listen: false).resetConfiguration();
              Navigator.of(context).popUntil((route) => route.isFirst);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Замовлення "прийнято"!')));
            }
          },
        ),
      ),
    );
  }
}