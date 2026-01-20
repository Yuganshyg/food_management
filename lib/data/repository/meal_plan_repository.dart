import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/meal_plan_model.dart';
import 'meal_repository.dart';

class MealPlanRepository implements MealRepository {
  static const _assetPath = 'assets/data/meal_data.json';

  List<MealPlan> _plans = [];
  bool _initialized = false;

  Future<void> _initIfNeeded() async {
    if (_initialized) return;

    try {
      final jsonString = await rootBundle.loadString(_assetPath);
      final decoded = json.decode(jsonString) as Map<String, dynamic>;

      final list = decoded['mealPlans'] as List<dynamic>;

      _plans = list
          .map((e) => MealPlan.fromJson(e as Map<String, dynamic>))
          .toList();

      _initialized = true;
    } catch (e) {
      /// 🔴 THIS was happening silently earlier
      rethrow;
    }
  }

  @override
  Future<List<MealPlan>> fetchMealPlans() async {
    await _initIfNeeded();
    return List.unmodifiable(_plans);
  }

  @override
  Future<void> addMealPlan(MealPlan plan) async {
    await _initIfNeeded();

    final nextId = _plans.isEmpty
        ? 1
        : _plans.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;

    _plans.add(plan.copyWith(id: nextId));
  }

  @override
  Future<void> updateMealPlan(MealPlan plan) async {
    await _initIfNeeded();

    final index = _plans.indexWhere((p) => p.id == plan.id);
    if (index != -1) {
      _plans[index] = plan;
    }
  }
}
