// lib/l10n/app_localizations.dart
import 'package:flutter/material.dart';
import 'component_translations.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'uk': {
      'formafon': 'FormaFon',
      'home_title': 'Твій Телефон – Твої Правила!',
      'home_subtitle': 'Створи унікальний смартфон, що ідеально відповідає твоїм потребам.',
      'create_button': 'Створити Свій FormaFon',
      'summary_button': 'Переглянути Підсумок',
      'what_is_formafon': 'Що таке FormaFon?',
      'what_is_formafon_desc': 'Це сервіс, що дозволяє тобі стати архітектором власного смартфона! Ти обираєш кожен компонент, а наші майстри збирають його для тебе.',
      'why_us': 'Чому Обирають Нас?',
      'why_us_desc': '• Повний Контроль\n• Якісна збірка\n• Унікальність\n• Підтримка',
      'how_it_works': 'Як Це Працює?',
      'how_it_works_desc': '1. Конфігуруй\n2. Замовляй\n3. Ми Збираємо\n4. Насолоджуйся!',
      'summary_title': 'Ваш FormaFon',
      'summary_config_title': 'Підсумок Конфігурації:',
      'total_price': 'Загальна сума:',
      'shipping_button': 'Перейти до Відправки',
      'shipping_title': 'Дані для Відправки',
      'shipping_subtitle': 'Заповніть для доставки вашого FormaFon',
      'full_name': 'ПІБ (Повністю)',
      'phone_number': 'Номер телефону',
      'email': 'Електронна пошта',
      'city': 'Місто',
      'delivery_service': 'Служба доставки',
      'address_department': 'Номер відділення / Ваша адреса',
      'comments': 'Коментар (необов\'язково)',
      'confirm_button': 'Підтвердити Відправку',
      'unselected': 'Не обрано',
      'toggle_language_tooltip': 'Змінити мову',
      'toggle_theme_tooltip': 'Змінити тему',
      'configurator_title': 'FormaFon Конструктор',
      'view_screen': 'Екран',
      'view_components': 'Компоненти',
      'tap_to_select_display': 'Торкніться, щоб обрати Дисплей',
      'front_camera_tooltip': 'Фронтальна камера',
      'software_and_appearance': 'Програмне Забезпечення та Зовнішній Вигляд:',
      'select_option': 'Обрати',
      'component_sheet_title': 'Оберіть',
      'no_options_available': 'Немає доступних опцій.',
      'display_name_processor': 'Процесор',
      'display_name_ram': 'Оперативна пам\'ять',
      'display_name_storage': 'Вбудована пам\'ять',
      'display_name_display': 'Дисплей',
      'display_name_rear_camera': 'Основна камера',
      'display_name_front_camera': 'Фронтальна камера',
      'display_name_battery': 'Акумулятор',
      'display_name_audio_chip': 'Аудіочіп',
      'display_name_os': 'Операційна система',
      'display_name_case': 'Корпус',
      'contact_us_title': 'Зв\'яжіться з нами',
      'contact_us_desc': 'Маєте питання? Ми тут, щоб допомогти.\nЛьвів, Україна.',
    },
    'en': {
      'formafon': 'FormaFon',
      'home_title': 'Your Phone – Your Rules!',
      'home_subtitle': 'Create a unique smartphone that perfectly fits your needs.',
      'create_button': 'Create Your FormaFon',
      'summary_button': 'View Summary',
      'what_is_formafon': 'What is FormaFon?',
      'what_is_formafon_desc': 'It\'s a service that lets you be the architect of your own smartphone! You choose every component, and our craftsmen assemble it for you.',
      'why_us': 'Why Choose Us?',
      'why_us_desc': '• Full Control\n• Quality Assembly\n• Uniqueness\n• Support',
      'how_it_works': 'How It Works?',
      'how_it_works_desc': '1. Configure\n2. Order\n3. We Assemble\n4. Enjoy!',
      'summary_title': 'Your FormaFon',
      'summary_config_title': 'Configuration Summary:',
      'total_price': 'Total Price:',
      'shipping_button': 'Proceed to Shipping',
      'shipping_title': 'Shipping Details',
      'shipping_subtitle': 'Fill in the details for your FormaFon delivery',
      'full_name': 'Full Name',
      'phone_number': 'Phone Number',
      'email': 'Email Address',
      'city': 'City',
      'delivery_service': 'Delivery Service',
      'address_department': 'Department number / Your address',
      'comments': 'Comment (optional)',
      'confirm_button': 'Confirm Shipment',
      'unselected': 'Not selected',
      'toggle_language_tooltip': 'Switch Language',
      'toggle_theme_tooltip': 'Toggle Theme',
      'configurator_title': 'FormaFon Configurator',
      'view_screen': 'Screen',
      'view_components': 'Components',
      'tap_to_select_display': 'Tap to select Display',
      'front_camera_tooltip': 'Front Camera',
      'software_and_appearance': 'Software and Appearance:',
      'select_option': 'Select',
      'component_sheet_title': 'Select',
      'no_options_available': 'No options available.',
      'display_name_processor': 'Processor',
      'display_name_ram': 'RAM',
      'display_name_storage': 'Storage',
      'display_name_display': 'Display',
      'display_name_rear_camera': 'Rear Camera',
      'display_name_front_camera': 'Front Camera',
      'display_name_battery': 'Battery',
      'display_name_audio_chip': 'Audio Chip',
      'display_name_os': 'Operating System',
      'display_name_case': 'Case',
      'contact_us_title': 'Contact Us',
      'contact_us_desc': 'Have questions? We\'re here to help.\nLviv, Ukraine.',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  String getComponentName(String componentId) {
    final key = 'name_${locale.languageCode}';
    return componentTranslations[componentId]?[key] ?? 'Unnamed Component';
  }

  String getComponentDescription(String componentId) {
    final key = 'description_${locale.languageCode}';
    return componentTranslations[componentId]?[key] ?? 'No description.';
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['uk', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}