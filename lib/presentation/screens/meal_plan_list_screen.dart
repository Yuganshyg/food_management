import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/meal_plan/meal_plan_bloc.dart';
import '../../bloc/meal_plan/meal_plan_state.dart';
import '../../core/constants/app_colors.dart';
import '../screens/add_plan_screen.dart';
import '../widgets/meal_plan_card.dart';

class MealPlanListScreen extends StatelessWidget {
  const MealPlanListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      body: Column(
        children: [
          /// ───────── MEAL PLAN LIST ─────────
          Expanded(
            child: BlocBuilder<MealPlanBloc, MealPlanState>(
              builder: (context, state) {
                if (state is! MealPlanLoaded) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.plans.isEmpty) {
                  return Center(
                    child: Text(
                      'No plans added yet',
                      style: theme.textTheme.bodyMedium,
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: state.plans.length,
                  itemBuilder: (context, index) {
                    return MealPlanCard(plan: state.plans[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
