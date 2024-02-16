import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:social_movie_app/constants/color.dart';

class BottomNavBar extends StatelessWidget {
  final int pageIndex;
  final ValueChanged<int> onPageChanged;

  const BottomNavBar({
    required this.pageIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: 0,
      height: 60.0,
      items: <Widget>[
        Icon(Icons.home, size: 30, color: Colors.white),
        Icon(Icons.brightness_low, size: 30, color: Colors.white),
        Icon(Icons.group, size: 30, color: Colors.white),
        Icon(Icons.person, size: 30, color: Colors.white),
      ],
      backgroundColor: Colors.transparent,
      color: AppColors.red,
      buttonBackgroundColor: AppColors.red,
      animationCurve: Curves.easeInOut,
      animationDuration: Duration(milliseconds: 500),
      onTap: onPageChanged,
      letIndexChange: (index) => true,
    );
  }
}
