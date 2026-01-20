import 'meal_model.dart';

class MealPlan {
  final int id;
  final String name;
  final String frequency;
  final int amount;
  final List<String> selectedMeals;

  /// price per meal (Breakfast → 30 etc.)
  final Map<String, int> mealPrices;

  /// day → meal → { veg, nonVeg }
  final Map<String, Map<String, Map<String, int>>> mealTrack;

  final List<Meal> meals;

  MealPlan({
    required this.id,
    required this.name,
    required this.frequency,
    required this.amount,
    required this.selectedMeals,
    required this.mealPrices,
    required this.mealTrack,
    required this.meals,
  });

  // ─────────────────────────────────────────────
  // DRAFT CONSTRUCTOR (AddPlanScreen → SetPlan)
  // ─────────────────────────────────────────────
  factory MealPlan.draft({
    required String name,
    required String frequency,
    required int amount,
    required List<String> selectedMeals,
    required Map<String, int> mealPrices,
  }) {
    return MealPlan(
      id: -1, // temporary, replaced later
      name: name,
      frequency: frequency,
      amount: amount,
      selectedMeals: selectedMeals,
      mealPrices: mealPrices,
      mealTrack: {}, // created later
      meals: [],
    );
  }

  // ─────────────────────────────────────────────
  // COPY WITH (Repository uses this)
  // ─────────────────────────────────────────────
  MealPlan copyWith({
    int? id,
    String? name,
    String? frequency,
    int? amount,
    List<String>? selectedMeals,
    Map<String, int>? mealPrices,
    Map<String, Map<String, Map<String, int>>>? mealTrack,
    List<Meal>? meals,
  }) {
    return MealPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      frequency: frequency ?? this.frequency,
      amount: amount ?? this.amount,
      selectedMeals: selectedMeals ?? this.selectedMeals,
      mealPrices: mealPrices ?? this.mealPrices,
      mealTrack: mealTrack ?? this.mealTrack,
      meals: meals ?? this.meals,
    );
  }

  // ─────────────────────────────────────────────
  // JSON
  // ─────────────────────────────────────────────
  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['id'],
      name: json['name'],
      frequency: json['frequency'],
      amount: json['amount'],
      selectedMeals: List<String>.from(json['selectedMeals']),
      mealPrices: Map<String, int>.from(json['mealPrices'] ?? {}),
      mealTrack: (json['mealTrack'] as Map<String, dynamic>).map(
        (day, meals) => MapEntry(
          day,
          (meals as Map<String, dynamic>).map(
            (meal, counts) => MapEntry(meal, {
              'veg': counts['veg'] ?? 0,
              'nonVeg': counts['nonVeg'] ?? 0,
            }),
          ),
        ),
      ),
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
      'mealTrack': mealTrack,
      'meals': meals.map((e) => e.toJson()).toList(),
    };
  }
}
