import 'meal_model.dart';

class MealPlan {
  final int id;
  final String name;
  final String frequency;
  final int amount;
  final List<Meal> meals;

  MealPlan({
    required this.id,
    required this.name,
    required this.frequency,
    required this.amount,
    required this.meals,
  });

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['id'],
      name: json['name'],
      frequency: json['frequency'],
      amount: json['amount'],
      meals: (json['meals'] as List).map((e) => Meal.fromJson(e)).toList(),
    );
  }
}
