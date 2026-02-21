import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(int) onNavTap;

  const NavBar({super.key, required this.onNavTap});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return AppBar(
      title: Text(
        '<Shohan/>',
        style: GoogleFonts.robotoMono(
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: isMobile
          ? [
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.menu, color: AppTheme.primaryColor, size: 24.sp),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                ),
              ),
            ]
          : [
              _buildNavLink(context, '01. Skills', 1),
              _buildNavLink(context, '02. About', 2),
              _buildNavLink(context, '03. Experience', 3),
              _buildNavLink(context, '04. Work', 4),
              _buildNavLink(context, '05. Contact', 5),
              SizedBox(width: 20.w),
              OutlinedButton(
                onPressed: () {
                  // Resume download or similar action
                },
                child: const Text('Resume'),
              ),
              SizedBox(width: 20.w),
            ],
    );
  }

  Widget _buildNavLink(BuildContext context, String text, int index) {
    return TextButton(
      onPressed: () => onNavTap(index),
      child: Text(
        text,
        style: GoogleFonts.robotoMono(
          color: AppTheme.secondaryColor,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60.h);
}

class MobileDrawer extends StatelessWidget {
  final Function(int) onNavTap;

  const MobileDrawer({super.key, required this.onNavTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.cardColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDrawerLink(context, '01. Skills', 1),
            _buildDrawerLink(context, '02. About', 2),
            _buildDrawerLink(context, '03. Experience', 3),
            _buildDrawerLink(context, '04. Work', 4),
            _buildDrawerLink(context, '05. Contact', 5),
            SizedBox(height: 40.h),
            OutlinedButton(onPressed: () {}, child: const Text('Resume')),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerLink(BuildContext context, String text, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: TextButton(
        onPressed: () {
          Navigator.pop(context); // Close drawer
          onNavTap(index);
        },
        child: Text(
          text,
          style: GoogleFonts.robotoMono(
            color: AppTheme.secondaryColor,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}
