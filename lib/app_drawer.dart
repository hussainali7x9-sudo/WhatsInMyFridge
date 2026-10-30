import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'common.dart';
import 'extra_screens.dart';
import 'login_screen.dart';

class _Entry {
  final IconData icon;
  final String label;
  final int? tab; // switches a bottom tab
  final Widget Function()? page; // or opens a page
  _Entry(this.icon, this.label, {this.tab, this.page});
}

class AppDrawer extends StatelessWidget {
  final int currentTab;
  final ValueChanged<int> onSelectTab;
  const AppDrawer({
    super.key,
    required this.currentTab,
    required this.onSelectTab,
  });

  @override
  Widget build(BuildContext context) {
    final entries = <_Entry>[
      _Entry(Icons.home_rounded, 'Home', tab: 0),
      _Entry(Icons.kitchen_outlined, 'My Fridge', tab: 1),
      _Entry(Icons.soup_kitchen_outlined, 'Recipes', tab: 2),
      _Entry(Icons.auto_awesome_outlined, 'AI Chef',
          page: () => const AiChefScreen()),
      _Entry(Icons.photo_camera_outlined, 'Camera & Scan',
          page: () => const ScanScreen()),
      _Entry(Icons.notifications_none_rounded, 'Reminders',
          page: () => const RemindersScreen()),
      _Entry(Icons.settings_outlined, 'Settings',
          page: () => const SettingsScreen()),
      _Entry(Icons.help_outline_rounded, 'Help & Support',
          page: () => const HelpScreen()),
    ];

    return Drawer(
      backgroundColor: AppColors.tealDark,
      shape: const RoundedRectangleBorder(),
      child: Column(
        children: [
          // ---------- header ----------
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
                18, MediaQuery.of(context).padding.top + 10, 18, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.pink, AppColors.orange],
              ),
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(40)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child:
                        const Icon(Icons.close, size: 22, color: AppColors.teal),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: const BoxDecoration(
                          color: AppColors.teal, shape: BoxShape.circle),
                      child: const Icon(Icons.kitchen_rounded,
                          color: AppColors.mint, size: 30),
                    ),
                    const SizedBox(width: 12),
                    Text("What's in my\nFridge",
                        style: GoogleFonts.sacramento(
                            fontSize: 28, color: AppColors.teal, height: 0.95)),
                  ],
                ),
                const SizedBox(height: 20),
                // Tapping the profile row opens the Profile tab.
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    onSelectTab(3);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColors.sage,
                        child: Icon(Icons.person, color: AppColors.teal),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Respected Mighty and Humble Mam',
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.teal)),
                            Text('',
                                style: GoogleFonts.poppins(
                                    fontSize: 11, color: AppColors.teal)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ---------- menu ----------
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: entries.length,
              itemBuilder: (context, i) {
                final e = entries[i];
                final active = e.tab != null && e.tab == currentTab;
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    color: active ? AppColors.mint : Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    leading: Icon(e.icon,
                        color: active ? AppColors.teal : AppColors.cream),
                    title: Text(e.label,
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight:
                                active ? FontWeight.w600 : FontWeight.w500,
                            color: active ? AppColors.teal : AppColors.cream)),
                    onTap: () {
                      final nav = Navigator.of(context);
                      nav.pop(); // close the drawer first
                      if (e.tab != null) {
                        // Agar tab hai toh onSelectTab call karo
                        onSelectTab(e.tab!);
                      } else {
                        // Agar page hai toh us page par jao
                        nav.push(MaterialPageRoute(builder: (_) => e.page!()));
                      }
                    },
                  ),
                );
              },
            ),
          ),

          // ---------- log out ----------
          const Divider(indent: 20, endIndent: 20, color: Color(0x33F6E9DA)),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 28),
            leading: const Icon(Icons.logout_rounded, color: AppColors.coral),
            title: Text('Log Out',
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.coral)),
            onTap: () {
              final nav = Navigator.of(context);
              nav.pop();
              nav.pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}