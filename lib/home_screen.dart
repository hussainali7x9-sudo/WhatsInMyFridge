import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'common.dart';
import 'data.dart';
import 'extra_screens.dart';
import 'app_drawer.dart'; // Drawer import

class HomeScreen extends StatefulWidget {
  final VoidCallback onMenu;
  final ValueChanged<int> onGoTab;
  final String userName;
  
  const HomeScreen({
    super.key, 
    required this.onMenu, 
    required this.onGoTab, 
    this.userName = 'User'
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _push(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  void _use(BuildContext context, FridgeItem item) {
    fridge.value = fridge.value.where((i) => i != item).toList();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} marked as used', style: GoogleFonts.poppins()),
        backgroundColor: AppColors.tealLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold yahan add kiya hai taake drawer kaam kare
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      
      // DRAWER
      drawer: AppDrawer(
        currentTab: 0,
        onSelectTab: (index) {
          widget.onGoTab(index);
          Navigator.pop(context);
        },
      ),
      
      body: Material(
        color: Colors.transparent,
        child: AppBackground(
          dark: true,
          child: Stack(
            children: [
              Positioned(
                top: -50,
                right: -50,
                child: _AnimatedOrb(color: AppColors.sage.withOpacity(0.2), size: 200),
              ),
              Positioned(
                bottom: -50,
                left: -50,
                child: _AnimatedOrb(color: AppColors.orange.withOpacity(0.15), size: 250),
              ),
              SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    _buildHeader(context),
                    Expanded(
                      child: ValueListenableBuilder<List<FridgeItem>>(
                        valueListenable: fridge,
                        builder: (context, items, _) {
                          final expiring = items
                              .where((i) => i.days <= expiringDays)
                              .toList()
                            ..sort((a, b) => a.days.compareTo(b.days));
                          return ListView(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                            physics: const BouncingScrollPhysics(),
                            children: [
                              _buildBanner(context),
                              const SizedBox(height: 24),
                              _buildQuickActions(context),
                              const SizedBox(height: 26),
                              _sectionTitle('Fridge Overview', () => widget.onGoTab(1)),
                              const SizedBox(height: 12),
                              _buildOverview(items.length, expiring.length),
                              const SizedBox(height: 26),
                              _sectionTitle('Items Expiring Soon', () => widget.onGoTab(1)),
                              const SizedBox(height: 12),
                              if (expiring.isEmpty)
                                _buildEmptyState()
                              else
                                ...expiring
                                    .take(3)
                                    .map((i) => _buildExpiringTile(context, i)),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        children: [
          Row(
            children: [
              _HoverScale(
                scale: 1.1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.menu_rounded, color: AppColors.cream),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(), // Ye drawer kholega
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_getGreeting(), 
                        style: GoogleFonts.poppins(
                            fontSize: 13, color: AppColors.creamDim, height: 1.2)),
                    Text('${widget.userName} 👋',
                        style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.cream,
                            height: 1.2)),
                  ],
                ),
              ),
              _HoverScale(
                scale: 1.1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.notifications_none_rounded, color: AppColors.cream),
                    onPressed: () => _push(context, const NotificationsScreen()),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: AppColors.mint.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))
              ],
            ),
            child: TextField(
              onSubmitted: (_) => widget.onGoTab(2),
              textInputAction: TextInputAction.search,
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.cream),
              decoration: InputDecoration(
                hintText: 'Search ingredients, recipes...',
                hintStyle: GoogleFonts.poppins(fontSize: 14, color: AppColors.creamDim.withOpacity(0.5)),
                prefixIcon: const Icon(Icons.search, color: AppColors.mint),
                filled: true,
                fillColor: Colors.white.withOpacity(0.08),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: AppColors.mint, width: 1.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    return _HoverScale(
      scale: 1.02,
      child: InkWell(
        onTap: () => _push(context, const RemindersScreen()),
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF8DC4A0), Color(0xFF5F9E73)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.sage.withOpacity(0.3),
                blurRadius: 25,
                offset: const Offset(0, 15),
              )
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)
                  ],
                ),
                child: const Text('🥗', style: TextStyle(fontSize: 34)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Chill, it's sorted!",
                        style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                    Text("We'll remind you before anything expires.",
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.white.withOpacity(0.9), height: 1.4)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = <(IconData, String, List<Color>, VoidCallback)>[
      (Icons.add_a_photo_outlined, 'Add Item', [const Color(0xFF7FD8C3), const Color(0xFF4FB09B)], () => _push(context, const AddItemScreen())),
      (Icons.document_scanner_outlined, 'Scan', [const Color(0xFFE3A1A8), const Color(0xFFC26871)], () => _push(context, const ScanScreen())),
      (Icons.soup_kitchen_outlined, 'Recipes', [const Color(0xFFE8B84A), const Color(0xFFB88A2E)], () => widget.onGoTab(2)),
      (Icons.auto_awesome, 'AI Chef', [const Color(0xFF8DC4A0), const Color(0xFF5F9E73)], () => _push(context, const AiChefScreen())),
    ];
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions.map((a) {
        final (icon, label, colors, onTap) = a;
        return _HoverScale(
          scale: 1.1,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Column(
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: colors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colors.last.withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(height: 10),
                Text(label,
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.cream)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _sectionTitle(String title, VoidCallback onViewAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.cream)),
        HoverTextLink(
          text: 'View All',
          onTap: onViewAll,
          fontSize: 13,
        ),
      ],
    );
  }

  Widget _buildOverview(int total, int expiring) {
    Widget card({
      required IconData icon,
      required List<Color> iconGradient,
      required String label,
      required String value,
      required Color valueColor,
    }) {
      return Expanded(
        child: _HoverScale(
          scale: 1.04,
          child: GestureDetector(
            onTap: () => widget.onGoTab(1),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
                ]
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: iconGradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: AppColors.creamDim)),
                      Text(value,
                          style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: valueColor,
                              height: 1.1)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        card(
          icon: Icons.kitchen_rounded,
          iconGradient: [AppColors.mint, AppColors.teal],
          label: 'Total Items',
          value: '$total',
          valueColor: AppColors.cream,
        ),
        const SizedBox(width: 14),
        card(
          icon: Icons.warning_amber_rounded,
          iconGradient: [AppColors.coral, AppColors.orange],
          label: 'Expiring Soon',
          value: '$expiring',
          valueColor: AppColors.coral,
        ),
      ],
    );
  }

  Widget _buildExpiringTile(BuildContext context, FridgeItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _HoverScale(
        scale: 1.02,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => widget.onGoTab(1),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 55,
                      height: 55,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.sage.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Text(item.emoji, style: const TextStyle(fontSize: 28)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name,
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.cream)),
                          const SizedBox(height: 2),
                          Text(daysLabel(item.days),
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: item.days <= 2
                                      ? AppColors.coral
                                      : AppColors.creamDim)),
                        ],
                      ),
                    ),
                    _HoverScale(
                      scale: 1.08,
                      child: InkWell(
                        onTap: () => _use(context, item),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.mint, Color(0xFF4FB09B)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(color: AppColors.mint.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))
                            ]
                          ),
                          child: Text('Use it',
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.teal)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right, color: AppColors.creamDim, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Column(
          children: [
            const Text('🎉', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 10),
            Text('Nothing is expiring soon',
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.cream)),
            Text('You are doing great!',
                style: GoogleFonts.poppins(fontSize: 12, color: AppColors.creamDim)),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// HELPER WIDGETS FOR ANIMATIONS
// ==========================================

class _HoverScale extends StatefulWidget {
  final Widget child;
  final double scale;
  const _HoverScale({required this.child, this.scale = 1.05});

  @override
  State<_HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<_HoverScale> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? widget.scale : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}

// Background mein floating circles ke liye animation
class _AnimatedOrb extends StatefulWidget {
  final Color color;
  final double size;
  const _AnimatedOrb({required this.color, required this.size});

  @override
  State<_AnimatedOrb> createState() => _AnimatedOrbState();
}

class _AnimatedOrbState extends State<_AnimatedOrb> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 20).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: widget.color, blurRadius: 50, spreadRadius: 20)
              ]
            ),
          ),
        );
      },
    );
  }
}