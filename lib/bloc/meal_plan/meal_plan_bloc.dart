import 'package:flutter_bloc/flutter_bloc.dart';
import 'meal_plan_event.dart';
import 'meal_plan_state.dart';
import '../../data/repository/meal_repository.dart';

class MealPlanBloc extends Bloc<MealPlanEvent, MealPlanState> {
  final MealRepository repository;

  MealPlanBloc(this.repository) : super(MealPlanInitial()) {
    on<LoadMealPlans>(_onLoadMealPlans);
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
      emit(MealPlanError('Failed to load meal plans'));
    }
  }
}
