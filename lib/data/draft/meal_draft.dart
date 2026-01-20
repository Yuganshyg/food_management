import 'meal_item_draft.dart';

class MealDraft {
  final String type;

  String startTime;
  String endTime;

  int price;

  final List<MealItemDraft> items;

  MealDraft({
    required this.type,
    this.startTime = '',
    this.endTime = '',
    this.price = 0,
    required this.items,
  });

  bool get isValid {
    if (startTime.isEmpty || endTime.isEmpty) return false;
    if (items.isEmpty) return false;

    for (final item in items) {
      if (item.controller.text.trim().isEmpty) return false;
      if (item.diet == null) return false;
    }

    return true;
  }
}
