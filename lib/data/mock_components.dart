// lib/data/mock_components.dart
import 'package:flutter/material.dart';
import '../models/phone_component.dart';
import '../models/component_category.dart';

// Приблизний курс для конвертації (умовний, станом на червень 2025)
// Наприклад, якщо раніше 100 у.о. = 4000 грн, то 1 у.о. = 40 грн.

final List<PhoneComponent> mockComponents = [
  // --- Процесори ---
  PhoneComponent(id: 'p0', name: 'SoC EntryCore M2', description: 'Надійний для дзвінків та месенджерів', price: 2000, category: ComponentCategory.processor, placeholderColor: Colors.grey[400]!), // ~50 у.о.
  PhoneComponent(id: 'p0a', name: 'SoC Unisoc T618', description: 'Бюджетний, для соцмереж та легких ігор', price: 2800, category: ComponentCategory.processor, placeholderColor: Colors.brown[300]!), // ~70 у.о.
  PhoneComponent(id: 'p1', name: 'SoC Helio G99 Ultimate', description: 'Оптимізований для ігор середнього рівня', price: 4400, category: ComponentCategory.processor, placeholderColor: Colors.blueGrey[400]!), // ~110 у.о.
  PhoneComponent(id: 'p1b', name: 'SoC Exynos 1480 Pro', description: 'Новий середній клас від Samsung з покращеним GPU', price: 6800, category: ComponentCategory.processor, placeholderColor: Colors.indigo[100]!), // ~170 у.о.
  PhoneComponent(id: 'p2', name: 'SoC Dimensity 8300-Ultra Max', description: 'Висока продуктивність, відмінний баланс', price: 10000, category: ComponentCategory.processor, placeholderColor: Colors.blueGrey[300]!), // ~250 у.о.
  PhoneComponent(id: 'p3', name: 'SoC Snapdragon 7+ Gen 3 Elite', description: 'Передфлагман, висока ефективність', price: 8800, category: ComponentCategory.processor, placeholderColor: Colors.blueGrey[200]!), // ~220 у.о.
  PhoneComponent(id: 'p4', name: 'SoC Snapdragon 8 Gen 3 Performance', description: 'Топова продуктивність для будь-яких завдань', price: 16000, category: ComponentCategory.processor, placeholderColor: Colors.orange[600]!), // ~400 у.о.
  PhoneComponent(id: 'p5', name: 'SoC Tensor G4 AI Master (Conceptual)', description: 'AI-орієнтований чіп, неперевершена нейромережа (концепт)', price: 18000, category: ComponentCategory.processor, placeholderColor: Colors.tealAccent[200]!), // ~450 у.о.

  // --- Оперативна пам'ять ---
  PhoneComponent(id: 'r0', name: '6 GB LPDDR4X', description: 'Стандарт для комфортного користування', price: 1200, category: ComponentCategory.ram, placeholderColor: Colors.cyan[300]!), // ~30 у.о.
  PhoneComponent(id: 'r1', name: '8 GB LPDDR5', description: 'Для плавної багатозадачності та ігор', price: 2000, category: ComponentCategory.ram, placeholderColor: Colors.cyan[200]!), // ~50 у.о.
  PhoneComponent(id: 'r1a', name: '8 GB LPDDR5X (High-Bandwidth)', description: 'Швидша LPDDR5X для кращої реакції системи', price: 2600, category: ComponentCategory.ram, placeholderColor: Colors.cyan[100]!), // ~65 у.о.
  PhoneComponent(id: 'r2', name: '12 GB LPDDR5X', description: 'Для професіоналів та вимогливих геймерів', price: 3600, category: ComponentCategory.ram, placeholderColor: Colors.lightBlueAccent[100]!), // ~90 у.о.
  PhoneComponent(id: 'r3', name: '16 GB LPDDR5X Pro', description: 'Екстремальна багатозадачність, запас на роки', price: 5200, category: ComponentCategory.ram, placeholderColor: Colors.blueAccent[100]!), // ~130 у.о.

  // --- Вбудована пам'ять ---
  PhoneComponent(id: 's0a', name: '128 GB UFS 3.1', description: 'Мінімальний комфортний обсяг', price: 1200, category: ComponentCategory.storage, placeholderColor: Colors.amber[300]!), // ~30 у.о.
  PhoneComponent(id: 's1', name: '256 GB UFS 3.1 Performance', description: 'Золота середина для більшості', price: 2200, category: ComponentCategory.storage, placeholderColor: Colors.amber[200]!), // ~55 у.о.
  PhoneComponent(id: 's1a', name: '256 GB UFS 4.0 Fast', description: 'Швидший UFS 4.0, оптимальний обсяг', price: 3000, category: ComponentCategory.storage, placeholderColor: Colors.orange[300]!), // ~75 у.о.
  PhoneComponent(id: 's2', name: '512 GB UFS 4.0 Pro', description: 'Для великої кількості контенту та швидкості', price: 4800, category: ComponentCategory.storage, placeholderColor: Colors.orangeAccent[100]!), // ~120 у.о.
  PhoneComponent(id: 's3', name: '1 TB UFS 4.0 Extreme', description: 'Величезний обсяг для професіоналів', price: 7200, category: ComponentCategory.storage, placeholderColor: Colors.deepOrangeAccent[100]!), // ~180 у.о.

  // --- Дисплей ---
  PhoneComponent(id: 'd0a', name: '6.2" OLED 90Hz FHD+', description: 'Компактний та яскравий OLED', price: 2800, category: ComponentCategory.display, placeholderColor: Colors.lime[300]!), // ~70 у.о.
  PhoneComponent(id: 'd1', name: '6.6" AMOLED 120Hz FHD+', description: 'Чудовий баланс розміру, якості та плавності', price: 4000, category: ComponentCategory.display, placeholderColor: Colors.lime[200]!), // ~100 у.о.
  PhoneComponent(id: 'd2', name: '6.78" LTPO AMOLED 1-144Hz QHD+', description: 'Топовий адаптивний екран, максимальна деталізація', price: 7200, category: ComponentCategory.display, placeholderColor: Colors.greenAccent[100]!), // ~180 у.о.
  PhoneComponent(id: 'd3', name: '6.9" ProMotion XDR 1600 nits (Conceptual)', description: 'Ультра-яскравий та плавний (концепт)', price: 9500, category: ComponentCategory.display, placeholderColor: Colors.tealAccent[100]!), // ~237 у.о.

  // --- Основна камера ---
  PhoneComponent(id: 'cam_r0a', name: '50MP Main Sensor f/1.8', description: 'Хороший базовий сенсор для якісних фото', price: 1800, category: ComponentCategory.rearCamera, placeholderColor: Colors.red[300]!), // ~45 у.о.
  PhoneComponent(id: 'cam_r1', name: '64MP Sony IMX787 OIS', description: 'Перевірений сенсор Sony з оптичною стабілізацією', price: 3000, category: ComponentCategory.rearCamera, placeholderColor: Colors.redAccent[100]!), // ~75 у.о.
  PhoneComponent(id: 'cam_r1b', name: '108MP Samsung HM2 OIS Pro', description: 'Висока роздільна здатність, покращений OIS', price: 4400, category: ComponentCategory.rearCamera, placeholderColor: Colors.pink[200]!), // ~110 у.о.
  PhoneComponent(id: 'cam_r2', name: '50MP Sony LYT-900 (1-inch type) OIS', description: 'Флагманський 1-дюймовий сенсор', price: 8000, category: ComponentCategory.rearCamera, placeholderColor: Colors.pinkAccent[100]!), // ~200 у.о.
  PhoneComponent(id: 'cam_r3', name: '200MP ISOCELL HP3 SuperZoom OIS', description: 'Топова роздільна здатність, неймовірний зум', price: 9800, category: ComponentCategory.rearCamera, placeholderColor: Colors.purpleAccent[100]!), // ~245 у.о.
  PhoneComponent(id: 'cam_r_multi', name: 'Система з 3-х камер (50MP Wide + 12MP UltraWide + 10MP Tele 3x)', description: 'Універсальний набір камер', price: 7500, category: ComponentCategory.rearCamera, placeholderColor: Colors.deepPurpleAccent[100]!), // ~187 у.о.


  // --- Фронтальна камера ---
  PhoneComponent(id: 'cam_f0a', name: '12MP Wide Angle Selfie', description: 'Хороша якість для селфі та дзвінків', price: 700, category: ComponentCategory.frontCamera, placeholderColor: Colors.yellow[300]!), // ~17 у.о.
  PhoneComponent(id: 'cam_f1', name: '20MP Smart HDR Selfie', description: 'З покращеним динамічним діапазоном', price: 1200, category: ComponentCategory.frontCamera, placeholderColor: Colors.orangeAccent[100]!), // ~30 у.о.
  PhoneComponent(id: 'cam_f2', name: '32MP Autofocus ProSelfie V2', description: 'Чіткі та деталізовані селфі з швидким автофокусом', price: 1800, category: ComponentCategory.frontCamera, placeholderColor: Colors.yellowAccent[100]!), // ~45 у.о.

   // --- Акумулятор ---
  PhoneComponent(id: 'bat0a', name: '4700 mAh Li-Po, 33W Charge', description: 'Стандартний розмір з швидкою зарядкою', price: 1300, category: ComponentCategory.battery, placeholderColor: Colors.lightGreen[300]!), // ~32 у.о.
  PhoneComponent(id: 'bat1', name: '5100 mAh PowerPlus, 67W Charge', description: 'Оптимальна ємність, дуже швидка зарядка', price: 1800, category: ComponentCategory.battery, placeholderColor: Colors.lightGreen[200]!), // ~45 у.о.
  PhoneComponent(id: 'bat2', name: '5500 mAh LongLife Pro, 80W Charge', description: 'Збільшена автономність, швидка зарядка', price: 2400, category: ComponentCategory.battery, placeholderColor: Colors.greenAccent[100]!), // ~60 у.о.
  PhoneComponent(id: 'bat3', name: '6000 mAh Graphene SuperCharge 120W (Conceptual)', description: 'Максимальна ємність та надшвидка зарядка (концепт)', price: 3500, category: ComponentCategory.battery, placeholderColor: Colors.limeAccent[100]!), // ~87 у.о.

  // --- Аудіочіп ---
  PhoneComponent(id: 'aud0a', name: 'Enhanced Stereo DAC', description: 'Покращена якість для вбудованих динаміків', price: 400, category: ComponentCategory.audioChip, placeholderColor: Colors.indigo[100]!), // ~10 у.о.
  PhoneComponent(id: 'aud1', name: 'Hi-Fi DAC ESS Sabre 9038Q2M', description: 'Аудіофільська якість звуку, 32-bit/384kHz', price: 1600, category: ComponentCategory.audioChip, placeholderColor: Colors.indigoAccent[100]!), // ~40 у.о.
  PhoneComponent(id: 'aud2', name: 'Dual Cirrus Logic CS35L45 Amps', description: 'Потужні подвійні підсилювачі для динаміків', price: 1200, category: ComponentCategory.audioChip, placeholderColor: Colors.deepPurpleAccent[100]!), // ~30 у.о.

   // --- Операційна система ---
  PhoneComponent(id: 'os1', name: 'FormaFon Pure OS (AOSP)', description: 'Чистий Android, без зайвого', price: 0, category: ComponentCategory.operatingSystem, placeholderColor: Colors.tealAccent[200]!),
  PhoneComponent(id: 'os2', name: 'FormaFon Shield OS (GrapheneOS Inspired)', description: 'Максимальна приватність та безпека', price: 800, category: ComponentCategory.operatingSystem, placeholderColor: Colors.blueAccent[100]!), // ~20 у.о.
  PhoneComponent(id: 'os3', name: 'PixelExperience (FormaFon Build)', description: 'Досвід Pixel на вашому кастомному пристрої', price: 300, category: ComponentCategory.operatingSystem, placeholderColor: Colors.cyanAccent[200]!), // ~7.5 у.о.

   // --- Корпус ---
  PhoneComponent(id: 'case1', name: 'Матовий Полікарбонат (Чорний/Білий/Зелений)', description: 'Практичний та приємний на дотик', price: 500, category: ComponentCategory.phoneCase, placeholderColor: Colors.blueGrey[300]!), // ~12.5 у.о.
  PhoneComponent(id: 'case2', name: 'Алюмінієва Рамка + Скло Gorilla Glass Victus 2 (Срібний/Графіт)', description: 'Преміальний вигляд та захист', price: 1600, category: ComponentCategory.phoneCase, placeholderColor: Colors.grey[400]!), // ~40 у.о.
  PhoneComponent(id: 'case3', name: 'Львівський Дуб (Справжнє дерево, ручна робота)', description: 'Ексклюзивний еко-дизайн', price: 2500, category: ComponentCategory.phoneCase, placeholderColor: Colors.brown[300]!), // ~62.5 у.о.
  PhoneComponent(id: 'case6', name: 'Титановий Корпус Grade 5 (Натуральний/Темний)', description: 'Максимальна міцність та легкість', price: 4500, category: ComponentCategory.phoneCase, placeholderColor: Colors.grey[500]!), // ~112.5 у.о.
  PhoneComponent(id: 'case_clear', name: 'Прозорий Полікарбонат HardShell', description: 'Покажіть красу вашого FormaFon', price: 400, category: ComponentCategory.phoneCase, placeholderColor: Colors.transparent),
];