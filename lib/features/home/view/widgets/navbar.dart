import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCupertinoNavigationBar extends StatelessWidget {
  final ValueChanged<int> onDestinationSelected;
  final int selectedIndex;

  const CustomCupertinoNavigationBar({
    super.key,
    required this.onDestinationSelected,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTabBar(
      activeColor: Colors.deepPurple.shade800,
      backgroundColor: Colors.transparent,
      height: 60,
      currentIndex: selectedIndex,
      onTap: onDestinationSelected,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.home),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.search),
          label: '',
        ),
      ],
    );
  }
}
