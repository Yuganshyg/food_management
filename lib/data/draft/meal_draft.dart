import 'package:food_management/data/draft/meal_item_draft.dart';

class MealDraft {
  final String type;
  String? startTime;
  String? endTime;
  final List<MealItemDraft> items;

  MealDraft({
    required this.type,
    this.startTime,
    this.endTime,
    required this.items,
  });

  bool get hasValidTime => startTime != null && endTime != null;

  bool get hasValidItems => items.any((item) => item.isValid);

  bool get isValid => hasValidTime && hasValidItems;
}
