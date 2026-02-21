import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/section_container.dart';
import '../../data/repositories/portfolio_repository.dart';
import '../../data/models/experience_model.dart';

class ExperienceSection extends StatefulWidget {
  const ExperienceSection({super.key});

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  final PortfolioRepository _repository = PortfolioRepository();
  late Future<List<ExperienceModel>> _experienceFuture;

  @override
  void initState() {
    super.initState();
    _experienceFuture = _repository.getExperience();
  }

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '03. ',
                style: GoogleFonts.firaCode(
                  color: AppTheme.primaryColor,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'Where I’ve Worked',
                style: GoogleFonts.inter(
                  color: AppTheme.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 32.sp,
                ),
              ),
              const SizedBox(width: 20),
              const Expanded(
                child: Divider(color: AppTheme.cardColor, thickness: 1),
              ),
            ],
          ),
          SizedBox(height: 40.h),
          FutureBuilder<List<ExperienceModel>>(
            future: _experienceFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Failed to load experience',
                    style: TextStyle(color: AppTheme.errorColor),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const SizedBox();
              }

              final experienceList = snapshot.data!;
              return Column(
                children: experienceList
                    .map((exp) => _buildExperienceCard(exp))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceCard(ExperienceModel experience) {
    return Container(
      padding: EdgeInsets.all(24.r),
      margin: EdgeInsets.only(bottom: 24.h),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(6.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      experience.role,
                      style: GoogleFonts.inter(
                        color: AppTheme.textColor,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      experience.company,
                      style: GoogleFonts.firaCode(
                        color: AppTheme.primaryColor,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                experience.duration,
                style: GoogleFonts.firaCode(
                  color: AppTheme.secondaryColor,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          ...experience.description.map(
            (desc) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: _buildDescriptionPoint(desc),
            ),
          ),
          if (experience.technologies.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Wrap(
              spacing: 12.w,
              runSpacing: 8.h,
              children: experience.technologies
                  .map(
                    (tech) => Text(
                      tech,
                      style: GoogleFonts.firaCode(
                        color: AppTheme.secondaryColor,
                        fontSize: 13.sp,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDescriptionPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.arrow_right, color: AppTheme.primaryColor, size: 20),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              color: AppTheme.secondaryColor,
              fontSize: 16.sp,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}
