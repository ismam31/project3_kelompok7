import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;

  const BottomNavigation({
    super.key,
    required this.selectedIndex,
  });

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/dashboard');
        break;
      case 1:
        Navigator.pushNamed(context, '/list-order');
        break;
      case 2:
        Navigator.pushNamed(context, '/list-menu');
        break;
      case 3:
        Navigator.pushNamed(context, '/report');
        break;
    }
  }

  void _onFabPressed(BuildContext context) {
    Navigator.pushNamed(context, '/order');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        BottomAppBar(
          shape: const CircularNotchedRectangle(),
          color: const Color(0xFF0492C2),
          notchMargin: 8.0,
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(context, Icons.home, 0),
                _buildNavItem(context, Icons.shopping_bag, 1),
                const SizedBox(width: 40),
                _buildNavItem(context, Icons.fastfood, 2),
                _buildNavItem(context, Icons.bar_chart, 3),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          child: FloatingActionButton(
            backgroundColor: selectedIndex == -1
                ? const Color(0xFF0492C2) // nyala biru pas di /order
                : const Color.fromARGB(255, 255, 255, 255),
            onPressed: () => _onFabPressed(context),
            child: Icon(
              Icons.add,
              color: selectedIndex == -1 ? Colors.white : const Color(0xFF0492C2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, int index) {
    return IconButton(
      icon: Icon(
        icon,
        color: selectedIndex == index ? Colors.white : Colors.white70,
        size: 28,
      ),
      onPressed: () => _onItemTapped(context, index),
    );
  }
}