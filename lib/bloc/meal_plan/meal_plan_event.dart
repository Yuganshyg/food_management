import '../../data/models/meal_plan_model.dart';

abstract class MealPlanEvent {}

class LoadMealPlans extends MealPlanEvent {}

class AddMealPlan extends MealPlanEvent {
  final MealPlan plan;

  AddMealPlan(this.plan);
}

class UpdateMealPlan extends MealPlanEvent {
  final MealPlan plan;

  UpdateMealPlan(this.plan);
}
