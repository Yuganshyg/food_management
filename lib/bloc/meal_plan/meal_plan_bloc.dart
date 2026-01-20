import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'meal_plan_event.dart';
import 'meal_plan_state.dart';
import '../../data/repository/meal_plan_repository.dart';

class MealPlanBloc extends Bloc<MealPlanEvent, MealPlanState> {
  final MealPlanRepository repository;

  MealPlanBloc(this.repository) : super(MealPlanLoading()) {
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

      /// 🔴 CRITICAL: empty list is STILL a valid loaded state
      emit(MealPlanLoaded(plans));
    } catch (e, stack) {
      /// 🔥 THIS was missing earlier
      debugPrint('❌ LoadMealPlans failed: $e');
      debugPrintStack(stackTrace: stack);

      emit(MealPlanError(e.toString()));
    }
  }

  Future<void> _onAddMealPlan(
    AddMealPlan event,
    Emitter<MealPlanState> emit,
  ) async {
    try {
      await repository.addMealPlan(event.plan);
      final plans = await repository.fetchMealPlans();
      emit(MealPlanLoaded(plans));
    } catch (e) {
      emit(MealPlanError(e.toString()));
    }
  }

  Future<void> _onUpdateMealPlan(
    UpdateMealPlan event,
    Emitter<MealPlanState> emit,
  ) async {
    try {
      await repository.updateMealPlan(event.plan);
      final plans = await repository.fetchMealPlans();
      emit(MealPlanLoaded(plans));
    } catch (e) {
      emit(MealPlanError(e.toString()));
    }
  }
}
