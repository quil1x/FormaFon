// lib/models/component_category.dart
import 'package:flutter/material.dart';

enum ComponentCategory {
  processor('Процесор/Платформа', Icons.memory),
  ram('Оперативна пам\'ять', Icons.developer_board_outlined),
  storage('Вбудована пам\'ять', Icons.storage_outlined),
  display('Дисплей', Icons.stay_current_portrait_outlined),
  rearCamera('Основна камера', Icons.camera_alt_outlined),
  frontCamera('Фронтальна камера', Icons.camera_front_outlined),
  battery('Акумулятор', Icons.battery_charging_full_outlined),
  audioChip('Аудіочіп', Icons.volume_up_outlined), // *** ENSURE THIS LINE IS CORRECT ***
  operatingSystem('Операційна система', Icons.android_outlined),
  phoneCase('Корпус', Icons.smartphone_outlined);

  const ComponentCategory(this.displayName, this.icon);
  final String displayName;
  final IconData icon;
}