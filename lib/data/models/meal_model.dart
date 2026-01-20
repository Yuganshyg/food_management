import 'meal_item_model.dart';

class Meal {
  final int id;
  final String type; // Breakfast, Lunch, Snacks, Dinner
  final String? startTime;
  final String? endTime;
  final List<MealItem> items;

  Meal({
    required this.id,
    required this.type,
    required this.startTime,
    required this.endTime,
    required this.items,
  });

  // ---------- COPY ----------
  Meal copyWith({
    int? id,
    String? type,
    String? startTime,
    String? endTime,
    List<MealItem>? items,
  }) {
    return Meal(
      id: id ?? this.id,
      type: type ?? this.type,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      items: items ?? this.items,
    );
  }

  // ---------- JSON ----------
  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'] as int,
      type: json['type'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      items: (json['items'] as List)
          .map((e) => MealItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'startTime': startTime,
      'endTime': endTime,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}
