import 'package:flutter/material.dart';
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
          const SizedBox(height: 24),
          Text(
            'Get In Touch',
            style: GoogleFonts.inter(
              color: AppTheme.textColor,
              fontSize: 50,
              fontWeight: FontWeight.bold,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 600,
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
          const SizedBox(height: 50),
          OutlinedButton(
            onPressed: () {
              _launchURL('mailto:mshohan088@gmail.com');
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 22),
              side: const BorderSide(color: AppTheme.primaryColor, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Text(
              'Say Hello',
              style: GoogleFonts.firaCode(
                color: AppTheme.primaryColor,
                fontSize: 16,
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
