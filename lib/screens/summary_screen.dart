// lib/screens/summary_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/configurator_provider.dart';
import '../models/component_category.dart';
import '../models/phone_component.dart';
import './shipping_details_screen.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final configurator = Provider.of<ConfiguratorProvider>(context);
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final categories = ComponentCategory.values;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.get('summary_title')),
        backgroundColor: theme.colorScheme.surface,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                localizations.get('summary_config_title'),
                style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = categories[index];
                  final component = configurator.getSelectedComponentForCategory(category);
                  return _SummaryItem(category: category, component: component);
                },
                childCount: categories.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
              child: _TotalPrice(totalPrice: configurator.totalPrice),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.local_shipping_outlined, size: 20),
          label: Text(localizations.get('shipping_button')),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
          ),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ShippingDetailsScreen())),
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final ComponentCategory category;
  final PhoneComponent? component;

  const _SummaryItem({required this.category, this.component});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    final bool isSelected = component != null;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: (isSelected ? component!.placeholderColor : theme.disabledColor).withAlpha(26), // FIX
              child: Icon(category.icon, color: isSelected ? component!.placeholderColor : theme.disabledColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.displayName,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withAlpha(153)), // FIX
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isSelected ? localizations.getComponentName(component!.id) : localizations.get('unselected'),
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Text(
                '+${component!.price.toStringAsFixed(0)} грн',
                style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
              )
          ],
        ),
      ),
    );
  }
}

class _TotalPrice extends StatelessWidget {
  final double totalPrice;
  const _TotalPrice({required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withAlpha(26), // FIX
        borderRadius: BorderRadius.circular(16)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(localizations.get('total_price'), style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary)),
          Text(
            '${totalPrice.toStringAsFixed(0)} грн',
            style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}