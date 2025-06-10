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
  audioChip('Аудіочіп', Icons.volume_up_outlined),
  operatingSystem('Операційна система', Icons.android_outlined),
  phoneCase('Корпус', Icons.smartphone_outlined);

  const ComponentCategory(this.displayName, this.icon);
  final String displayName;
  final IconData icon;

  String get agetLocalizationKey {
    switch (this) {
      case ComponentCategory.processor:
        return 'display_name_processor';
      case ComponentCategory.ram:
        return 'display_name_ram';
      case ComponentCategory.storage:
        return 'display_name_storage';
      case ComponentCategory.display:
        return 'display_name_display';
      case ComponentCategory.rearCamera:
        return 'display_name_rear_camera';
      case ComponentCategory.frontCamera:
        return 'display_name_front_camera';
      case ComponentCategory.battery:
        return 'display_name_battery';
      case ComponentCategory.audioChip:
        return 'display_name_audio_chip';
      case ComponentCategory.operatingSystem:
        return 'display_name_os';
      case ComponentCategory.phoneCase:
        return 'display_name_case';
    }
  }
}