import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';
import '../../data/draft/meal_draft.dart';

class MealSetupCard extends StatelessWidget {
  final MealDraft meal;
  final VoidCallback onTimePickStart;
  final VoidCallback onTimePickEnd;
  final VoidCallback onAddDish;
  final Function(int index) onRemoveDish;
  final Function(int index, String diet) onDietChanged;

  const MealSetupCard({
    super.key,
    required this.meal,
    required this.onTimePickStart,
    required this.onTimePickEnd,
    required this.onAddDish,
    required this.onRemoveDish,
    required this.onDietChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 40),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.textMutedDark),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 16),
              _timeRow(),
              const SizedBox(height: 16),
              _listSection(),
            ],
          ),
        ),

        /// ➕ HALF INSIDE / HALF OUTSIDE (SVG)
        Positioned(
          bottom: 20,
          right: 20,
          child: GestureDetector(
            onTap: onAddDish,
            child: Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: AppColors.accentBlue,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  // ───────── HEADER ─────────
  Widget _header() {
    return Row(
      children: [
        SvgPicture.asset(_iconForMeal(meal.type), height: 20),
        const SizedBox(width: 8),
        Text(
          meal.type,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  // ───────── TIME ROW ─────────
  Widget _timeRow() {
    return Row(
      children: [
        Expanded(
          child: _timeBox('Start Time', meal.startTime, onTimePickStart),
        ),
        const SizedBox(width: 12),
        Expanded(child: _timeBox('End Time', meal.endTime, onTimePickEnd)),
      ],
    );
  }

  /// 🔑 FIX: value is String?
  Widget _timeBox(String label, String? value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.textMutedDark),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMutedDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text((value == null || value.isEmpty) ? '--:--' : value),
                ],
              ),
            ),
            const Icon(Icons.access_time, size: 18),
          ],
        ),
      ),
    );
  }

  // ───────── ITEMS LIST ─────────
  Widget _listSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${meal.type} List',
          style: const TextStyle(fontSize: 13, color: AppColors.textMutedDark),
        ),
        const SizedBox(height: 12),

        ...List.generate(meal.items.length, (index) {
          final item = meal.items[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: item.controller,
                    textDirection: TextDirection.ltr,
                    decoration: const InputDecoration(
                      hintText: 'Enter Item',
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // VEG
                _dietToggle(
                  icon: AppIcons.veg,
                  selected: item.diet == 'veg',
                  color: Colors.green,
                  onTap: () => onDietChanged(index, 'veg'),
                ),

                const SizedBox(width: 10),

                // NON-VEG
                _dietToggle(
                  icon: AppIcons.nonVeg,
                  selected: item.diet == 'nonVeg',
                  color: Colors.red,
                  onTap: () => onDietChanged(index, 'nonVeg'),
                ),

                const SizedBox(width: 10),

                GestureDetector(
                  onTap: () => onRemoveDish(index),
                  child: const Icon(Icons.close, size: 18),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ───────── DIET TOGGLE ─────────
  Widget _dietToggle({
    required String icon,
    required bool selected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(icon, height: 16),
          const SizedBox(width: 6),
          Container(
            height: 18,
            width: 18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: color),
              color: selected ? color : Colors.transparent,
            ),
            child: selected
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : null,
          ),
        ],
      ),
    );
  }

  String _iconForMeal(String type) {
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
