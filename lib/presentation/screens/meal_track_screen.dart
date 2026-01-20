import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../bloc/meal_plan/meal_plan_bloc.dart';
import '../../bloc/meal_plan/meal_plan_state.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';
import '../../data/models/meal_model.dart';
import '../../data/models/meal_plan_model.dart';

class MealTrackScreen extends StatefulWidget {
  const MealTrackScreen({super.key});

  @override
  State<MealTrackScreen> createState() => _MealTrackScreenState();
}

class _MealTrackScreenState extends State<MealTrackScreen> {
  int selectedDayIndex = DateTime.now().weekday % 7;
  int selectedPlanIndex = 0;
  bool isPlanExpanded = false;

  final weekDays = const ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  final weekKeys = const ['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat'];

  @override
  Widget build(BuildContext context) {
    final dateText = DateFormat('d MMMM').format(DateTime.now());

    return BlocBuilder<MealPlanBloc, MealPlanState>(
      builder: (context, state) {
        if (state is! MealPlanLoaded || state.plans.isEmpty) {
          return const SizedBox();
        }

        final plans = state.plans;
        final selectedPlan = plans[selectedPlanIndex];
        final selectedDayKey = weekKeys[selectedDayIndex];

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _planDropdown(plans),
              if (isPlanExpanded) _planDropdownList(plans),

              const SizedBox(height: 16),
              _weekStrip(),

              const SizedBox(height: 12),
              _dateChip(dateText),

              const SizedBox(height: 20),

              ...selectedPlan.meals.map((meal) {
                /// 🔑 FIX 1: Normalize meal type
                final mealKey =
                    '${meal.type[0].toUpperCase()}${meal.type.substring(1).toLowerCase()}';

                final counts = selectedPlan.mealTrack[selectedDayKey]?[mealKey];

                return _mealTrackCard(meal, counts);
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  // ---------------- PLAN DROPDOWN ----------------

  Widget _planDropdown(List<MealPlan> plans) {
    return GestureDetector(
      onTap: () => setState(() => isPlanExpanded = !isPlanExpanded),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.textMutedDark),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(plans[selectedPlanIndex].name),
            const SizedBox(width: 8),
            Icon(
              isPlanExpanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
            ),
          ],
        ),
      ),
    );
  }

  Widget _planDropdownList(List<MealPlan> plans) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2E2E38),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: List.generate(plans.length, (index) {
          return InkWell(
            onTap: () {
              setState(() {
                selectedPlanIndex = index;
                isPlanExpanded = false;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  plans[index].name,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ---------------- WEEK STRIP ----------------

  Widget _weekStrip() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFD6D6D6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: List.generate(7, (index) {
          final isSelected = selectedDayIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedDayIndex = index),
              child: Container(
                height: 36,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF2E2E38)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    weekDays[index],
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.accentBlue
                          : const Color(0xFF5C5C5C),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ---------------- DATE CHIP ----------------

  Widget _dateChip(String date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF3A3A3A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(date, style: const TextStyle(color: Colors.white)),
    );
  }

  // ---------------- MEAL TRACK CARD ----------------

  Widget _mealTrackCard(Meal meal, Map<String, int>? counts) {
    /// 🔑 FIX 2: Correct keys
    final vegCount = counts?['veg'] ?? 0;
    final nonVegCount = counts?['nonVeg'] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 110,
      decoration: BoxDecoration(
        color: const Color(0xFF2E2E38),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipPath(
            clipper: _SlantClipper(),
            child: Container(
              width: 120,
              color: const Color(0xFF36406A),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    _mealIcon(meal.type),
                    height: 28,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    meal.type,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  SvgPicture.asset(AppIcons.veg, height: 16),
                  const SizedBox(width: 6),
                  Text(
                    vegCount.toString().padLeft(2, '0'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  SvgPicture.asset(AppIcons.nonVeg, height: 16),
                  const SizedBox(width: 6),
                  Text(
                    nonVegCount.toString().padLeft(2, '0'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _mealIcon(String type) {
    switch (type.toLowerCase()) {
      case 'breakfast':
        return AppIcons.breakfast;
      case 'lunch':
        return AppIcons.lunch;
      case 'snacks':
        return AppIcons.snacks;
      case 'dinner':
        return AppIcons.dinner;
      default:
        return AppIcons.breakfast;
    }
  }
}

// ---------------- SLANT CLIPPER ----------------

class _SlantClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width - 20, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - 20, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
