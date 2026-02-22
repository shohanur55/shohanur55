import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/section_container.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      child: Column(
        children: [
          Text(
            '05. What’s Next?',
            style: GoogleFonts.firaCode(
              color: AppTheme.primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Get In Touch',
            style: GoogleFonts.inter(
              color: AppTheme.textColor,
              fontSize: 50.sp.clamp(32.0, 60.0),
              fontWeight: FontWeight.bold,
              letterSpacing: -1.0,
            ),
          ),
          SizedBox(height: 24.h),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Text(
              'Although I’m not currently looking for any new opportunities, my inbox is always open. Whether you have a question or just want to say hi, I’ll try my best to get back to you!',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: AppTheme.secondaryColor,
                fontSize: 18,
                height: 1.6,
              ),
            ),
          ),
          SizedBox(height: 50.h),
          OutlinedButton(
            onPressed: () {
              _launchURL('mailto:mshohan088@gmail.com');
            },
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 22.h),
              side: const BorderSide(color: AppTheme.primaryColor, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            child: Text(
              'Say Hello',
              style: GoogleFonts.firaCode(
                color: AppTheme.primaryColor,
                fontSize: 16.sp.clamp(14.0, 20.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) throw 'Could not launch $url';
  }
}
