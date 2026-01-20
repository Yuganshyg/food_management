import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/meal_plan_model.dart';
import '../store/meal_data_store.dart';
import 'meal_repository.dart';

class MealPlanRepository implements MealRepository {
  static const _jsonAssetPath = 'lib/data/mock/meal_data.json';

  final MealDataStore _store = MealDataStore();
  bool _initialized = false;

  // ───────── INITIALIZE FROM ASSETS ─────────
  Future<void> _initIfNeeded() async {
    if (_initialized) return;

    final assetJson = await rootBundle.loadString(_jsonAssetPath);
    await _store.initializeFromAssets(assetJson);

    _initialized = true;
  }

  // ───────── READ ─────────
  @override
  Future<List<MealPlan>> fetchMealPlans() async {
    await _initIfNeeded();
    return _store.getMealPlans();
  }

  // ───────── CREATE ─────────
  @override
  Future<void> addMealPlan(MealPlan plan) async {
    await _initIfNeeded();

    final withId = plan.copyWith(id: _store.getNextPlanId());

    _store.addMealPlan(withId);
  }

  // ───────── UPDATE ─────────
  @override
  Future<void> updateMealPlan(MealPlan plan) async {
    await _initIfNeeded();
    _store.updateMealPlan(plan);
  }
}
