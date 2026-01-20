import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_management/presentation/screens/set_plan_screen.dart';

import '../../bloc/meal_plan/meal_plan_bloc.dart';
import '../../bloc/meal_plan/meal_plan_event.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/meal_plan_model.dart';

class AddPlanScreen extends StatefulWidget {
  const AddPlanScreen({super.key});

  @override
  State<AddPlanScreen> createState() => _AddPlanScreenState();
}

class _AddPlanScreenState extends State<AddPlanScreen> {
  final TextEditingController _planNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String _frequency = 'Weekly';

  final Map<String, bool> _mealSelection = {
    'Breakfast': false,
    'Lunch': false,
    'Snacks': false,
    'Dinner': false,
  };

  @override
  void dispose() {
    _planNameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _onSave() {
    final name = _planNameController.text.trim();
    final amountText = _amountController.text.trim();

    if (name.isEmpty || amountText.isEmpty) {
      _showError('Please fill all fields');
      return;
    }

    if (!_mealSelection.containsValue(true)) {
      _showError('Select at least one meal');
      return;
    }

    final amount = int.tryParse(amountText);
    if (amount == null) {
      _showError('Amount must be numeric');
      return;
    }

    final selectedMeals = _mealSelection.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    final plan = MealPlan.draft(
      name: name,
      frequency: _frequency,
      amount: amount,
      selectedMeals: selectedMeals,
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SetPlanScreen(draftPlan: plan)),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // 🔑 KEY FIX
      appBar: AppBar(title: const Text('Add Plan')),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.fromLTRB(
            20,
            12,
            20,
            MediaQuery.of(context).viewInsets.bottom + 20, // 🔑 keyboard space
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('Plan name'),
              _textRow(
                controller: _planNameController,
                hint: 'Enter plan name',
              ),

              const SizedBox(height: 24),
              _label('Select meals'),
              ..._mealSelection.keys.map(_mealRow).toList(),

              const SizedBox(height: 24),
              _label('Frequency'),
              _dropdownRow(),

              const SizedBox(height: 24),
              _label('Amount'),
              _textRow(
                controller: _amountController,
                hint: 'Enter amount',
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 32),
              _saveButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- UI PARTS ----------

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: AppColors.textMutedDark),
      ),
    );
  }

  Widget _textRow({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return Column(
      children: [
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(hintText: hint, border: InputBorder.none),
        ),
        const Divider(height: 1),
      ],
    );
  }

  Widget _mealRow(String meal) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(meal),
      trailing: Checkbox(
        value: _mealSelection[meal],
        onChanged: (value) {
          setState(() => _mealSelection[meal] = value ?? false);
        },
      ),
    );
  }

  Widget _dropdownRow() {
    return Column(
      children: [
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _frequency,
            isExpanded: true,
            items: [
              'Daily',
              'Weekly',
              'Monthly',
            ].map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _frequency = value);
              }
            },
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }

  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _onSave,
        child: const Text('Save & Continue'),
      ),
    );
  }
}
