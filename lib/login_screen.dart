import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'common.dart';
import 'main_shell.dart'; // MainShell import kiya
import 'signup_screen.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();

  void _goHome() {
    String name = _nameController.text.trim();
    if (name.isEmpty) name = 'Mighty Mam'; 

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const MainShell(), // Login ke baad MainShell
      ),
      (route) => false, // History clear
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        image: 'assets/login_bg.jpeg', 
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
            child: Column(
              children: [
                const FridgeLogo(size: 70),
                const SizedBox(height: 8),
                Text("What's in my Fridge", style: GoogleFonts.sacramento(fontSize: 42, color: AppColors.cream, height: 1.0)),
                const SizedBox(height: 4),
                Text('Less food waste. Better meals.', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.creamDim)),
                const SizedBox(height: 40),
                
                AuthField(
                  hint: 'Full Name', 
                  icon: Icons.person_outline,
                  controller: _nameController,
                ),
                const SizedBox(height: 10),
                const AuthField(hint: 'Email or Username', icon: Icons.mail_outline), 
                const SizedBox(height: 10),
                const AuthField(hint: 'Password', icon: Icons.lock_outline),
                const SizedBox(height: 24),
                
                HoverButton(
                  label: 'Login',
                  onPressed: _goHome,
                ),
                
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ", style: GoogleFonts.poppins(fontSize: 13, color: AppColors.creamDim)),
                    HoverTextLink(
                      text: 'Sign Up',
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen()));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}