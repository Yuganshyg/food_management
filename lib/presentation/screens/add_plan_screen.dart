import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AddPlanScreen extends StatefulWidget {
  const AddPlanScreen({super.key});

  @override
  State<AddPlanScreen> createState() => _AddPlanScreenState();
}

class _AddPlanScreenState extends State<AddPlanScreen> {
  final TextEditingController _planNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final Map<String, bool> _meals = {
    'Breakfast': false,
    'Lunch': false,
    'Snacks': false,
    'Dinner': false,
  };

  String _frequency = 'Daily';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: AppColors.bgDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Add Plan'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Plan name'),
              _underlineInput(
                controller: _planNameController,
                hint: 'Enter plan name',
              ),

              const SizedBox(height: 24),

              _sectionTitle('Select meals'),
              ..._meals.keys.map(_mealRow).toList(),

              const SizedBox(height: 24),

              _sectionTitle('Frequency'),
              _frequencySelector(),

              const SizedBox(height: 24),

              _sectionTitle('Amount'),
              _underlineInput(
                controller: _amountController,
                hint: 'Enter amount',
                keyboardType: TextInputType.number,
              ),

              const Spacer(),

              _saveButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- UI COMPONENTS ----------------

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(color: AppColors.textMutedDark, fontSize: 14),
      ),
    );
  }

  Widget _underlineInput({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textMutedDark),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.textMutedDark),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.accentBlue),
        ),
      ),
    );
  }

  Widget _mealRow(String meal) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(meal, style: const TextStyle(color: Colors.white)),
      value: _meals[meal],
      activeColor: AppColors.accentBlue,
      onChanged: (value) {
        setState(() {
          _meals[meal] = value ?? false;
        });
      },
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }

  Widget _frequencySelector() {
    final options = ['Daily', 'Weekly', 'Monthly'];

    return Row(
      children: options.map((option) {
        final isSelected = _frequency == option;

        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _frequency = option),
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
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.accentBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
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
          'Save & Continue',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // ---------------- LOGIC ----------------

  void _onSave() {
    if (_planNameController.text.isEmpty ||
        _amountController.text.isEmpty ||
        !_meals.containsValue(true)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    // STEP 6: Navigate to Set Plan Screen
    // Navigator.push(...)

    debugPrint('Plan Name: ${_planNameController.text}');
    debugPrint('Meals: $_meals');
    debugPrint('Frequency: $_frequency');
    debugPrint('Amount: ${_amountController.text}');
  }
}
