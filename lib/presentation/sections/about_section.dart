import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/section_container.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '02. ',
                style: GoogleFonts.firaCode(
                  color: AppTheme.primaryColor,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'About Me',
                style: GoogleFonts.inter(
                  color: AppTheme.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 32.sp,
                ),
              ),
              SizedBox(width: 20.w),
              const Expanded(
                child: Divider(color: AppTheme.cardColor, thickness: 1),
              ),
            ],
          ),
          SizedBox(height: 40.h),
          _buildTextContent(),
        ],
      ),
    );
  }

  Widget _buildTextContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hello! I’m Shohan, a Flutter-focused Software Engineer who loves turning real-world problems into polished mobile experiences. My journey into mobile development started back in 2019 when I began experimenting with custom themes and small UI tweaks — those early experiments quickly grew into a deep passion for building complete apps with Dart & Flutter.",
          style: GoogleFonts.inter(
            color: AppTheme.secondaryColor,
            fontSize: 18.sp,
            height: 1.6,
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          "Fast-forward to today, I’m working as a Flutter Mobile App Developer at Genuine Technology and Research Ltd (GTR), where I’ve contributed to products like Jogajog, Halda, and Atrai. I enjoy owning features end-to-end — from shaping the UX, integrating REST APIs and Firebase, to making sure the app feels smooth and reliable in production.",
          style: GoogleFonts.inter(
            color: AppTheme.secondaryColor,
            fontSize: 18.sp,
            height: 1.6,
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          "I care a lot about clean, maintainable architecture (MVC/MVVM, proper state management) and writing code that other engineers enjoy working with. Here are some of the technologies and tools I’ve been working with recently:",
          style: GoogleFonts.inter(
            color: AppTheme.secondaryColor,
            fontSize: 18.sp,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTechList(['Flutter', 'Dart', 'Firebase']),
            SizedBox(width: 30.w),
            _buildTechList(['Kotlin', 'Swift', 'Rest API']),
          ],
        ),
      ],
    );
  }

  Widget _buildTechList(List<String> techs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: techs
          .map(
            (tech) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_right,
                    color: AppTheme.primaryColor,
                    size: 16.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    tech,
                    style: GoogleFonts.firaCode(
                      color: AppTheme.secondaryColor,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

