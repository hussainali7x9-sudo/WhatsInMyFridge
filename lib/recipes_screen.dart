import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'common.dart';
import 'data.dart';

class RecipesScreen extends StatelessWidget {
  final VoidCallback onMenu;
  const RecipesScreen({super.key, required this.onMenu});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        dark: true,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu_rounded, color: AppColors.cream),
                      onPressed: onMenu,
                    ),
                    const SizedBox(width: 10),
                    Text("Recipes",
                        style: GoogleFonts.poppins(
                            fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.cream)),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(recipe.name,
                              style: GoogleFonts.poppins(
                                  fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.cream)),
                          const SizedBox(height: 8),
                          Text("Ingredients: ${recipe.ingredients.join(', ')}",
                              style: GoogleFonts.poppins(
                                  fontSize: 12, color: AppColors.creamDim, height: 1.4)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}