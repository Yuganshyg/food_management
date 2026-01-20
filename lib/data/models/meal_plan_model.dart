import 'meal_model.dart';

class MealPlan {
  final int id;
  final String name;
  final String frequency; // Daily / Weekly / Monthly
  final int amount;

  /// Selected meal types
  final List<String> selectedMeals;

  /// Price per meal (Breakfast → 30 etc)
  final Map<String, int> mealPrices;

  /// Fully configured meals
  final List<Meal> meals;

  const MealPlan({
    required this.id,
    required this.name,
    required this.frequency,
    required this.amount,
    required this.selectedMeals,
    required this.mealPrices,
    required this.meals,
  });

  // ───────── DRAFT (AddPlan → SetPlan) ─────────
  factory MealPlan.draft({
    required String name,
    required String frequency,
    required int amount,
    required List<String> selectedMeals,
    required Map<String, int> mealPrices,
  }) {
    return MealPlan(
      id: -1, // temporary
      name: name,
      frequency: frequency,
      amount: amount,
      selectedMeals: selectedMeals,
      mealPrices: mealPrices,
      meals: const [],
    );
  }

  // ───────── COPY WITH (FIXES UPDATE BUG) ─────────
  MealPlan copyWith({
    int? id,
    String? name,
    String? frequency,
    int? amount,
    List<String>? selectedMeals,
    Map<String, int>? mealPrices,
    List<Meal>? meals,
  }) {
    return MealPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      frequency: frequency ?? this.frequency,
      amount: amount ?? this.amount,
      selectedMeals: selectedMeals ?? this.selectedMeals,
      mealPrices: mealPrices ?? this.mealPrices,
      meals: meals ?? this.meals,
    );
  }

  // ───────── JSON ─────────
  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['id'],
      name: json['name'],
      frequency: json['frequency'],
      amount: json['amount'],
      selectedMeals: List<String>.from(json['selectedMeals'] ?? const []),
      mealPrices: Map<String, int>.from(json['mealPrices'] ?? {}),
      meals: (json['meals'] as List).map((e) => Meal.fromJson(e)).toList(),
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
    };
  }
}
