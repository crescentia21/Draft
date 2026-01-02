import 'package:flutter/material.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
  });

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/products');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/ai');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/appointments_menu');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/orderhistory');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
      onTap: (index) => _onTap(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.store),
          label: 'Products',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.auto_awesome),
          label: 'AI',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'Appointments',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_shipping),
          label: 'Orders',
        ),
      ],
    );
  }
}
