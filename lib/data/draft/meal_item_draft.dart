import 'package:flutter/material.dart';

class MealItemDraft {
  final TextEditingController controller;
  String? diet;

  MealItemDraft({String name = '', this.diet})
    : controller = TextEditingController(text: name);

  String get name => controller.text;

  bool get isValid => name.trim().isNotEmpty && diet != null;
}
