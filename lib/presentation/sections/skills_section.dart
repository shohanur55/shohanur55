import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/section_container.dart';
import '../../data/repositories/portfolio_repository.dart';
import '../../data/models/skill_model.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  final PortfolioRepository _repository = PortfolioRepository();
  late List<SkillModel> _allSkills;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _allSkills = _repository.getSkills();
  }

  List<String> get _categories {
    final categories = <String>{'All'};
    for (var skill in _allSkills) {
      categories.add(skill.category);
    }
    return categories.toList();
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Mobile Development':
        return Icons.phone_android_rounded;
      case 'Realtime & APIs':
        return Icons.bolt_rounded;
      case 'AI Integrations':
        return Icons.psychology_rounded;
      case 'Website & Backend':
        return Icons.code_rounded;
      case 'Database & Storage':
        return Icons.storage_rounded;
      case 'Tools & Platforms':
        return Icons.build_circle_rounded;
      default:
        return Icons.developer_mode_rounded;
    }
  }

  String _getCategoryDescription(String category) {
    switch (category) {
      case 'Mobile Development':
        return 'Cross-platform iOS/Android development, architecture, performance, & store delivery.';
      case 'Realtime & APIs':
        return 'Real-time communication, WebRTC video/audio, WebSockets, & cloud APIs.';
      case 'AI Integrations':
        return 'Integrating Generative AI models (OpenAI, Gemini, Claude) into mobile applications.';
      case 'Website & Backend':
        return 'Server-side API development, C# .NET, WordPress, & frontend web fundamentals.';
      case 'Database & Storage':
        return 'Relational, NoSQL, local SQLite, Hive & secure key-value persistent storage.';
      case 'Tools & Platforms':
        return 'IDE toolchains, CI/CD automation pipelines, DevTools profiling, & cloud hosting.';
      default:
        return 'Technical capabilities and tools.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;

    // Filter skills based on tab selection
    final filteredSkills = _selectedCategory == 'All'
        ? _allSkills
        : _allSkills.where((s) => s.category == _selectedCategory).toList();

    // Group filtered skills by category
    final Map<String, List<SkillModel>> groupedSkills = {};
    for (var skill in filteredSkills) {
      groupedSkills.putIfAbsent(skill.category, () => []).add(skill);
    }

    return SectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title Header
          Row(
            children: [
              Text(
                '02. ',
                style: GoogleFonts.firaCode(
                  color: AppTheme.primaryColor,
                  fontSize: 20.sp.clamp(18.0, 24.0),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'Technical Expertise',
                style: GoogleFonts.inter(
                  color: AppTheme.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 32.sp.clamp(24.0, 40.0),
                ),
              ),
              SizedBox(width: 20.w),
              const Expanded(
                child: Divider(color: AppTheme.cardColor, thickness: 1),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Subtitle / Intro text for recruiters
          Text(
            'Comprehensive breakdown of technologies, frameworks, realtime services, and architectures I leverage to deliver enterprise-grade mobile & web solutions.',
            style: GoogleFonts.inter(
              color: AppTheme.secondaryColor,
              fontSize: 15.sp.clamp(13.0, 16.0),
              height: 1.5,
            ),
          ),
          SizedBox(height: 28.h),

          // Category Filter Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                    selectedColor: AppTheme.primaryColor.withValues(alpha: 0.15),
                    backgroundColor: AppTheme.cardColor,
                    checkmarkColor: AppTheme.primaryColor,
                    side: BorderSide(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.primaryColor.withValues(alpha: 0.2),
                      width: isSelected ? 1.5 : 1.0,
                    ),
                    labelStyle: GoogleFonts.firaCode(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.secondaryColor,
                      fontSize: 13.sp.clamp(12.0, 15.0),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 36.h),

          // Skills Content Layout (Responsive 2-column or 1-column grid)
          if (groupedSkills.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(32.0.r),
                child: Text(
                  'No skills found in this category.',
                  style: GoogleFonts.inter(color: AppTheme.secondaryColor),
                ),
              ),
            )
          else if (isDesktop)
            _buildDesktopGrid(groupedSkills)
          else
            _buildMobileColumn(groupedSkills),
        ],
      ),
    );
  }

  // Desktop/Wide View: 2 Columns of Category Cards
  Widget _buildDesktopGrid(Map<String, List<SkillModel>> groupedSkills) {
    final entries = groupedSkills.entries.toList();
    final leftCol = <MapEntry<String, List<SkillModel>>>[];
    final rightCol = <MapEntry<String, List<SkillModel>>>[];

    for (int i = 0; i < entries.length; i++) {
      if (i % 2 == 0) {
        leftCol.add(entries[i]);
      } else {
        rightCol.add(entries[i]);
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: leftCol.map((e) => _buildCategoryCard(e.key, e.value)).toList(),
          ),
        ),
        SizedBox(width: 24.w),
        Expanded(
          child: Column(
            children: rightCol.map((e) => _buildCategoryCard(e.key, e.value)).toList(),
          ),
        ),
      ],
    );
  }

  // Mobile / Vertical View: 1 Column Stack of Category Cards
  Widget _buildMobileColumn(Map<String, List<SkillModel>> groupedSkills) {
    return Column(
      children: groupedSkills.entries
          .map((e) => _buildCategoryCard(e.key, e.value))
          .toList(),
    );
  }

  // Domain Category Card Widget
  Widget _buildCategoryCard(String category, List<SkillModel> skills) {
    final icon = _getCategoryIcon(category);
    final description = _getCategoryDescription(category);

    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Header (Icon, Title, Count)
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primaryColor,
                  size: 22.sp.clamp(18.0, 26.0),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: GoogleFonts.inter(
                        color: AppTheme.textColor,
                        fontSize: 18.sp.clamp(16.0, 20.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      description,
                      style: GoogleFonts.inter(
                        color: AppTheme.secondaryColor,
                        fontSize: 12.sp.clamp(11.0, 13.0),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppTheme.primaryColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  '${skills.length}',
                  style: GoogleFonts.firaCode(
                    color: AppTheme.primaryColor,
                    fontSize: 12.sp.clamp(10.0, 14.0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          const Divider(color: Colors.white10, height: 1),
          SizedBox(height: 20.h),

          // Skill Chips Wrap
          Wrap(
            spacing: 10.w,
            runSpacing: 12.h,
            children: skills.map((skill) => _buildSkillBadge(skill)).toList(),
          ),
        ],
      ),
    );
  }

  // Skill Badge Chip Widget
  Widget _buildSkillBadge(SkillModel skill) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: skill.isFeatured
            ? AppTheme.primaryColor.withValues(alpha: 0.1)
            : AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: skill.isFeatured
              ? AppTheme.primaryColor.withValues(alpha: 0.5)
              : AppTheme.primaryColor.withValues(alpha: 0.18),
          width: skill.isFeatured ? 1.2 : 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (skill.isFeatured) ...[
            Icon(
              Icons.star_rounded,
              color: AppTheme.primaryColor,
              size: 14.sp.clamp(12.0, 16.0),
            ),
            SizedBox(width: 6.w),
          ] else ...[
            Icon(
              Icons.code_rounded,
              color: AppTheme.secondaryColor.withValues(alpha: 0.7),
              size: 14.sp.clamp(12.0, 16.0),
            ),
            SizedBox(width: 6.w),
          ],
          Text(
            skill.name,
            style: GoogleFonts.firaCode(
              color: skill.isFeatured ? AppTheme.primaryColor : AppTheme.textColor,
              fontSize: 13.sp.clamp(11.0, 14.0),
              fontWeight: skill.isFeatured ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
