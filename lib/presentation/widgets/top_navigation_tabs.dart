import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';

class TopNavigationTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const TopNavigationTabs({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  static const _tabs = [
    {'label': 'Meal Plan', 'icon': AppIcons.mealPlan},
    {'label': 'Menu', 'icon': AppIcons.menu},
    {'label': 'Meal Track', 'icon': AppIcons.mealTrack},
    {'label': 'Feedback', 'icon': AppIcons.feedback},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return Row(
      children: List.generate(_tabs.length, (index) {
        final tab = _tabs[index];
        final bool selected = index == selectedIndex;

        final Color activeColor = AppColors.accentBlue;
        final Color inactiveColor = isDark ? Colors.white70 : Colors.black87;

        return Expanded(
          child: InkWell(
            onTap: () => onChanged(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),

                SvgPicture.asset(
                  tab['icon'] as String,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    selected ? activeColor : inactiveColor,
                    BlendMode.srcIn,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  tab['label'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: selected ? activeColor : inactiveColor,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 8),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 2,
                  width: selected ? 24 : 0,
                  decoration: BoxDecoration(
                    color: activeColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
