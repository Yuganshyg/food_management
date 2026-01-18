import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/meal_plan/meal_plan_bloc.dart';
import '../../bloc/meal_plan/meal_plan_state.dart';
import '../widgets/meal_plan_card.dart';

class MealPlanListScreen extends StatelessWidget {
  const MealPlanListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meal Plans'), actions: [
          
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<MealPlanBloc, MealPlanState>(
          builder: (context, state) {
            if (state is MealPlanLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MealPlanLoaded) {
              return ListView.builder(
                itemCount: state.plans.length,
                itemBuilder: (context, index) {
                  return MealPlanCard(plan: state.plans[index]);
                },
              );
            }

            if (state is MealPlanError) {
              return Center(child: Text(state.message));
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
