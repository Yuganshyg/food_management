import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/meal_plan/meal_plan_bloc.dart';
import '../../bloc/meal_plan/meal_plan_state.dart';
import '../../core/constants/app_colors.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  String selectedMeal = 'Breakfast';

  final meals = const [
    ('Breakfast', Icons.free_breakfast),
    ('Lunch', Icons.restaurant),
    ('Snacks', Icons.cookie),
    ('Dinner', Icons.dinner_dining),
  ];

  final Map<String, List<_FeedbackUiModel>> dummyFeedback = {
    'Breakfast': [
      _FeedbackUiModel(
        name: 'Rajat Kumar',
        comment:
            'The food quality was good but spoon and glass need to be clean properly',
        rating: 4,
        date: '08 Oct, 2024',
        time: '11:02am',
      ),
      _FeedbackUiModel(
        name: 'Shyam Kumar',
        comment:
            'The food quality was good but spoon and glass need to be clean properly',
        rating: 4,
        date: '08 Oct, 2024',
        time: '11:02am',
      ),
      _FeedbackUiModel(
        name: 'Amit Kumar',
        comment:
            'The food quality was good but spoon and glass need to be clean properly',
        rating: 4,
        date: '08 Oct, 2024',
        time: '11:02am',
      ),
    ],
    'Lunch': [],
    'Snacks': [],
    'Dinner': [],
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MealPlanBloc, MealPlanState>(
      builder: (context, state) {
        final feedbackList = dummyFeedback[selectedMeal] ?? [];

        return Column(
          children: [
            const SizedBox(height: 12),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: meals.map((entry) {
                  final meal = entry.$1;
                  final icon = entry.$2;
                  final isSelected = meal == selectedMeal;

                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => setState(() => selectedMeal = meal),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.accentBlue.withOpacity(0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.accentBlue
                                : AppColors.textMutedDark,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              icon,
                              size: 16,
                              color: isSelected
                                  ? AppColors.accentBlue
                                  : AppColors.textMutedDark,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              meal,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? AppColors.accentBlue
                                    : AppColors.textMutedDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: feedbackList.length,
                itemBuilder: (_, index) {
                  final feedback = feedbackList[index];
                  final initial = feedback.name[0].toUpperCase();

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E2E38),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.accentBlue.withOpacity(0.35),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: AppColors.accentBlue.withOpacity(
                                0.2,
                              ),
                              child: Text(
                                initial,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.accentBlue,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    feedback.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    feedback.date,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textMutedDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Text(
                              feedback.time,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textMutedDark,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Text(
                          feedback.comment,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 12),
                        Row(
                          children: List.generate(5, (i) {
                            return Icon(
                              i < feedback.rating
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 20,
                              color: Colors.amber,
                            );
                          }),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FeedbackUiModel {
  final String name;
  final String comment;
  final int rating;
  final String date;
  final String time;

  const _FeedbackUiModel({
    required this.name,
    required this.comment,
    required this.rating,
    required this.date,
    required this.time,
  });
}
