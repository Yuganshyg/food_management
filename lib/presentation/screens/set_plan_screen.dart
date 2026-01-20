import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/meal_plan/meal_plan_bloc.dart';
import '../../bloc/meal_plan/meal_plan_event.dart';
import '../../core/constants/app_colors.dart';
import '../../data/draft/meal_draft.dart';
import '../../data/draft/meal_item_draft.dart';
import '../../data/draft/draft_mapper.dart';
import '../../data/models/meal_plan_model.dart';
import '../widgets/meal_setup_card.dart';

class SetPlanScreen extends StatefulWidget {
  final MealPlan draftPlan;

  const SetPlanScreen({super.key, required this.draftPlan});

  @override
  State<SetPlanScreen> createState() => _SetPlanScreenState();
}

class _SetPlanScreenState extends State<SetPlanScreen> {
  late List<MealDraft> mealDrafts;

  bool get _isFormValid => mealDrafts.every((m) => m.isValid);

  @override
  void initState() {
    super.initState();
    mealDrafts = widget.draftPlan.selectedMeals
        .map((type) => MealDraft(type: type, items: [MealItemDraft()]))
        .toList();
  }

  Future<void> _pickTime(int index, bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked == null) return;

    setState(() {
      final formatted = picked.format(context);
      isStart
          ? mealDrafts[index].startTime = formatted
          : mealDrafts[index].endTime = formatted;
    });
  }

  void _savePlan() {
    final finalPlan = DraftMapper.toMealPlan(
      id: DateTime.now().millisecondsSinceEpoch,
      name: widget.draftPlan.name,
      frequency: widget.draftPlan.frequency,
      amount: widget.draftPlan.amount,
      meals: mealDrafts,
    );

    context.read<MealPlanBloc>().add(AddMealPlan(finalPlan));
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Set Plan')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                itemCount: mealDrafts.length,
                itemBuilder: (_, index) {
                  final meal = mealDrafts[index];

                  return MealSetupCard(
                    meal: meal,
                    onTimePickStart: () => _pickTime(index, true),
                    onTimePickEnd: () => _pickTime(index, false),
                    onAddDish: () {
                      setState(() => meal.items.add(MealItemDraft()));
                    },
                    onRemoveDish: (i) {
                      setState(() => meal.items.removeAt(i));
                    },
                    onDietChanged: (i, diet) {
                      setState(() => meal.items[i].diet = diet);
                    },
                  );
                },
              ),
            ),

            /// SAVE BUTTON
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFormValid
                        ? AppColors.accentBlue
                        : Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _isFormValid ? _savePlan : null,
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
