import 'package:flutter/material.dart';
import '../models/lean_canvas_data.dart';

class CanvasTile extends StatelessWidget {
  final CanvasSection section;
  final VoidCallback onTap;

  const CanvasTile({super.key, required this.section, required this.onTap});

  @override
  Widget build(BuildContext context) {
    bool isFilled = section.values.values.any((value) => value.isNotEmpty);

    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2.0,
        color: isFilled ? Colors.green[50] : Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${section.number}. ${section.title}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isFilled) const Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                section.description,
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              _buildSummary(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummary(BuildContext context) {
    String summaryText = "Торкніться, щоб редагувати...";
    String firstFilledValue = "";

    for (String key in section.fieldKeys) {
        if (section.values[key] != null && section.values[key]!.isNotEmpty) {
            firstFilledValue = "$key: ${section.values[key]!}";
            break; 
        }
    }
    if (firstFilledValue.isNotEmpty) {
        summaryText = firstFilledValue;
    }

    return Text(
        summaryText,
        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey[600]),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
    );
  }
}