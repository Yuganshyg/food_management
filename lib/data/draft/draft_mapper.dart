import '../models/meal_model.dart';
import '../models/meal_item_model.dart';
import '../models/meal_plan_model.dart';
import 'meal_draft.dart';
import 'meal_item_draft.dart';

class DraftMapper {
  static Meal toMeal(MealDraft draft, int mealId) {
    return Meal(
      id: mealId,
      type: draft.type,
      startTime: draft.startTime,
      endTime: draft.endTime,
      items: draft.items.map((e) => toMealItem(e)).toList(),
    );
  }

  static MealItem toMealItem(MealItemDraft draft) {
    return MealItem(name: draft.controller.text, diet: draft.diet!);
  }

  static MealPlan toMealPlan({
    required int id,
    required String name,
    required String frequency,
    required int amount,
    required List<MealDraft> meals,
  }) {
    return MealPlan(
      id: id,
      name: name,
      frequency: frequency,
      amount: amount,
      selectedMeals: meals.map((e) => e.type).toList(),
      meals: meals
          .asMap()
          .entries
          .map((e) => toMeal(e.value, e.key + 1))
          .toList(),
    );
  }
}
