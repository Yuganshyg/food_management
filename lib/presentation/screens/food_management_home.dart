import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_management/presentation/screens/feedback_screen.dart';
import 'package:food_management/presentation/screens/meal_track_screen.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';
import 'meal_plan_list_screen.dart';
import 'menu_screen.dart';
import 'add_plan_screen.dart';

class FoodManagementHome extends StatefulWidget {
  const FoodManagementHome({super.key});

  @override
  State<FoodManagementHome> createState() => _FoodManagementHomeState();
}

class _FoodManagementHomeState extends State<FoodManagementHome> {
  int selectedIndex = 0;

  final tabs = [
    AppIcons.mealPlan,
    AppIcons.menu,
    AppIcons.mealTrack,
    AppIcons.feedback,
  ];

  final labels = ['Meal Plan', 'Menu', 'Meal Track', 'Feedback'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            _tabBar(isDark),
            Expanded(
              child: IndexedStack(
                index: selectedIndex,
                children: const [
                  MealPlanListScreen(),
                  MenuScreen(),
                  MealTrackScreen(),
                  FeedbackScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- HEADER ----------------

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          const Icon(Icons.arrow_back, color: Colors.white),
          const SizedBox(width: 12),
          const Text(
            'Food Management',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const Spacer(),

          /// Add Plan ONLY on Meal Plan tab
          if (selectedIndex == 0)
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddPlanScreen()),
                );
              },
              icon: const Icon(Icons.add, color: AppColors.accentBlue),
              label: const Text(
                'Add Plan',
                style: TextStyle(color: AppColors.accentBlue),
              ),
            ),
        ],
      ),
    );
  }

  // ---------------- TAB BAR (SVG ICONS RESTORED) ----------------

  Widget _tabBar(bool isDark) {
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
                    isSelected ? AppColors.accentBlue : AppColors.textMutedDark,
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
                        : AppColors.textMutedDark,
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
