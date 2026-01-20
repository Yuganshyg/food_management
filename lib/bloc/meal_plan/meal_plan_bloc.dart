import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/meal_plan_model.dart';
import '../../data/repository/meal_repository.dart';
import 'meal_plan_event.dart';
import 'meal_plan_state.dart';

class MealPlanBloc extends Bloc<MealPlanEvent, MealPlanState> {
  final MealRepository repository;

  MealPlanBloc(this.repository) : super(MealPlanInitial()) {
    on<LoadMealPlans>(_onLoadMealPlans);
    on<AddMealPlan>(_onAddMealPlan);
    on<UpdateMealPlan>(_onUpdateMealPlan);
  }

  Future<void> _onLoadMealPlans(
    LoadMealPlans event,
    Emitter<MealPlanState> emit,
  ) async {
    emit(MealPlanLoading());
    try {
      final plans = await repository.fetchMealPlans();
      emit(MealPlanLoaded(plans));
    } catch (e) {
      emit(MealPlanError(e.toString()));
    }
  }

  Future<void> _onAddMealPlan(
    AddMealPlan event,
    Emitter<MealPlanState> emit,
  ) async {
    if (state is! MealPlanLoaded) return;

    final currentPlans = (state as MealPlanLoaded).plans;

    await repository.addMealPlan(event.plan);

    final updatedPlans = await repository.fetchMealPlans();

    emit(MealPlanLoaded(updatedPlans));
  }

  Future<void> _onUpdateMealPlan(
    UpdateMealPlan event,
    Emitter<MealPlanState> emit,
  ) async {
    if (state is! MealPlanLoaded) return;

    await repository.updateMealPlan(event.plan);

    final updatedPlans = await repository.fetchMealPlans();

    emit(MealPlanLoaded(updatedPlans));
  }
}
