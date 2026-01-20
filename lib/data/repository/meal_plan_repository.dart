import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/meal_plan_model.dart';
import '../store/meal_data_store.dart';
import 'meal_repository.dart';

/// Repository that behaves like a real backend API
/// - Loads JSON once
/// - Uses in-memory store as source of truth
class MealPlanRepository implements MealRepository {
  static const _jsonPath = 'lib/data/mock/meal_data.json';

  final MealDataStore _store = MealDataStore();
  bool _isInitialized = false;

  /// Load JSON once and initialize store
  Future<void> _initializeIfNeeded() async {
    if (_isInitialized) return;

    final String response = await rootBundle.loadString(_jsonPath);
    final Map<String, dynamic> data = json.decode(response);

    final List plansJson = data['mealPlans'];

    final plans = plansJson
        .map<MealPlan>((json) => MealPlan.fromJson(json))
        .toList();

    _store.initialize(plans);
    _isInitialized = true;
  }

  /// READ – Fetch meal plans
  @override
  Future<List<MealPlan>> fetchMealPlans() async {
    await _initializeIfNeeded();
    return _store.getMealPlans();
  }

  /// WRITE – Add new meal plan
  @override
  Future<void> addMealPlan(MealPlan plan) async {
    await _initializeIfNeeded();

    final newPlan = plan.copyWith(id: _store.getNextPlanId());

    _store.addMealPlan(newPlan);
  }

  /// WRITE – Update existing plan
  @override
  Future<void> updateMealPlan(MealPlan plan) async {
    await _initializeIfNeeded();
    _store.updateMealPlan(plan);
  }
}
