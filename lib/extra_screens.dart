import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'common.dart';
import 'data.dart';
import 'login_screen.dart';

// ============================ Add Item ============================
class AddItemScreen extends StatefulWidget {
  final String initialName;
  final String initialEmoji;
  const AddItemScreen({
    super.key,
    this.initialName = '',
    this.initialEmoji = '🥕',
  });

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  static const _emojis = [
    '🥕', '🥛', '🥬', '🍅', '🍎', '🧀', '🍗', '🍞', '🥚', '🧈', '🍌'
  ];

  late final TextEditingController _name;
  late String _emoji;
  int _days = 5;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.initialName);
    _emoji = widget.initialEmoji;
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _save() {
    final name = _name.text.trim();
    final messenger = ScaffoldMessenger.of(context);
    if (name.isEmpty) {
      messenger.showSnackBar(
          const SnackBar(content: Text('Please enter an item name')));
      return;
    }
    fridge.value = [...fridge.value, FridgeItem(name, _emoji, _days)];
    Navigator.pop(context);
    messenger.showSnackBar(SnackBar(content: Text('$name added to your fridge')));
  }

  @override
  Widget build(BuildContext context) {
    return SubPage(
      title: 'Add Item',
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Item name',
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.cream)),
            const SizedBox(height: 8),
            TextField(
              controller: _name,
              cursorColor: AppColors.mint,
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.cream),
              decoration: InputDecoration(
                hintText: 'e.g. Cheese',
                hintStyle:
                    GoogleFonts.poppins(fontSize: 14, color: AppColors.creamDim),
                prefixIcon:
                    const Icon(Icons.edit_outlined, color: AppColors.mint),
                filled: true,
                fillColor: AppColors.tealLight,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 22),
            Text('Pick an icon',
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.cream)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final e in _emojis)
                  GestureDetector(
                    onTap: () => setState(() => _emoji = e),
                    child: Container(
                      width: 52,
                      height: 52,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: e == _emoji
                            ? AppColors.mint
                            : AppColors.tealLight,
                        shape: BoxShape.circle,
                      ),
                      child: Text(e, style: const TextStyle(fontSize: 26)),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 22),
            Text('Expires in',
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.cream)),
            const SizedBox(height: 10),
            AppCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline,
                        color: AppColors.mint),
                    onPressed: () =>
                        setState(() => _days = _days > 1 ? _days - 1 : 1),
                  ),
                  Text(_days == 1 ? '1 day' : '$_days days',
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.cream)),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline,
                        color: AppColors.mint),
                    onPressed: () => setState(() => _days++),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            HoverButton(label: 'Save Item', onPressed: _save),
          ],
        ),
      ),
    );
  }
}

// ============================ Scan ============================
class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SubPage(
      title: 'Camera & Scan',
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                width: 230,
                height: 230,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: AppColors.mint, width: 3),
                ),
                child: const Icon(Icons.qr_code_scanner_rounded,
                    size: 110, color: AppColors.mint),
              ),
              const SizedBox(height: 20),
              Text('Point your camera at a barcode or receipt',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: AppColors.creamDim)),
              const SizedBox(height: 24),
              HoverButton(
                label: 'Simulate scan',
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddItemScreen(
                        initialName: 'Bananas', initialEmoji: '🍌'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================ AI Chef ============================
class AiChefScreen extends StatelessWidget {
  const AiChefScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SubPage(
      title: 'AI Chef',
      child: ValueListenableBuilder<List<FridgeItem>>(
        valueListenable: fridge,
        builder: (context, items, _) {
          final expiring = items
              .where((i) => i.days <= expiringDays)
              .map((i) => i.name.toLowerCase())
              .toSet();
          final picks = recipes
              .where((r) =>
                  r.ingredients.any((i) => expiring.contains(i.toLowerCase())))
              .toList();
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.sage,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    const Text('👨‍🍳', style: TextStyle(fontSize: 34)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        picks.isEmpty
                            ? 'Nothing is expiring, so cook whatever you like!'
                            : 'I found ${picks.length} recipes that use food expiring soon.',
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.teal),
                      ),
                    ),
                  ],
                ),
              ),
              for (final r in (picks.isEmpty ? recipes : picks))
                _BuildRecipeCard(recipe: r),
            ],
          );
        },
      ),
    );
  }
}

// Naya Recipe Card
class _BuildRecipeCard extends StatelessWidget {
  final Recipe recipe;
  const _BuildRecipeCard({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.tealLight,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🍲', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(recipe.name,
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.cream)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text("Ingredients: ${recipe.ingredients.join(', ')}",
              style: GoogleFonts.poppins(
                  fontSize: 12, color: AppColors.creamDim, height: 1.4)),
        ],
      ),
    );
  }
}

// ============================ Reminders ============================
class _Reminder {
  final String title;
  final String sub;
  bool on;
  _Reminder(this.title, this.sub, this.on);
}

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  final _items = [
    _Reminder('Daily expiry check', 'Every day at 8:00 AM', true),
    _Reminder('Weekly fridge clean-up', 'Sundays at 10:00 AM', true),
    _Reminder('Shopping list reminder', 'Fridays at 5:00 PM', false),
  ];

  @override
  Widget build(BuildContext context) {
    return SubPage(
      title: 'Reminders',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
        children: [
          for (final r in _items)
            _SwitchRow(
              title: r.title,
              subtitle: r.sub,
              value: r.on,
              onChanged: (v) => setState(() => r.on = v),
            ),
        ],
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SwitchRow({
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.cream)),
                if (subtitle != null)
                  Text(subtitle!,
                      style: GoogleFonts.poppins(
                          fontSize: 11, color: AppColors.creamDim)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.mint,
          ),
        ],
      ),
    );
  }
}

// ============================ Notifications ============================
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const notes = [
      ('🥛', 'Milk expires in 2 days', 'Use it soon', '2h ago'),
      ('🥬', 'Spinach expires in 3 days', 'Try the Spinach Omelette', '5h ago'),
      ('🍅', 'Tomatoes expire in 4 days', 'Make Tomato Cheese Toast', 'Yesterday'),
    ];
    return SubPage(
      title: 'Notifications',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
        children: [
          for (final n in notes)
            AppCard(
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: AppColors.sage, shape: BoxShape.circle),
                    child: Text(n.$1, style: const TextStyle(fontSize: 22)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(n.$2,
                            style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.cream)),
                        Text(n.$3,
                            style: GoogleFonts.poppins(
                                fontSize: 11, color: AppColors.creamDim)),
                      ],
                    ),
                  ),
                  Text(n.$4,
                      style: GoogleFonts.poppins(
                          fontSize: 10, color: AppColors.creamDim)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ============================ Settings ============================
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _alerts = true;
  bool _weekly = false;

  void _about() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.tealLight,
        title: Text("What's in my Fridge",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700, color: AppColors.cream)),
        content: Text('Version 1.0.0\nLess food waste. Better meals.',
            style: GoogleFonts.poppins(color: AppColors.creamDim)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close',
                style: GoogleFonts.poppins(color: AppColors.mint)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SubPage(
      title: 'Settings',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
        children: [
          _SwitchRow(
            title: 'Expiry alerts',
            subtitle: 'Notify me before food expires',
            value: _alerts,
            onChanged: (v) => setState(() => _alerts = v),
          ),
          _SwitchRow(
            title: 'Weekly summary',
            subtitle: 'A recap every Sunday',
            value: _weekly,
            onChanged: (v) => setState(() => _weekly = v),
          ),
          InkWell(
            onTap: _about,
            borderRadius: BorderRadius.circular(24),
            child: AppCard(
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.mint),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('About',
                        style: GoogleFonts.poppins(
                            fontSize: 14, color: AppColors.cream)),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.creamDim),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            ),
            borderRadius: BorderRadius.circular(24),
            child: AppCard(
              child: Row(
                children: [
                  const Icon(Icons.logout_rounded, color: AppColors.coral),
                  const SizedBox(width: 12),
                  Text('Log Out',
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: AppColors.coral)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================ Help & Support ============================
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const faqs = [
      ('How do I add an item?',
          'Tap Add Item on the Home screen, or the + button on the Fridge tab.'),
      ('What does "Expiring soon" mean?',
          'Anything that expires within 4 days is shown as expiring soon.'),
      ('What does "Use it" do?',
          'It marks the item as used and removes it from your fridge.'),
      ('How does AI Chef pick recipes?',
          'It suggests recipes that use the food that is about to expire.'),
    ];
    return SubPage(
      title: 'Help & Support',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
        children: [
          for (final f in faqs)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: AppColors.tealLight,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  iconColor: AppColors.mint,
                  collapsedIconColor: AppColors.creamDim,
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  title: Text(f.$1,
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.cream)),
                  children: [
                    Text(f.$2,
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            height: 1.4,
                            color: AppColors.creamDim)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}