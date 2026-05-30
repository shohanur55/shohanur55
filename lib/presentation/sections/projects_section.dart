import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/project_model.dart';
import '../../data/repositories/portfolio_repository.dart';
import '../widgets/project_card.dart';
import '../widgets/section_container.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  final PortfolioRepository _repository = PortfolioRepository();
  late List<Project> _projects;

  @override
  void initState() {
    super.initState();
    _projects = _repository.getProjects();
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
                '01. ',
                style: GoogleFonts.firaCode(
                  color: AppTheme.primaryColor,
                  fontSize: 20.sp.clamp(18.0, 24.0),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'Some Things I’ve Built',
                style: GoogleFonts.inter(
                  color: AppTheme.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 22.sp.clamp(12.0, 42.0),
                  letterSpacing: -0.4,
                ),
              ),
              SizedBox(width: 20.w),
              const Expanded(
                child: Divider(color: AppTheme.cardColor, thickness: 1),
              ),
            ],
          ),
          SizedBox(height: 50.h),
          if (_projects.isEmpty)
            Center(
              child: Text(
                'No projects found.',
                style: GoogleFonts.firaCode(color: AppTheme.secondaryColor),
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 1;
                if (constraints.maxWidth > 1100) {
                  crossAxisCount = 3;
                } else if (constraints.maxWidth > 700) {
                  crossAxisCount = 2;
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisExtent: 620.h,
                    crossAxisSpacing: 24.w,
                    mainAxisSpacing: 28.h,
                  ),
                  itemCount: _projects.length,
                  itemBuilder: (context, index) {
                    return ProjectCard(project: _projects[index]);
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}
