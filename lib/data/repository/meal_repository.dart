import '../models/meal_plan_model.dart';

/// Abstract contract for meal-related data
abstract class MealRepository {
  Future<List<MealPlan>> fetchMealPlans();
  Future<void> addMealPlan(MealPlan plan);
  Future<void> updateMealPlan(MealPlan plan);
}
