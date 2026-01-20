import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/meal_plan/meal_plan_bloc.dart';
import 'bloc/meal_plan/meal_plan_event.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'core/theme/theme_state.dart';
import 'data/repository/meal_plan_repository.dart';
import 'presentation/screens/food_management_home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FoodManagementApp());
}

class FoodManagementApp extends StatelessWidget {
  const FoodManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    final mealPlanRepository = MealPlanRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),

        BlocProvider(
          create: (_) => MealPlanBloc(mealPlanRepository)..add(LoadMealPlans()),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Food Management',

            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,

            themeMode: ThemeMode.system,

            home: const FoodManagementHome(),
          );
        },
      ),
    );
  }
}
