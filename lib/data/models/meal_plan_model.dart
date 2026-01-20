import 'meal_model.dart';
import 'feedback_item.dart';

class MealPlan {
  final int id;
  final String name;
  final String frequency;
  final int amount;
  final List<String> selectedMeals;
  final Map<String, int> mealPrices;
  final List<Meal> meals;

  final Map<String, Map<String, Map<String, int>>> mealTrack;

  final Map<String, List<FeedbackItem>> feedback;

  MealPlan({
    required this.id,
    required this.name,
    required this.frequency,
    required this.amount,
    required this.selectedMeals,
    required this.mealPrices,
    required this.meals,
    required this.mealTrack,
    required this.feedback,
  });

  factory MealPlan.draft({
    required String name,
    required String frequency,
    required int amount,
    required List<String> selectedMeals,
    required Map<String, int> mealPrices,
  }) {
    return MealPlan(
      id: -1,
      name: name,
      frequency: frequency,
      amount: amount,
      selectedMeals: selectedMeals,
      mealPrices: mealPrices,
      meals: const [],
      mealTrack: const {},
      feedback: const {},
    );
  }

  MealPlan copyWith({
    int? id,
    String? name,
    String? frequency,
    int? amount,
    List<String>? selectedMeals,
    Map<String, int>? mealPrices,
    List<Meal>? meals,
    Map<String, Map<String, Map<String, int>>>? mealTrack,
    Map<String, List<FeedbackItem>>? feedback,
  }) {
    return MealPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      frequency: frequency ?? this.frequency,
      amount: amount ?? this.amount,
      selectedMeals: selectedMeals ?? this.selectedMeals,
      mealPrices: mealPrices ?? this.mealPrices,
      meals: meals ?? this.meals,
      mealTrack: mealTrack ?? this.mealTrack,
      feedback: feedback ?? this.feedback,
    );
  }

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['id'],
      name: json['name'],
      frequency: json['frequency'],
      amount: json['amount'],
      selectedMeals: List<String>.from(json['selectedMeals']),
      mealPrices: Map<String, int>.from(json['mealPrices'] ?? {}),
      meals: (json['meals'] as List).map((e) => Meal.fromJson(e)).toList(),
      mealTrack: (json['mealTrack'] as Map<String, dynamic>).map(
        (day, meals) => MapEntry(
          day,
          (meals as Map<String, dynamic>).map(
            (meal, counts) => MapEntry(meal, Map<String, int>.from(counts)),
          ),
        ),
      ),
      feedback: (json['feedback'] as Map<String, dynamic>? ?? {}).map(
        (meal, list) => MapEntry(
          meal,
          (list as List).map((e) => FeedbackItem.fromJson(e)).toList(),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'frequency': frequency,
      'amount': amount,
      'selectedMeals': selectedMeals,
      'mealPrices': mealPrices,
      'meals': meals.map((e) => e.toJson()).toList(),
      'mealTrack': mealTrack,
      'feedback': {
        for (final e in feedback.entries)
          e.key: e.value.map((f) => f.toJson()).toList(),
      },
    };
  }
}
