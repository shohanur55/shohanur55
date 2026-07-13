import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32.h),
      color: AppTheme.backgroundColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon(
                FontAwesomeIcons.github,
                "https://github.com/shohanur55",
              ),
              SizedBox(width: 24.w),
              _buildSocialIcon(
                FontAwesomeIcons.linkedin,
                "https://www.linkedin.com/in/md-shohanur-rahaman-a56999292/",
              ),
              SizedBox(width: 24.w),
              _buildSocialIcon(
                FontAwesomeIcons.envelope,
                "mailto:mshohan088@gmail.com",
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Text(
            'Designed & Built with Flutter by Md. Shohanur Rahaman',
            style: GoogleFonts.firaCode(
              color: AppTheme.secondaryColor,
              fontSize: 14.sp.clamp(12.0, 18.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(FaIconData icon, String url) {
    return IconButton(
      onPressed: () => _launchURL(url),
      icon: FaIcon(
        icon,
        size: 20.sp.clamp(16.0, 24.0),
        color: AppTheme.secondaryColor,
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) throw 'Could not launch $url';
  }
}
