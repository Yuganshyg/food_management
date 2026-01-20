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
  final MealPlan? existingPlan;

  const SetPlanScreen({super.key, required this.draftPlan, this.existingPlan});

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
      if (isStart) {
        mealDrafts[index].startTime = formatted;
      } else {
        mealDrafts[index].endTime = formatted;
      }
    });
  }

  Map<String, Map<String, Map<String, int>>> _initialMealTrack() {
    final track = <String, Map<String, Map<String, int>>>{};

    for (final day in ['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat']) {
      track[day] = {};
      for (final meal in mealDrafts) {
        track[day]![meal.type] = {'veg': 0, 'nonVeg': 0};
      }
    }
    return track;
  }

  void _savePlan() {
    final finalPlan = DraftMapper.toMealPlan(
      id: widget.existingPlan?.id ?? DateTime.now().millisecondsSinceEpoch,
      name: widget.draftPlan.name,
      frequency: widget.draftPlan.frequency,
      amount: widget.draftPlan.amount,
      meals: mealDrafts,
      mealPrices: widget.draftPlan.mealPrices,
      mealTrack: widget.existingPlan?.mealTrack ?? _initialMealTrack(),

      /// ✅ FIX: feedback ALWAYS PASSED
      feedback: widget.existingPlan?.feedback ?? {},
    );

    final bloc = context.read<MealPlanBloc>();

    if (widget.existingPlan != null) {
      bloc.add(UpdateMealPlan(finalPlan));
    } else {
      bloc.add(AddMealPlan(finalPlan));
    }

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
                    onAddDish: () =>
                        setState(() => meal.items.add(MealItemDraft())),
                    onRemoveDish: (i) => setState(() => meal.items.removeAt(i)),
                    onDietChanged: (i, diet) =>
                        setState(() => meal.items[i].diet = diet),
                  );
                },
              ),
            ),

            /// SAVE BUTTON (UNCHANGED)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFormValid
                        ? AppColors.accentBlue
                        : AppColors.textMutedDark,
                  ),
                  onPressed: _isFormValid ? _savePlan : null,
                  child: const Text('Save'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
