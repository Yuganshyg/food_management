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
    /// 🔑 SINGLE repository instance (important for physical device)
    final mealPlanRepository = MealPlanRepository();

    return MultiBlocProvider(
      providers: [
        /// Theme cubit (system theme driven)
        BlocProvider(create: (_) => ThemeCubit()),

        /// Meal plan bloc (global)
        BlocProvider(
          create: (_) =>
              MealPlanBloc(mealPlanRepository)
                ..add(LoadMealPlans()), // ✅ REQUIRED
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Food Management',

            /// Light & Dark themes (SVG based)
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,

            /// 🔑 Follow system theme
            themeMode: ThemeMode.system,

            home: const FoodManagementHome(),
          );
        },
      ),
    );
  }
}
