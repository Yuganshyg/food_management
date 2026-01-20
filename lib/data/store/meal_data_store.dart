import '../models/meal_plan_model.dart';

/// In-memory data store
/// Acts like a backend database during app runtime
class MealDataStore {
  /// Singleton instance
  MealDataStore._internal();
  static final MealDataStore _instance = MealDataStore._internal();
  factory MealDataStore() => _instance;

  /// Internal storage
  final List<MealPlan> _mealPlans = [];

  /// Initialize store with JSON data (called once)
  void initialize(List<MealPlan> plans) {
    _mealPlans
      ..clear()
      ..addAll(plans);
  }

  /// Read all meal plans
  List<MealPlan> getMealPlans() {
    return List.unmodifiable(_mealPlans);
  }

  /// Add a new meal plan
  void addMealPlan(MealPlan plan) {
    _mealPlans.add(plan);
  }

  /// Update existing meal plan
  void updateMealPlan(MealPlan updatedPlan) {
    final index = _mealPlans.indexWhere((plan) => plan.id == updatedPlan.id);

    if (index != -1) {
      _mealPlans[index] = updatedPlan;
    }
  }

  /// Get next plan ID (simulates auto-increment DB)
  int getNextPlanId() {
    if (_mealPlans.isEmpty) return 1;
    return _mealPlans.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
  }
}
