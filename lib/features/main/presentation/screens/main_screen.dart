import 'package:flutter/material.dart';
import 'package:restaurant_app/core/common_ui/widgets/custom_bottom_nav_bar.dart';
import 'package:restaurant_app/features/account/presentation/screens/account_screen.dart';
import 'package:restaurant_app/features/cart/presentation/screens/cart_screen.dart';
import 'package:restaurant_app/features/home/presentation/screens/home_screen.dart';
import 'package:restaurant_app/features/orders/presentation/screens/orders_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    CartScreen(),
    OrdersScreen(),
    AccountScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
