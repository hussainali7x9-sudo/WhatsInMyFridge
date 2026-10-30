import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'common.dart';
import 'data.dart';

class FridgeScreen extends StatelessWidget {
  final VoidCallback onMenu;
  const FridgeScreen({super.key, required this.onMenu});

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
                    Text("My Fridge",
                        style: GoogleFonts.poppins(
                            fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.cream)),
                  ],
                ),
              ),
              Expanded(
                child: ValueListenableBuilder<List<FridgeItem>>(
                  valueListenable: fridge,
                  builder: (context, items, _) {
                    if (items.isEmpty) {
                      return Center(
                        child: Text("Your fridge is empty",
                            style: GoogleFonts.poppins(color: AppColors.creamDim)),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                          ),
                          child: Row(
                            children: [
                              Text(item.emoji, style: const TextStyle(fontSize: 30)),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.name,
                                        style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.cream)),
                                    Text(daysLabel(item.days),
                                        style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: item.days <= 2 ? AppColors.coral : AppColors.creamDim)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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