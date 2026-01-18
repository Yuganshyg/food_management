import 'package:equatable/equatable.dart';
import '../../data/models/meal_plan_model.dart';

abstract class MealPlanState extends Equatable {
  const MealPlanState();

  @override
  List<Object> get props => [];
}

class MealPlanInitial extends MealPlanState {}

class MealPlanLoading extends MealPlanState {}

class MealPlanLoaded extends MealPlanState {
  final List<MealPlan> plans;

  const MealPlanLoaded(this.plans);

  @override
  List<Object> get props => [plans];
}

class MealPlanError extends MealPlanState {
  final String message;

  const MealPlanError(this.message);

  @override
  List<Object> get props => [message];
}
