import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_management/presentation/screens/food_management_home.dart';

import 'core/theme/app_theme.dart';
import 'data/repository/meal_repository.dart';
import 'bloc/meal_plan/meal_plan_bloc.dart';
import 'bloc/meal_plan/meal_plan_event.dart';

void main() {
  runApp(const FoodManagementApp());
}

class FoodManagementApp extends StatelessWidget {
  const FoodManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [RepositoryProvider(create: (_) => MealRepository())],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                MealPlanBloc(context.read<MealRepository>())
                  ..add(LoadMealPlans()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const FoodManagementHome(),
        ),
      ),
    );
  }
}
