import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const tealDark = Color(0xFF284550);
  static const teal = Color(0xFF2F4F55);
  static const tealLight = Color(0xFF3A5F66);
  static const pink = Color(0xFFE3A1A8);
  static const orange = Color(0xFFDE7F55);
  static const sage = Color(0xFF8DC4A0);
  static const mint = Color(0xFF7FD8C3);
  static const gold = Color(0xFFE8B84A);
  static const cream = Color(0xFFF6E9DA);
  static const creamDim = Color(0xB3F6E9DA);
  static const coral = Color(0xFFFF8A6B);
}

class AppBackground extends StatelessWidget {
  final Widget child;
  final bool dark;
  final String? image;
  const AppBackground({super.key, required this.child, this.dark = false, this.image});

  static Widget _circle(double s, Color c) => Container(
        width: s, height: s,
        decoration: BoxDecoration(color: c, shape: BoxShape.circle),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, height: double.infinity,
      decoration: BoxDecoration(
        color: dark ? AppColors.tealDark : null,
        gradient: (dark || image != null) ? null : const LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [AppColors.pink, AppColors.orange],
              ),
      ),
      child: Stack(
        children: [
          if (image != null) ...[
            Positioned.fill(child: Image.asset(image!, fit: BoxFit.cover)),
            Positioned.fill(child: Container(color: const Color(0x26000000))),
          ] else if (dark) ...[
            Positioned(left: -150, top: 320, child: _circle(300, const Color(0x338DC4A0))),
            Positioned(right: -140, bottom: -120, child: _circle(340, const Color(0x44DE7F55))),
          ] else
            Positioned(right: -130, top: 300, child: _circle(260, const Color(0x338DC4A0))),
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}

class FridgeLogo extends StatelessWidget {
  final double size;
  const FridgeLogo({super.key, this.size = 80});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 1.8, height: size * 1.1,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size * 0.85, height: size * 1.1,
            decoration: BoxDecoration(
              color: AppColors.sage,
              borderRadius: BorderRadius.circular(size * 0.2),
              border: Border.all(color: AppColors.mint, width: 3),
            ),
            child: Icon(Icons.kitchen_rounded, size: size * 0.6, color: AppColors.teal),
          ),
          Positioned(left: size * 0.1, top: 2, child: const Icon(Icons.flare_rounded, color: AppColors.gold, size: 20)),
          Positioned(right: size * 0.1, top: 2, child: const Icon(Icons.flare_rounded, color: AppColors.gold, size: 20)),
        ],
      ),
    );
  }
}

class BrandCircle extends StatelessWidget {
  final String subtitle;
  final double size;
  final Color brandColor;

  const BrandCircle({
    super.key,
    required this.subtitle,
    this.size = 290,
    this.brandColor = AppColors.teal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      padding: EdgeInsets.all(size * 0.12),
      decoration: BoxDecoration(
        color: brandColor,
        shape: BoxShape.circle,
        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 24, offset: Offset(0, 10))],
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FridgeLogo(size: size * 0.27),
            const SizedBox(height: 8),
            Text("What's in my Fridge", textAlign: TextAlign.center,
                style: GoogleFonts.sacramento(fontSize: size * 0.13, color: AppColors.cream, height: 1.0)),
            const SizedBox(height: 6),
            Text(subtitle, textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 11.5, color: AppColors.creamDim)),
          ],
        ),
      ),
    );
  }
}

class AuthField extends StatefulWidget {
  final String hint;
  final IconData icon;
  final bool isPassword;
  final TextEditingController? controller; // <-- YE ADD KIYA HAI

  const AuthField({
    super.key,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.controller, // <-- YE ADD KIYA HAI
  });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color c) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: c, width: 1.5),
        );
    return TextField(
      controller: widget.controller, // <-- YE ADD KIYA HAI
      obscureText: widget.isPassword && _obscure,
      cursorColor: AppColors.mint,
      style: GoogleFonts.poppins(fontSize: 14, color: AppColors.cream),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: GoogleFonts.poppins(fontSize: 14, color: AppColors.creamDim),
        prefixIcon: Icon(widget.icon, color: AppColors.mint, size: 20),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20, color: AppColors.creamDim),
                onPressed: () => setState(() => _obscure = !_obscure),
              )
            : null,
        filled: true,
        fillColor: const Color(0xE62F4F55),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        enabledBorder: border(Colors.transparent),
        focusedBorder: border(AppColors.mint),
      ),
    );
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.cream)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text('OR', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.cream)),
        ),
        const Expanded(child: Divider(color: AppColors.cream)),
      ],
    );
  }
}

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, height: 52,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.cream,
          side: const BorderSide(color: AppColors.teal, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('G', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.teal)),
            const SizedBox(width: 10),
            Text('Continue with Google', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.teal)),
          ],
        ),
      ),
    );
  }
}

class GradientHeader extends StatelessWidget {
  final Widget child;
  const GradientHeader({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 10, 16, 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.pink, AppColors.orange]),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [BoxShadow(color: Color(0x44000000), blurRadius: 16, offset: Offset(0, 6))],
      ),
      child: child,
    );
  }
}

class PageHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onLeading;
  final Widget? trailing;
  const PageHeader({super.key, required this.title, required this.icon, required this.onLeading, this.trailing});
  @override
  Widget build(BuildContext context) {
    return GradientHeader(
      child: Row(
        children: [
          IconButton(icon: Icon(icon, color: AppColors.teal), onPressed: onLeading),
          const SizedBox(width: 4),
          Expanded(child: Text(title, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.teal))),
          ?trailing,
        ],
      ),
    );
  }
}

class SubPage extends StatelessWidget {
  final String title;
  final Widget child;
  const SubPage({super.key, required this.title, required this.child});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tealDark,
      body: AppBackground(
        dark: true,
        child: Column(
          children: [
            PageHeader(title: title, icon: Icons.arrow_back_rounded, onLeading: () => Navigator.pop(context)),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets margin;
  const AppCard({super.key, required this.child, this.margin = const EdgeInsets.only(bottom: 10)});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin, padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.tealLight, borderRadius: BorderRadius.circular(24)),
      child: child,
    );
  }
}

// ================= HOVER WIDGETS =================

class HoverButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  const HoverButton({super.key, required this.label, required this.onPressed});

  @override
  State<HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity, height: 52,
        transform: Matrix4.identity()..scale(_isHovered ? 1.03 : 1.0),
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isHovered ? AppColors.cream : AppColors.mint,
            foregroundColor: AppColors.teal,
            elevation: _isHovered ? 8 : 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: Text(widget.label, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}

class HoverTextLink extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final double fontSize; 
  
  const HoverTextLink({
    super.key, 
    required this.text, 
    required this.onTap,
    this.fontSize = 13, 
  });

  @override
  State<HoverTextLink> createState() => _HoverTextLinkState();
}

class _HoverTextLinkState extends State<HoverTextLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          style: GoogleFonts.poppins(
            fontSize: widget.fontSize, 
            fontWeight: FontWeight.w600,
            color: _isHovered ? AppColors.gold : AppColors.mint,
            decoration: _isHovered ? TextDecoration.underline : TextDecoration.none,
          ),
          child: Text(widget.text),
        ),
      ),
    );
  }
}