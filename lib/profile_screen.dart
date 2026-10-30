import 'package:flutter/material.dart';
import 'common.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback onMenu;
  const ProfileScreen({super.key, required this.onMenu});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        dark: true,
        child: Center(
          child: Text("Profile Screen (Under Construction)", 
            style: TextStyle(color: AppColors.cream)),
        ),
      ),
    );
  }
}