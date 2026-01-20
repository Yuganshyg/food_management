import 'meal_model.dart';

class MealPlan {
  final int id;
  final String name;
  final String frequency;
  final int amount;

  final List<String> selectedMeals;
  final List<Meal> meals;

  MealPlan({
    required this.id,
    required this.name,
    required this.frequency,
    required this.amount,
    required this.selectedMeals,
    required this.meals,
  });

  factory MealPlan.draft({
    required String name,
    required String frequency,
    required int amount,
    required List<String> selectedMeals,
  }) {
    return MealPlan(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
      frequency: frequency,
      amount: amount,
      selectedMeals: selectedMeals,
      meals: const [],
    );
  }

  MealPlan copyWith({
    int? id,
    String? name,
    String? frequency,
    int? amount,
    List<String>? selectedMeals,
    List<Meal>? meals,
  }) {
    return MealPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      frequency: frequency ?? this.frequency,
      amount: amount ?? this.amount,
      selectedMeals: selectedMeals ?? this.selectedMeals,
      meals: meals ?? this.meals,
    );
  }

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['id'] as int,
      name: json['name'] as String,
      frequency: json['frequency'] as String,
      amount: json['amount'] as int,
      selectedMeals: List<String>.from(json['selectedMeals'] ?? const []),
      meals: (json['meals'] as List)
          .map((e) => Meal.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'frequency': frequency,
      'amount': amount,
      'selectedMeals': selectedMeals,
      'meals': meals.map((e) => e.toJson()).toList(),
    };
  }
}
