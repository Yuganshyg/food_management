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

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int selectedDayIndex = DateTime.now().weekday % 7;
  int selectedPlanIndex = 0;

  final expandedIndex = ValueNotifier<int?>(0);
  final weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool isDropdownOpen = false;

  @override
  void dispose() {
    _removeDropdown();
    expandedIndex.dispose();
    super.dispose();
  }

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

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topRow(plans, selectedPlan),
              const SizedBox(height: 16),

              _weekStrip(),
              const SizedBox(height: 12),

              _dateChip(dateText),
              const SizedBox(height: 20),

              _mealList(selectedPlan),
            ],
          ),
        );
      },
    );
  }

  // ---------------- TOP ROW ----------------

  Widget _topRow(List<MealPlan> plans, MealPlan selectedPlan) {
    return Row(
      children: [
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: () {
              if (isDropdownOpen) {
                _removeDropdown();
              } else {
                _showDropdown(plans);
              }
            },
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.textMutedDark),
                color: const Color(0xFF1E1E1E),
              ),
              child: Row(
                children: [
                  Text(
                    selectedPlan.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isDropdownOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
        const Spacer(),
        const Icon(Icons.edit_square, color: Colors.white, size: 22),
      ],
    );
  }

  // ---------------- DROPDOWN OVERLAY ----------------

  void _showDropdown(List<MealPlan> plans) {
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 32,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: const Offset(0, 56),
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2B2B2B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(plans.length, (index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedPlanIndex = index;
                        expandedIndex.value = null;
                      });
                      _removeDropdown();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
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
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() => isDropdownOpen = true);
  }

  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => isDropdownOpen = false);
  }

  // ---------------- WEEK STRIP ----------------

  Widget _weekStrip() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 190, 189, 189),
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
                  color: isSelected ? Colors.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    weekDays[index],
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.accentBlue
                          : const Color.fromARGB(255, 75, 74, 74),
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
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

  // ---------------- MEALS ----------------

  Widget _mealList(MealPlan plan) {
    return Column(
      children: List.generate(
        plan.meals.length,
        (index) => _mealAccordion(plan.meals[index], index),
      ),
    );
  }

  Widget _mealAccordion(Meal meal, int index) {
    return ValueListenableBuilder<int?>(
      valueListenable: expandedIndex,
      builder: (_, expanded, __) {
        final isExpanded = expanded == index;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.textMutedDark),
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () => expandedIndex.value = isExpanded ? null : index,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        meal.type,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Timing: ${meal.startTime} - ${meal.endTime}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textMutedDark,
                          ),
                        ),
                      ),
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                      ),
                    ],
                  ),
                ),
              ),
              if (isExpanded)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    children: meal.items.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              item.diet == 'veg'
                                  ? AppIcons.veg
                                  : AppIcons.nonVeg,
                              height: 16,
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Text(item.name)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
