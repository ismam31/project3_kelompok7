import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;

  const BottomNavigation({super.key, required this.selectedIndex});

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
    return SafeArea(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BottomAppBar(
            shape: const CircularNotchedRectangle(),
            color: Colors.blue,
            notchMargin: 8.0,
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 600 ? 100 : 0,
            ),
            child: SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(context, Icons.home, 0),
                  _buildNavItem(context, Icons.shopping_bag, 1),
                  const SizedBox(width: 40),
                  _buildNavItem(context, Icons.restaurant, 2),
                  _buildNavItem(context, Icons.analytics, 3),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 25,
            child: FloatingActionButton(
              backgroundColor:
                  selectedIndex == -1 ? const Color(0xFF0492C2) : Colors.white,
              elevation: 5,
              onPressed: () => _onFabPressed(context),
              child: Icon(
                Icons.add,
                color:
                    selectedIndex == -1
                        ? Colors.white
                        : const Color(0xFF0492C2),
              ).animate().rotate(duration: 500.ms),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, int index) {
    final isSelected = selectedIndex == index;
    return SizedBox(
      width: 60, // Lebar tetap untuk tap area yang konsisten
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () => _onItemTapped(context, index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                  icon,
                  color: isSelected ? Colors.white : Colors.white70,
                  size: 28,
                )
                .animate()
                .scale(duration: 300.ms, curve: Curves.easeOut)
                .then(delay: 100.ms)
                .fadeIn(),
          ],
        ),
      ),
    );
  }
}
