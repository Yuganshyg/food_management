import '../models/meal_model.dart';
import '../models/meal_item_model.dart';
import '../models/meal_plan_model.dart';
import 'meal_draft.dart';
import 'meal_item_draft.dart';

class DraftMapper {
  static Meal toMeal(MealDraft draft, int id) {
    return Meal(
      id: id,
      type: draft.type,
      startTime: draft.startTime,
      endTime: draft.endTime,
      items: draft.items.map(toMealItem).toList(),
    );
  }

  static MealItem toMealItem(MealItemDraft draft) {
    return MealItem(
      name: draft.controller.text.trim(),
      diet: draft.diet ?? 'veg',
    );
  }

  static MealPlan toMealPlan({
    required int id,
    required String name,
    required String frequency,
    required int amount,
    required List<MealDraft> meals,
    required Map<String, int> mealPrices,
    required Map<String, Map<String, Map<String, int>>> mealTrack,
  }) {
    return MealPlan(
      id: id,
      name: name,
      frequency: frequency,
      amount: amount,
      selectedMeals: meals.map((e) => e.type).toList(),
      mealPrices: mealPrices,
      meals: meals
          .asMap()
          .entries
          .map((e) => toMeal(e.value, e.key + 1))
          .toList(),
      mealTrack: mealTrack,
    );
  }
}
