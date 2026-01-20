import '../../data/models/meal_plan_model.dart';

abstract class MealPlanState {}

class MealPlanInitial extends MealPlanState {}

class MealPlanLoading extends MealPlanState {}

class MealPlanLoaded extends MealPlanState {
  final List<MealPlan> plans;

  MealPlanLoaded(this.plans);
}

class MealPlanError extends MealPlanState {
  final String message;

  MealPlanError(this.message);
}
