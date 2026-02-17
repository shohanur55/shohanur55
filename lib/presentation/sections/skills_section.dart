import 'package:flutter/material.dart';
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
  late Future<List<SkillModel>> _skillsFuture;

  @override
  void initState() {
    super.initState();
    _skillsFuture = _repository.getSkills();
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
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'My Skills',
                style: GoogleFonts.inter(
                  color: AppTheme.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
              const SizedBox(width: 20),
              const Expanded(
                child: Divider(color: AppTheme.cardColor, thickness: 1),
              ),
            ],
          ),
          const SizedBox(height: 40),
          FutureBuilder<List<SkillModel>>(
            future: _skillsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Failed to load skills',
                    style: TextStyle(color: AppTheme.errorColor),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const SizedBox();
              }

              final skills = snapshot.data!;
              // Group skills by category if needed, or just display all
              // For now, let's just display all in a nice wrap
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: skills
                    .map((skill) => _buildSkillChip(skill))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(SkillModel skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.code, color: AppTheme.primaryColor, size: 20),
          const SizedBox(width: 8),
          Text(
            skill.name,
            style: GoogleFonts.firaCode(
              color: AppTheme.primaryColor,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
