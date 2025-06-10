// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/configurator_provider.dart';
import '../providers/settings_provider.dart';
import 'configurator_screen.dart';
import 'summary_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late List<AnimationController> _sectionControllers;

  @override
  void initState() {
    super.initState();
    // 5 контролерів: 1 для Hero, 4 для Info
    _sectionControllers = List.generate(5, (index) => AnimationController(vsync: this, duration: const Duration(milliseconds: 600)));
    _startSectionAnimations();
  }

  void _startSectionAnimations() async {
    for (int i = 0; i < _sectionControllers.length; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      if (mounted) _sectionControllers[i].forward();
    }
  }

  @override
  void dispose() {
    for (var controller in _sectionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(localizations.get('formafon'), style: TextStyle(fontWeight: FontWeight.bold)),
        actions: const [
          _SettingsPopupButton(),
          SizedBox(width: 8),
        ],
      ),
      body: ListView(
        // Прибираємо всі відступи зі списку, щоб дочірні елементи могли контролювати свою позицію
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 20),
          // Герой-секція має свої власні відступи
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: _AnimatedSection(
              controller: _sectionControllers[0],
              index: 0,
              child: _HeroSection(),
            ),
          ),
          const SizedBox(height: 20),
          _AnimatedSection(
            controller: _sectionControllers[1],
            index: 1, // Непарний індекс - виїзд зліва
            child: _InfoSection(
              icon: Icons.extension_outlined,
              title: localizations.get('what_is_formafon'),
              text: localizations.get('what_is_formafon_desc'),
              isLeftAligned: true,
            ),
          ),
          const SizedBox(height: 16),
          _AnimatedSection(
            controller: _sectionControllers[2],
            index: 2, // Парний індекс - виїзд справа
            child: _InfoSection(
              icon: Icons.verified_user_outlined,
              title: localizations.get('why_us'),
              text: localizations.get('why_us_desc'),
              isLeftAligned: false,
            ),
          ),
          const SizedBox(height: 16),
          _AnimatedSection(
            controller: _sectionControllers[3],
            index: 3, // Непарний індекс - виїзд зліва
            child: _InfoSection(
              icon: Icons.integration_instructions_outlined,
              title: localizations.get('how_it_works'),
              text: localizations.get('how_it_works_desc'),
              isLeftAligned: true,
            ),
          ),
          const SizedBox(height: 16),
          _AnimatedSection(
            controller: _sectionControllers[4],
            index: 4, // Парний індекс - виїзд справа
            child: _InfoSection(
              icon: Icons.alternate_email_rounded,
              title: localizations.get('contact_us_title'),
              text: localizations.get('contact_us_desc'),
              isLeftAligned: false,
            ),
          ),
          const SizedBox(height: 120),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.checklist_rtl_rounded, size: 20),
          label: Text(localizations.get('summary_button')),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
          ),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SummaryScreen())),
        ),
      ),
    );
  }
}

class _AnimatedSection extends StatelessWidget {
  final AnimationController controller;
  final Widget child;
  final int index;

  const _AnimatedSection({
    required this.controller,
    required this.child,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    if (index == 0) { // Анімація для герой-секції
      return FadeTransition(
        opacity: CurvedAnimation(parent: controller, curve: Curves.easeOut),
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
              .animate(CurvedAnimation(parent: controller, curve: Curves.easeOutCubic)),
          child: child,
        ),
      );
    }

    // Анімація для інформаційних блоків
    final beginOffset = (index.isOdd) ? const Offset(-1.0, 0) : const Offset(1.0, 0);

    return SlideTransition(
      position: Tween<Offset>(begin: beginOffset, end: Offset.zero)
          .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOutQuart)),
      child: child,
    );
  }
}

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    
    return Column(
      children: [
        Icon(Icons.phonelink_setup_rounded, size: 60, color: theme.primaryColor),
        const SizedBox(height: 16),
        Text(localizations.get('home_title'), textAlign: TextAlign.center, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(
          localizations.get('home_subtitle'),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7)),
        ),
        const SizedBox(height: 24),
         ElevatedButton(
            child: Text(localizations.get('create_button')),
            onPressed: () {
              Provider.of<ConfiguratorProvider>(context, listen: false).resetConfiguration();
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfiguratorScreen()));
            },
          ),
      ],
    );
  }
}

class _InfoSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  final bool isLeftAligned;

  const _InfoSection({
    required this.icon,
    required this.title,
    required this.text,
    this.isLeftAligned = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // FIX: Використовуємо Align, щоб притиснути блок до краю
    return Align(
      alignment: isLeftAligned ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        // FIX: Задаємо ширину в 70% від ширини екрану
        width: MediaQuery.of(context).size.width * 0.7,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: isLeftAligned ? Radius.zero : const Radius.circular(20),
            bottomLeft: isLeftAligned ? Radius.zero : const Radius.circular(20),
            topRight: isLeftAligned ? const Radius.circular(20) : Radius.zero,
            bottomRight: isLeftAligned ? const Radius.circular(20) : Radius.zero,
          ),
          boxShadow: [ BoxShadow(color: theme.colorScheme.shadow.withOpacity(0.1), offset: const Offset(0, 4), blurRadius: 12) ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: theme.primaryColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(text, style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8), height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsPopupButton extends StatelessWidget {
  const _SettingsPopupButton();

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'theme') {
          settings.toggleTheme();
        } else if (value == 'language') {
          final newLocale = settings.locale.languageCode == 'uk' ? const Locale('en') : const Locale('uk');
          settings.setLocale(newLocale);
        }
      },
      icon: Icon(Icons.more_vert_rounded, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'theme',
          child: ListTile(
            leading: Icon(settings.isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
            title: Text(localizations.get('toggle_theme_tooltip')),
          ),
        ),
        PopupMenuItem<String>(
          value: 'language',
          child: ListTile(
            leading: const Icon(Icons.language_outlined),
            title: Text(localizations.get('toggle_language_tooltip')),
          ),
        ),
      ],
    );
  }
}