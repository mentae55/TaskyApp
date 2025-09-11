import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final ThemeData theme;
  final bool isDark;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.theme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDark ? Color(0xFF181818) : Colors.white;
    final selectedColor = theme.primaryColor;
    final unselectedColor = isDark
        ? const Color(0xFFC6C6C6)
        : const Color(0xFF3A4640);

    return BottomNavigationBar(
      backgroundColor: backgroundColor,
      selectedItemColor: selectedColor,
      unselectedItemColor: unselectedColor,
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/images/home.svg',
            color: currentIndex == 0 ? selectedColor : unselectedColor,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/images/todo.svg',
            color: currentIndex == 1 ? selectedColor : unselectedColor,
          ),
          label: 'To Do',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/images/completed.svg',
            color: currentIndex == 2 ? selectedColor : unselectedColor,
          ),
          label: 'Completed',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/images/profile.svg',
            color: currentIndex == 3 ? selectedColor : unselectedColor,
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}
