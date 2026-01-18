import 'package:flutter/material.dart';
import 'package:food_management/core/constants/app_colors.dart';
import 'package:food_management/data/models/meal_model.dart';
import '../../data/models/meal_plan_model.dart';
import '../../core/utils/string_extensions.dart';

class MealPlanCard extends StatelessWidget {
  final MealPlan plan;

  const MealPlanCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.08),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          /// HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.cardHeaderDark
                  : AppColors.cardHeaderLight,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Text(
              '${plan.name} (${plan.frequency.capitalize()})',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
          ),

          /// BODY
          Container(
            padding: const EdgeInsets.all(16),
            color: isDark ? AppColors.cardBodyDark : AppColors.cardBodyLight,
            child: Row(
              children: [
                Expanded(child: _mealColumn(plan.meals, 0, isDark)),
                Expanded(child: _mealColumn(plan.meals, 1, isDark)),
              ],
            ),
          ),

          /// AMOUNT
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.amountBgDark : AppColors.amountBgLight,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Amount:',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.textMutedDark
                        : AppColors.textMutedLight,
                  ),
                ),
                const Spacer(),
                Text(
                  '₹ ${plan.amount}',
                  style: const TextStyle(
                    color: AppColors.accentBlue,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mealColumn(List<Meal> meals, int columnIndex, bool isDark) {
    final filteredMeals = meals
        .asMap()
        .entries
        .where((entry) => entry.key % 2 == columnIndex)
        .map((entry) => entry.value)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: filteredMeals.map((Meal meal) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            '• ${meal.type.capitalize()}',
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
        );
      }).toList(),
    );
  }
}
