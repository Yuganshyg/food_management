import 'package:equatable/equatable.dart';

abstract class MealPlanEvent extends Equatable {
  const MealPlanEvent();

  @override
  List<Object> get props => [];
}

class LoadMealPlans extends MealPlanEvent {}
