import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

/// Strongly typed tab model (NO MAPS → NO TYPE ERRORS)
class MealTab {
  final String label;
  final String icon;

  const MealTab({required this.label, required this.icon});
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int selectedMealIndex = 0;

  final List<MealTab> mealTabs = const [
    MealTab(label: 'Breakfast', icon: AppIcons.breakfast),
    MealTab(label: 'Lunch', icon: AppIcons.lunch),
    MealTab(label: 'Snacks', icon: AppIcons.snacks),
    MealTab(label: 'Dinner', icon: AppIcons.dinner),
  ];

  final List<Map<String, dynamic>> feedbacks = [
    {
      'name': 'Amit',
      'message': 'Food quality was really good today.',
      'rating': 4,
      'date': DateTime.now(),
      'time': '09:30 AM',
    },
    {
      'name': 'Sneha',
      'message': 'Lunch was tasty but a bit oily.',
      'rating': 3,
      'date': DateTime.now(),
      'time': '02:10 PM',
    },
    {
      'name': 'Rahul',
      'message': 'Dinner was excellent. Loved it!',
      'rating': 5,
      'date': DateTime.now(),
      'time': '09:45 PM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _mealTabsRow(),
          const SizedBox(height: 20),
          Expanded(child: _feedbackList()),
        ],
      ),
    );
  }

  // ---------------- MEAL TABS ----------------

  Widget _mealTabsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(mealTabs.length, (index) {
          final tab = mealTabs[index];
          final isSelected = selectedMealIndex == index;

          return GestureDetector(
            onTap: () => setState(() => selectedMealIndex = index),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.accentBlue.withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.accentBlue
                      : AppColors.textMutedDark,
                ),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    tab.icon,
                    height: 16,
                    color: isSelected
                        ? AppColors.accentBlue
                        : AppColors.textMutedDark,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    tab.label,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.accentBlue
                          : AppColors.textMutedDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // ---------------- FEEDBACK LIST ----------------

  Widget _feedbackList() {
    return ListView.builder(
      itemCount: feedbacks.length,
      itemBuilder: (_, index) {
        return _feedbackCard(feedbacks[index]);
      },
    );
  }

  // ---------------- FEEDBACK CARD ----------------

  Widget _feedbackCard(Map<String, dynamic> data) {
    final initials = data['name'][0];
    final dateText = DateFormat('d MMM yyyy').format(data['date']);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2E2E38),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accentBlue.withOpacity(0.2),
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: AppColors.accentBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['name'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dateText,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMutedDark,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                data['time'],
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMutedDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            data['message'],
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),

          const SizedBox(height: 12),

          // ⭐ YELLOW STARS
          Row(
            children: List.generate(5, (index) {
              return Padding(
                padding: const EdgeInsets.only(right: 4),
                child: SvgPicture.asset(
                  AppIcons.star,
                  height: 16,
                  color: index < data['rating']
                      ? const Color(0xFFFFC107) // YELLOW
                      : AppColors.textMutedDark,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
