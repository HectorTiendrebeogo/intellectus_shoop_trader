import 'package:flutter/material.dart';

import 'bottom_view/dashboard.dart';
import 'bottom_view/order.dart';
import 'bottom_view/product.dart';
import 'bottom_view/profil.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  int _selectedScreen = 0;
  Widget _currentScreen = const DashboardScreen();
  final List<Widget> _screenList = [
    const DashboardScreen(),
    const ProductScreen(),
    const OrderScreen(),
    const ProfilScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentScreen,
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.black,
        unselectedLabelStyle: const TextStyle(color: Colors.black),
        currentIndex: _selectedScreen,
        elevation: 25,
        onTap: (index) {
          setState(() {
            _selectedScreen = index;
            _currentScreen = _screenList[index];
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              label: "Tableau de bord"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined),
              label: "Produits"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.payment_outlined),
              label: "Commandes"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: "Profil"
          ),
        ],
      ),
    );
  }
}
