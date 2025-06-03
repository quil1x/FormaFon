class CanvasSection {
  final String title;
  final int number;
  final String description;
  final List<String> fieldKeys; // Назви полів для введення тексту
  final List<String> fieldHints; // Підказки для кожного поля
  Map<String, String> values;   // Поточні значення для кожного поля

  CanvasSection({
    required this.title,
    required this.number,
    required this.description,
    required this.fieldKeys,
    required this.fieldHints,
  }) : values = {for (var key in fieldKeys) key: ""}; // Ініціалізація порожніми значеннями
}

// Функція для отримання початкових даних Canvas
List<CanvasSection> getInitialCanvasSections() {
  return [
    CanvasSection(
      title: "Customer Segments",
      number: 1,
      description: "Перелічіть ваших цільових клієнтів та користувачів. Опишіть характеристики ваших ідеальних ранніх послідовників.",
      fieldKeys: ["Цільові клієнти та користувачі", "Ранні послідовники (Early Adopters)"],
      fieldHints: ["Наприклад, малий бізнес, студенти", "Наприклад, технічні ентузіасти, блогери, яким потрібна автоматизація"]
    ),
    CanvasSection(
      title: "Problem",
      number: 2,
      description: "Перелічіть топ-3 проблеми ваших клієнтів. Вкажіть, як ці проблеми вирішуються сьогодні (Існуючі альтернативи).",
      fieldKeys: ["Проблема 1", "Проблема 2", "Проблема 3", "Існуючі альтернативи"],
      fieldHints: ["Наприклад, марнування часу на X", "Наприклад, поточні рішення занадто дорогі", "Наприклад, відсутність Y", "Наприклад, ручна робота, електронні таблиці, конкурент А"]
    ),
    CanvasSection(
      title: "Unique Value Proposition",
      number: 3,
      description: "Єдине, чітке, переконливе повідомлення, яке перетворює не обізнаного відвідувача на зацікавленого потенційного клієнта. Яка ваша аналогія X для Y (Високорівнева концепція)?",
      fieldKeys: ["Унікальна ціннісна пропозиція", "Високорівнева концепція (High Level Concept)"],
      fieldHints: ["Наприклад, найпростіший спосіб зробити Z для A", "Наприклад, YouTube для відео, Slack для командного спілкування"]
    ),
    CanvasSection(
      title: "Solution",
      number: 4,
      description: "Окресліть можливе рішення для кожної проблеми.",
      fieldKeys: ["Опис рішення"],
      fieldHints: ["Наприклад, веб-платформа, що автоматизує X, мобільний додаток, що надає функцію Y"]
    ),
    CanvasSection(
      title: "Channels",
      number: 5,
      description: "Перелічіть ваші шляхи до клієнтів.",
      fieldKeys: ["Канали"],
      fieldHints: ["Наприклад, SEO, контент-маркетинг, соціальні мережі, магазини додатків"]
    ),
    CanvasSection(
      title: "Revenue Streams",
      number: 6,
      description: "Перелічіть ваші джерела доходу.",
      fieldKeys: ["Джерела доходу"],
      fieldHints: ["Наприклад, підписка, модель Freemium, реклама, продаж"]
    ),
    CanvasSection(
      title: "Cost Structure",
      number: 7,
      description: "Перелічіть ваші постійні та змінні витрати.",
      fieldKeys: ["Структура витрат"],
      fieldHints: ["Наприклад, зарплати, маркетингові витрати, витрати на хостинг, оренда офісу"]
    ),
    CanvasSection(
      title: "Key Metrics",
      number: 8,
      description: "Перелічіть ключові показники, що відображають стан вашого бізнесу сьогодні.",
      fieldKeys: ["Ключові метрики"],
      fieldHints: ["Наприклад, щоденні активні користувачі, коефіцієнт конверсії, вартість залучення клієнта"]
    ),
    CanvasSection(
      title: "Unfair Advantage",
      number: 9,
      description: "Щось, що неможливо легко скопіювати або купити.",
      fieldKeys: ["Несправедлива перевага"],
      fieldHints: ["Наприклад, інсайдерська інформація, унікальний патент, сильна спільнота, команда мрії"]
    ),
  ];
}