import 'meal_item_model.dart';

class Meal {
  final int id;
  final String type;
  final String startTime;
  final String endTime;
  final List<MealItem> items;

  Meal({
    required this.id,
    required this.type,
    required this.startTime,
    required this.endTime,
    required this.items,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      type: json['type'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      items: (json['items'] as List).map((e) => MealItem.fromJson(e)).toList(),
    );
  }
}
