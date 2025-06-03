// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/configurator_provider.dart';
import './configurator_screen.dart';
import './summary_screen.dart'; // Цей імпорт важливий для SummaryScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late List<AnimationController> _sectionControllers;
  late List<Animation<Offset>> _sectionSlideAnimations;

  final int _sectionCount = 3; // Кількість нових інформаційних секцій

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: const Interval(0.0, 0.6, curve: Curves.easeIn)),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _mainController, curve: const Interval(0.0, 0.7, curve: Curves.easeOutQuint)),
    );
    _mainController.forward();

    _sectionControllers = List.generate(
      _sectionCount,
      (index) => AnimationController(vsync: this, duration: const Duration(milliseconds: 500)),
    );

    _sectionSlideAnimations = List.generate(
      _sectionCount,
      (index) => Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
        CurvedAnimation(parent: _sectionControllers[index], curve: Curves.easeOutCubic),
      ),
    );

    // Запускаємо анімацію секцій послідовно (для демонстрації)
    _startSectionAnimations();
  }

  void _startSectionAnimations() async {
    for (int i = 0; i < _sectionControllers.length; i++) {
      await Future.delayed(const Duration(milliseconds: 250)); // Затримка між анімаціями секцій
      if (mounted) {
        _sectionControllers[i].forward();
      }
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    for (var controller in _sectionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildInfoSection({
    required IconData icon,
    required String title,
    required String text,
    required Animation<Offset> slideAnimation,
    required AnimationController controller, // ДОДАНО: приймаємо контролер
    required ThemeData theme,
  }) {
    // Створюємо анімацію для прозорості, використовуючи переданий контролер
    final Animation<double> fadeAnimationForSection = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller, // ЗМІНЕНО: використовуємо переданий контролер
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn), // Налаштуй інтервал, якщо потрібно
      ),
    );

    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimationForSection,
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 12.0),
          elevation: 1.5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 30, color: theme.colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  text,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.5,
                    color: theme.textTheme.bodyLarge?.color?.withAlpha((0.9 * 255).round()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            backgroundColor: theme.scaffoldBackgroundColor.withAlpha((0.85 * 255).round()),
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 16.0),
              title: Text(
                'FormaFon Lviv',
                style: theme.appBarTheme.titleTextStyle,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 30.0),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          ScaleTransition(
                            scale: CurvedAnimation(parent: _mainController, curve: Curves.elasticOut, reverseCurve: Curves.elasticIn),
                            child: Icon(
                              Icons.phonelink_setup_rounded,
                              size: 100,
                              color: theme.colorScheme.primary,
                              shadows: [
                                BoxShadow(
                                  color: theme.colorScheme.primary.withAlpha((0.4 * 255).round()),
                                  blurRadius: 20,
                                  spreadRadius: 1
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Твій Телефон – Твої Правила!',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineSmall?.copyWith(
                                  color: theme.textTheme.titleLarge?.color,
                                  fontWeight: FontWeight.w600
                                ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Створи унікальний смартфон, що ідеально відповідає твоїм потребам. Обери компоненти – ми професійно зберемо його у Львові!',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge?.copyWith(height: 1.55),
                          ),
                          const SizedBox(height: 40),
                          AnimatedBuilder(
                            animation: _mainController,
                            builder: (context, child) => Transform.scale(
                              scale: 0.85 + (_mainController.value * 0.15),
                              child: child,
                            ),
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.rocket_launch_outlined, size: 24),
                              label: const Text('Створити Свій FormaFon'),
                              style: theme.elevatedButtonTheme.style,
                              onPressed: () {
                                Provider.of<ConfiguratorProvider>(context, listen: false).resetConfiguration();
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => const ConfiguratorScreen(),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      const begin = Offset(0.0, 1.0);
                                      const end = Offset.zero;
                                      const curve = Curves.easeOutExpo;
                                      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                      return SlideTransition(
                                        position: animation.drive(tween),
                                        child: FadeTransition(opacity: animation, child: child),
                                      );
                                    },
                                    transitionDuration: const Duration(milliseconds: 450),
                                  )
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 30),
                          Divider(color: Colors.grey.shade300, indent: 40, endIndent: 40),
                          const SizedBox(height: 30),

                          // Нові інформаційні секції
                          _buildInfoSection(
                            theme: theme,
                            icon: Icons.extension_outlined,
                            title: 'Що таке FormaFon?',
                            text: 'FormaFon – це унікальний сервіс у Львові, який дозволяє тобі стати архітектором власного смартфона! Ти обираєш кожен компонент, від процесора до дизайну корпусу, а наші досвідчені майстри збирають його для тебе. Отримай пристрій, що на 100% відповідає твоїм потребам та стилю.',
                            slideAnimation: _sectionSlideAnimations[0],
                            controller: _sectionControllers[0], // ПЕРЕДАЄМО КОНТРОЛЕР
                          ),
                          _buildInfoSection(
                            theme: theme,
                            icon: Icons.verified_user_outlined,
                            title: 'Чому Обирають Нас?',
                            text: '• Повний Контроль: Ти вирішуєш все.\n• Приватність: Обирай ОС та компоненти без шпигунського ПЗ.\n• Якість: Професійна збірка у Львові з перевірених деталей.\n• Унікальність: Твій телефон буде єдиним у своєму роді.\n• Підтримка: Ми завжди готові допомогти з твоїм FormaFon.',
                            slideAnimation: _sectionSlideAnimations[1],
                            controller: _sectionControllers[1], // ПЕРЕДАЄМО КОНТРОЛЕР
                          ),
                           _buildInfoSection(
                            theme: theme,
                            icon: Icons.integration_instructions_outlined,
                            title: 'Як Це Працює?',
                            text: '1. Конфігуруй: Використовуй наш інтуїтивний онлайн-конструктор.\n2. Замовляй: Підтверди свою унікальну конфігурацію.\n3. Ми Збираємо: Наші майстри у Львові створюють твій телефон.\n4. Насолоджуйся: Отримай персональний гаджет мрії!',
                            slideAnimation: _sectionSlideAnimations[2],
                            controller: _sectionControllers[2], // ПЕРЕДАЄМО КОНТРОЛЕР
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.checklist_rtl_rounded, size: 24),
          label: const Text('Переглянути Підсумок'),
          style: theme.elevatedButtonTheme.style,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SummaryScreen()),
            );
          },
        ),
      ),
    );
  }
}