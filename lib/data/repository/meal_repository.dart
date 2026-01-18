import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/meal_plan_model.dart';

class MealRepository {
  Future<List<MealPlan>> fetchMealPlans() async {
    final String response = await rootBundle.loadString(
      'lib/data/mock/meal_data.json',
    );

    final data = json.decode(response);

    final List mealPlans = data['mealPlans'];

    return mealPlans.map((json) => MealPlan.fromJson(json)).toList();
  }
}
