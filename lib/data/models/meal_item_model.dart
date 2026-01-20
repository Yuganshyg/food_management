class MealItem {
  final String name;
  final String? diet; // 'veg' | 'nonVeg'

  MealItem({required this.name, required this.diet});

  // ---------- COPY ----------
  MealItem copyWith({String? name, String? diet}) {
    return MealItem(name: name ?? this.name, diet: diet ?? this.diet);
  }

  // ---------- JSON ----------
  factory MealItem.fromJson(Map<String, dynamic> json) {
    return MealItem(name: json['name'] as String, diet: json['diet'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'diet': diet};
  }
}
