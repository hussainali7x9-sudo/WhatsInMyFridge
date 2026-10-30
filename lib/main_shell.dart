import 'package:flutter/material.dart';
import 'common.dart';
import 'home_screen.dart';
import 'fridge_screen.dart';
import 'recipes_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(
        onMenu: () {},
        onGoTab: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        userName: 'Mighty Mam',
      ),
      const FridgeScreen(onMenu: _dummy),
      const RecipesScreen(onMenu: _dummy),
      const ProfileScreen(onMenu: _dummy),
    ];
  }

  // Dummy function taake koi error na aaye
  static void _dummy() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.tealDark,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      // Neeche wala navigation bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.tealLight,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -5),
            )
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppColors.mint,
          unselectedItemColor: AppColors.creamDim,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.kitchen_rounded), label: 'Fridge'),
            BottomNavigationBarItem(icon: Icon(Icons.soup_kitchen_rounded), label: 'Recipes'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}