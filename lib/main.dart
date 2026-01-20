import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_management/bloc/meal_plan/meal_plan_event.dart';
import 'package:food_management/core/theme/theme_state.dart';
import 'package:food_management/data/repository/meal_plan_repository.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'bloc/meal_plan/meal_plan_bloc.dart';
import 'presentation/screens/food_management_home.dart';

void main() {
  runApp(const FoodManagementApp());
}

class FoodManagementApp extends StatelessWidget {
  const FoodManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        /// Theme cubit (system theme driven)
        BlocProvider(create: (_) => ThemeCubit()),

        /// Meal plan bloc (used across multiple screens)
        BlocProvider(
          create: (_) =>
              MealPlanBloc(MealPlanRepository())..add(LoadMealPlans()),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Food Management',

            /// Light & Dark themes from SVG
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,

            /// 🔑 SYSTEM THEME (IMPORTANT)
            themeMode: ThemeMode.system,

            home: const FoodManagementHome(),
          );
        },
      ),
    );
  }
}
