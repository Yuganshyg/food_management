import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/meal_plan_model.dart';

class MealDataStore {
  static const _fileName = 'meal_data.json';

  List<MealPlan> _plans = [];

  /// Load from local file OR create from assets
  Future<void> initializeFromAssets(String assetJson) async {
    final file = await _localFile;

    if (!await file.exists()) {
      // First launch → create local copy
      await file.writeAsString(assetJson);
    }

    final content = await file.readAsString();
    final decoded = json.decode(content);

    _plans = (decoded['mealPlans'] as List)
        .map((e) => MealPlan.fromJson(e))
        .toList();
  }

  List<MealPlan> getMealPlans() => List.unmodifiable(_plans);

  int getNextPlanId() => _plans.isEmpty
      ? 1
      : _plans.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;

  Future<void> addMealPlan(MealPlan plan) async {
    _plans.add(plan);
    await _persist();
  }

  Future<void> updateMealPlan(MealPlan plan) async {
    final index = _plans.indexWhere((p) => p.id == plan.id);
    if (index != -1) {
      _plans[index] = plan;
      await _persist();
    }
  }

  /// WRITE BACK TO FILE
  Future<void> _persist() async {
    final file = await _localFile;

    final data = {'mealPlans': _plans.map((e) => e.toJson()).toList()};

    await file.writeAsString(json.encode(data), flush: true);
  }

  Future<File> get _localFile async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }
}
