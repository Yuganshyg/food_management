import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';
import '../../data/models/meal_plan_model.dart';
import 'set_plan_screen.dart';

class AddPlanScreen extends StatefulWidget {
  final MealPlan? existingPlan;

  const AddPlanScreen({super.key, this.existingPlan});

  @override
  State<AddPlanScreen> createState() => _AddPlanScreenState();
}

class _AddPlanScreenState extends State<AddPlanScreen> {
  final TextEditingController planNameController = TextEditingController();

  bool showBreakdown = true;

  static const List<String> _frequencies = ['Daily', 'Weekly', 'Monthly'];

  String frequency = 'Monthly';

  final Map<String, TextEditingController> priceControllers = {
    'Breakfast': TextEditingController(text: '30'),
    'Lunch': TextEditingController(text: '80'),
    'Snacks': TextEditingController(text: '30'),
    'Dinner': TextEditingController(text: '80'),
  };

  final Set<String> selectedMeals = {};

  @override
  void initState() {
    super.initState();

    final plan = widget.existingPlan;

    if (plan != null) {
      planNameController.text = plan.name;

      final normalized =
          '${plan.frequency[0].toUpperCase()}${plan.frequency.substring(1).toLowerCase()}';

      frequency = _frequencies.contains(normalized) ? normalized : 'Monthly';

      if (plan.selectedMeals.isNotEmpty) {
        selectedMeals.addAll(plan.selectedMeals);
      } else {
        selectedMeals.addAll(priceControllers.keys);
      }

      plan.mealPrices.forEach((meal, price) {
        if (priceControllers.containsKey(meal)) {
          priceControllers[meal]!.text = price.toString();
        }
      });
    } else {
      selectedMeals.addAll(priceControllers.keys);
    }
  }

  int get _multiplier {
    switch (frequency) {
      case 'Daily':
        return 1;
      case 'Weekly':
        return 7;
      case 'Monthly':
      default:
        return 30;
    }
  }

  int get totalAmount {
    int sum = 0;
    for (final meal in selectedMeals) {
      sum += int.tryParse(priceControllers[meal]?.text ?? '0') ?? 0;
    }
    return sum * _multiplier;
  }

  void _continue() {
    final draft = MealPlan.draft(
      name: planNameController.text.trim().isEmpty
          ? 'Meal Plan'
          : planNameController.text.trim(),
      frequency: frequency,
      amount: totalAmount,
      selectedMeals: selectedMeals.toList(),
      mealPrices: {
        for (final m in selectedMeals)
          m: int.tryParse(priceControllers[m]?.text ?? '0') ?? 0,
      },
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SetPlanScreen(
          draftPlan: draft,
          existingPlan: widget.existingPlan, // 🔑 PASS IT
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Add Plan'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _card(
                    child: Row(
                      children: [
                        SvgPicture.asset(AppIcons.plan, height: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: planNameController,
                            decoration: const InputDecoration(
                              hintText: 'Enter plan name',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      const Text('Show price breakdown per meal'),
                      const Spacer(),
                      Switch(
                        value: showBreakdown,
                        activeColor: AppColors.accentBlue,
                        onChanged: (v) => setState(() => showBreakdown = v),
                      ),
                    ],
                  ),

                  if (showBreakdown)
                    _card(
                      child: Column(
                        children: priceControllers.keys.map((meal) {
                          final checked = selectedMeals.contains(meal);

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: checked,
                                  activeColor: AppColors.accentBlue,
                                  onChanged: (v) {
                                    setState(() {
                                      v!
                                          ? selectedMeals.add(meal)
                                          : selectedMeals.remove(meal);
                                    });
                                  },
                                ),
                                Text(meal),
                                const Spacer(),
                                SizedBox(
                                  width: 80,
                                  child: TextField(
                                    controller: priceControllers[meal],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      prefixText: '₹ ',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onChanged: (_) => setState(() {}),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                  const SizedBox(height: 16),

                  _card(
                    child: Row(
                      children: [
                        const Icon(Icons.currency_rupee),
                        const SizedBox(width: 8),
                        Text(
                          '$totalAmount',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  _card(
                    child: Row(
                      children: [
                        SvgPicture.asset(AppIcons.calendar, height: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: frequency,
                              isExpanded: true,
                              items: _frequencies
                                  .map(
                                    (f) => DropdownMenuItem(
                                      value: f,
                                      child: Text(f),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) => setState(() => frequency = v!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _continue,
                  child: const Text(
                    'Save & Continue',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.textMutedDark),
      ),
      child: child,
    );
  }
}
