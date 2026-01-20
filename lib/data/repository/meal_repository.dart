import '../models/meal_plan_model.dart';

abstract class MealRepository {
  Future<List<MealPlan>> fetchMealPlans();
  Future<void> addMealPlan(MealPlan plan);
  Future<void> updateMealPlan(MealPlan plan);
}
