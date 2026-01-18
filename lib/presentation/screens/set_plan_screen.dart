import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class SetPlanScreen extends StatefulWidget {
  const SetPlanScreen({super.key});

  @override
  State<SetPlanScreen> createState() => _SetPlanScreenState();
}

class _SetPlanScreenState extends State<SetPlanScreen> {
  String selectedMeal = 'Breakfast';
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  final List<_Dish> dishes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: AppColors.bgDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Set Plan'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _mealSelector(),
              const SizedBox(height: 24),

              _timeRow(),
              const SizedBox(height: 24),

              _sectionTitle('Dishes'),
              const SizedBox(height: 8),

              Expanded(child: _dishList()),

              _addDishButton(),
              const SizedBox(height: 16),

              _saveButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- UI ----------------

  Widget _mealSelector() {
    final meals = ['Breakfast', 'Lunch', 'Snacks', 'Dinner'];

    return Row(
      children: meals.map((meal) {
        final isSelected = selectedMeal == meal;

        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => selectedMeal = meal),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accentBlue : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.accentBlue),
              ),
              child: Center(
                child: Text(
                  meal,
                  style: TextStyle(
                    fontSize: 13,
                    color: isSelected ? Colors.white : AppColors.accentBlue,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _timeRow() {
    return Row(
      children: [
        Expanded(
          child: _timePicker(
            label: 'Start Time',
            time: startTime,
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (picked != null) setState(() => startTime = picked);
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _timePicker(
            label: 'End Time',
            time: endTime,
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (picked != null) setState(() => endTime = picked);
            },
          ),
        ),
      ],
    );
  }

  Widget _timePicker({
    required String label,
    required TimeOfDay? time,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(label),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.textMutedDark),
              ),
            ),
            child: Text(
              time == null ? '--:--' : time.format(context),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(color: AppColors.textMutedDark, fontSize: 14),
    );
  }

  Widget _dishList() {
    if (dishes.isEmpty) {
      return const Center(
        child: Text(
          'No dishes added',
          style: TextStyle(color: AppColors.textMutedDark),
        ),
      );
    }

    return ListView.builder(
      itemCount: dishes.length,
      itemBuilder: (_, index) {
        final dish = dishes[index];

        return ListTile(
          title: Text(dish.name, style: const TextStyle(color: Colors.white)),
          trailing: Switch(
            value: dish.isVeg,
            activeColor: AppColors.accentBlue,
            onChanged: (value) {
              setState(() => dish.isVeg = value);
            },
          ),
        );
      },
    );
  }

  Widget _addDishButton() {
    return TextButton.icon(
      onPressed: _addDishDialog,
      icon: const Icon(Icons.add, color: AppColors.accentBlue),
      label: const Text(
        'Add Dish',
        style: TextStyle(color: AppColors.accentBlue),
      ),
    );
  }

  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        onPressed: _onSave,
        child: const Text(
          'Save',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // ---------------- LOGIC ----------------

  void _addDishDialog() {
    final controller = TextEditingController();
    bool isVeg = true;

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: AppColors.bgDark,
          title: const Text('Add Dish', style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Dish name',
              hintStyle: TextStyle(color: AppColors.textMutedDark),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    dishes.add(_Dish(name: controller.text, isVeg: isVeg));
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _onSave() {
    if (startTime == null || endTime == null || dishes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    debugPrint('Meal: $selectedMeal');
    debugPrint('Start: ${startTime!.format(context)}');
    debugPrint('End: ${endTime!.format(context)}');
    debugPrint('Dishes: ${dishes.map((e) => e.name).toList()}');

    Navigator.pop(context);
  }
}

// ---------------- MODEL ----------------

class _Dish {
  final String name;
  bool isVeg;

  _Dish({required this.name, required this.isVeg});
}
