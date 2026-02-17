import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/project_model.dart';

class ProjectDetailDialog extends StatefulWidget {
  final Project project;

  const ProjectDetailDialog({super.key, required this.project});

  @override
  State<ProjectDetailDialog> createState() => _ProjectDetailDialogState();
}

class _ProjectDetailDialogState extends State<ProjectDetailDialog> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Determine dialog width based on screen size
    final double dialogWidth = MediaQuery.of(context).size.width > 800
        ? 800
        : MediaQuery.of(context).size.width * 0.9;

    return Dialog(
      backgroundColor: AppTheme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: dialogWidth,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with Close Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.project.title,
                    style: GoogleFonts.roboto(
                      color: AppTheme.secondaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppTheme.textColor),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.white24),

            // Scrollable Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Carousel
                    if (widget.project.images.isNotEmpty) ...[
                      SizedBox(
                        height: 400,
                        child: PageView.builder(
                          itemCount: widget.project.images.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            final image = widget.project.images[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: image.startsWith('http')
                                      ? NetworkImage(image) as ImageProvider
                                      : AssetImage(image),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Indicators
                      if (widget.project.images.length > 1)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            widget.project.images.length,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentImageIndex == index
                                    ? AppTheme.primaryColor
                                    : Colors.grey.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                    ],

                    // Description
                    Text(
                      widget.project.description,
                      style: GoogleFonts.roboto(
                        color: AppTheme.textColor,
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Technologies
                    Text(
                      'Technologies Used:',
                      style: GoogleFonts.robotoMono(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.project.technologies
                          .map(
                            (tech) => Chip(
                              label: Text(
                                tech,
                                style: GoogleFonts.robotoMono(
                                  color: AppTheme.primaryColor,
                                  fontSize: 12,
                                ),
                              ),
                              backgroundColor: AppTheme.primaryColor
                                  .withOpacity(0.1),
                              side: BorderSide.none,
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 32),

                    // Links
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (widget.project.githubUrl != null)
                          _LinkButton(
                            icon: Icons.code,
                            label: 'View Code',
                            url: widget.project.githubUrl!,
                          ),
                        if (widget.project.githubUrl != null &&
                            widget.project.liveUrl != null)
                          const SizedBox(width: 16),
                        if (widget.project.liveUrl != null)
                          _LinkButton(
                            icon: Icons.open_in_new,
                            label: 'Live Demo',
                            url: widget.project.liveUrl!,
                            isPrimary: true,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;
  final bool isPrimary;

  const _LinkButton({
    required this.icon,
    required this.label,
    required this.url,
    this.isPrimary = false,
  });

  Future<void> _launchUrl() async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _launchUrl,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? AppTheme.primaryColor : Colors.transparent,
        foregroundColor: isPrimary
            ? AppTheme.backgroundColor
            : AppTheme.primaryColor,
        side: isPrimary ? null : const BorderSide(color: AppTheme.primaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: GoogleFonts.robotoMono(fontWeight: FontWeight.bold),
      ),
    );
  }
}
