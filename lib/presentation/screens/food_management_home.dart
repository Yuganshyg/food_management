import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_management/core/constants/app_icons.dart';

import '../../core/constants/app_colors.dart';
import '../widgets/top_navigation_tabs.dart';

// Screens
import 'meal_plan_list_screen.dart';
import 'menu_screen.dart';
import 'meal_track_screen.dart';
import 'feedback_screen.dart';
import 'add_plan_screen.dart';

class FoodManagementHome extends StatefulWidget {
  const FoodManagementHome({super.key});

  @override
  State<FoodManagementHome> createState() => _FoodManagementHomeState();
}

class _FoodManagementHomeState extends State<FoodManagementHome> {
  int selectedIndex = 0;

  bool get isMealPlanTab => selectedIndex == 0;
  bool get isMenuTab => selectedIndex == 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // ───────── HEADER ─────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// BACK ICON
                  const Icon(Icons.arrow_back, size: 20),

                  const SizedBox(width: 12),

                  /// TITLE
                  Text(
                    'Food Management',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const Spacer(),

                  /// ✅ FILTER ICON (ONLY MENU TAB)
                  if (isMenuTab)
                    GestureDetector(
                      onTap: () {
                        // TODO: open filter bottom sheet
                      },
                      child: SvgPicture.asset(AppIcons.slider, height: 28),
                    ),

                  /// spacing between filter and add plan (if both ever exist)
                  if (isMenuTab) const SizedBox(width: 16),

                  /// ✅ "+ Add Plan" (ONLY MEAL PLAN TAB)
                  if (isMealPlanTab)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddPlanScreen(),
                          ),
                        );
                      },
                      child: Row(
                        children: const [
                          Text(
                            '+',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.accentBlue,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Add Plan',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.accentBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // ───────── TABS ─────────
            TopNavigationTabs(
              selectedIndex: selectedIndex,
              onChanged: (index) {
                setState(() => selectedIndex = index);
              },
            ),

            Divider(height: 1, color: theme.dividerColor),

            // ───────── BODY ─────────
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
}
