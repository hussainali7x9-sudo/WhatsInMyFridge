import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'common.dart';
import 'home_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        image: 'assets/signup_bg.jpeg',
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
            child: Column(
              children: [
                // Circle is transparent
                const BrandCircle(
                  brandColor: Colors.transparent, 
                  subtitle: 'Create your account and\nstart managing your fridge.',
                ),
                const SizedBox(height: 20),
                
                const AuthField(hint: 'Full Name', icon: Icons.person_outline),
                const SizedBox(height: 10),
                const AuthField(hint: 'Email', icon: Icons.mail_outline),
                const SizedBox(height: 10),
                const AuthField(hint: 'Password', icon: Icons.lock_outline, isPassword: true),
                // Confirm Password wali line hata di hai
                const SizedBox(height: 20),
                
                HoverButton(
                  label: 'Sign Up',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => HomeScreen(onMenu: () {}, onGoTab: (index) {})),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ", style: GoogleFonts.poppins(fontSize: 13, color: AppColors.creamDim)),
                    HoverTextLink(
                      text: 'Login',
                      onTap: () => Navigator.pop(context),
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