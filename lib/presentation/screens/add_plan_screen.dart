import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AddPlanScreen extends StatefulWidget {
  const AddPlanScreen({super.key});

  @override
  State<AddPlanScreen> createState() => _AddPlanScreenState();
}

class _AddPlanScreenState extends State<AddPlanScreen> {
  final TextEditingController planNameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  final meals = {
    'Breakfast': false,
    'Lunch': false,
    'Snacks': false,
    'Dinner': false,
  };

  String frequency = 'Daily';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      resizeToAvoidBottomInset: true, // 🔴 IMPORTANT
      appBar: AppBar(
        backgroundColor: AppColors.bgDark,
        elevation: 0,
        leading: const BackButton(),
        title: const Text('Add Plan'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // 🔴 IMPORTANT
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('Plan name'),
              _underlineField(
                controller: planNameController,
                hint: 'Enter plan name',
              ),
              const SizedBox(height: 24),

              _label('Select meals'),
              ...meals.keys.map(_mealCheckbox).toList(),

              const SizedBox(height: 24),
              _label('Frequency'),
              _frequencyRow(),

              const SizedBox(height: 24),
              _label('Amount'),
              _underlineField(
                controller: amountController,
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

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(color: AppColors.textMutedDark, fontSize: 14),
      ),
    );
  }

  Widget _underlineField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        hintText: '',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.textMutedDark),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.accentBlue),
        ),
      ),
    );
  }

  Widget _mealCheckbox(String meal) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(meal, style: const TextStyle(color: Colors.white)),
      value: meals[meal],
      activeColor: AppColors.accentBlue,
      onChanged: (val) => setState(() => meals[meal] = val ?? false),
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }

  Widget _frequencyRow() {
    final options = ['Daily', 'Weekly', 'Monthly'];

    return Row(
      children: options.map((opt) {
        final selected = frequency == opt;

        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => frequency = opt),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: selected ? AppColors.accentBlue : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.accentBlue),
              ),
              child: Center(
                child: Text(
                  opt,
                  style: TextStyle(
                    color: selected ? Colors.white : AppColors.accentBlue,
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
        onPressed: () {},
        child: const Text(
          'Save & Continue',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
