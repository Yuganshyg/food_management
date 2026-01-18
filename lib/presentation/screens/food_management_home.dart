import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';
import 'meal_plan_list_screen.dart';

class FoodManagementHome extends StatefulWidget {
  const FoodManagementHome({super.key});

  @override
  State<FoodManagementHome> createState() => _FoodManagementHomeState();
}

class _FoodManagementHomeState extends State<FoodManagementHome> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isDark),
            _buildTabs(isDark),
            Expanded(
              child: IndexedStack(
                index: selectedIndex,
                children: const [
                  MealPlanListScreen(),
                  Center(child: Text('Menu')),
                  Center(child: Text('Meal Track')),
                  Center(child: Text('Feedback')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- HEADER ----------------

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          /// Back arrow (Material icon – NOT in SVG)
          Icon(
            Icons.arrow_back,
            size: 22,
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
          const SizedBox(width: 12),

          /// Title
          Text(
            'Food Management',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),

          const Spacer(),

          TextButton.icon(
            onPressed: () {
              // TODO: navigate to Add Plan screen
            },
            icon: Icon(Icons.add, size: 20, color: AppColors.accentBlue),
            label: const Text(
              'Add Plan',
              style: TextStyle(
                color: AppColors.accentBlue,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- TABS ----------------

  Widget _buildTabs(bool isDark) {
    final tabs = [
      AppIcons.mealPlan,
      AppIcons.menu,
      AppIcons.mealTrack,
      AppIcons.feedback,
    ];

    final labels = ['Meal Plan', 'Menu', 'Meal Track', 'Feedback'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(tabs.length, (index) {
          final isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () => setState(() => selectedIndex = index),
            child: Column(
              children: [
                SvgPicture.asset(
                  tabs[index],
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    isSelected
                        ? AppColors.accentBlue
                        : (isDark
                              ? AppColors.textMutedDark
                              : AppColors.textMutedLight),
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  labels[index],
                  style: TextStyle(
                    fontSize: 13,
                    color: isSelected
                        ? AppColors.accentBlue
                        : (isDark
                              ? AppColors.textMutedDark
                              : AppColors.textMutedLight),
                  ),
                ),
                const SizedBox(height: 6),
                if (isSelected)
                  Container(height: 2, width: 40, color: AppColors.accentBlue),
              ],
            ),
          );
        }),
      ),
    );
  }
}
