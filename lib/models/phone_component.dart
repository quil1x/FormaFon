// lib/models/phone_component.dart
import 'package:flutter/material.dart';
import './component_category.dart';

class PhoneComponent {
  final String id;
  final String name;
  final String description;
  final double price;
  final ComponentCategory category;
  final Color placeholderColor;

  PhoneComponent({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.placeholderColor = Colors.grey,
  });
}