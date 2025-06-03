import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/canvas_provider.dart';
import 'section_edit_screen.dart';
import '../widgets/canvas_tile.dart';

class LeanCanvasOverviewScreen extends StatelessWidget {
  const LeanCanvasOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final canvasProvider = Provider.of<CanvasProvider>(context);
    final sections = canvasProvider.sections;

    sections.sort((a, b) => a.number.compareTo(b.number));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lean Canvas - Бізнес План'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _calculateCrossAxisCount(context),
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 3 / 2.2, // Співвідношення сторін плитки
          ),
          itemCount: sections.length,
          itemBuilder: (context, index) {
            final section = sections[index];
            return CanvasTile(
              section: section,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SectionEditScreen(sectionIndex: index),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  int _calculateCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1200) return 3; // Великі екрани
    if (screenWidth > 700) return 2; // Середні екрани (планшети)
    return 1; // Малі екрани (телефони)
  }
}