import '../../data/models/meal_plan_model.dart';

abstract class MealPlanEvent {}

/// Load all meal plans
class LoadMealPlans extends MealPlanEvent {}

/// Add a new meal plan
class AddMealPlan extends MealPlanEvent {
  final MealPlan plan;

  AddMealPlan(this.plan);
}

/// Update an existing meal plan
class UpdateMealPlan extends MealPlanEvent {
  final MealPlan plan;

  UpdateMealPlan(this.plan);
}
