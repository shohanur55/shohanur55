import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        ? 800.w
        : MediaQuery.of(context).size.width * 0.9;

    return Dialog(
      backgroundColor: AppTheme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
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
              padding: EdgeInsets.all(16.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.project.title,
                    style: GoogleFonts.roboto(
                      color: AppTheme.secondaryColor,
                      fontSize: 20.sp.clamp(20.0, 32.0),
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
                padding: EdgeInsets.all(24.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Carousel - same design as project card (multiple images, dots outside)
                    if (widget.project.images.isNotEmpty) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: SizedBox(
                          height: 400.h,
                          width: double.infinity,
                          child: CarouselSlider.builder(
                            itemCount: widget.project.images.length,
                            options: CarouselOptions(
                              height: 400.h,
                              viewportFraction: 1.0,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration: const Duration(
                                milliseconds: 800,
                              ),
                              autoPlayCurve: Curves.easeInOut,
                              enlargeCenterPage: false,
                              enableInfiniteScroll: true,
                              onPageChanged: (index, reason) {
                                setState(() => _currentImageIndex = index);
                              },
                            ),
                            itemBuilder: (context, index, realIndex) {
                              final image = widget.project.images[index];
                              return Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                  image: DecorationImage(
                                    image: image.startsWith('http')
                                        ? NetworkImage(image) as ImageProvider
                                        : AssetImage(image),
                                    fit: BoxFit.contain,
                                    alignment: Alignment.center,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      // Dot indicators - outside/below image area (same as project card)
                      if (widget.project.images.length > 1)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            widget.project.images.length,
                            (index) => Container(
                              margin: EdgeInsets.symmetric(horizontal: 4.w),
                              width: 6.w,
                              height: 6.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentImageIndex == index
                                    ? AppTheme.primaryColor
                                    : AppTheme.secondaryColor.withOpacity(0.4),
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: 24.h),
                    ],

                    // Description
                    Text(
                      widget.project.description,
                      style: GoogleFonts.roboto(
                        color: AppTheme.textColor,
                        fontSize: 16.sp.clamp(14.0, 18.0),
                        height: 1.6,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 24.h),

                    // Technologies
                    Text(
                      'Technologies Used:',
                      style: GoogleFonts.robotoMono(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp.clamp(12.0, 18.0),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: widget.project.technologies
                          .map(
                            (tech) => Chip(
                              label: Text(
                                tech,
                                style: GoogleFonts.robotoMono(
                                  color: AppTheme.primaryColor,
                                  fontSize: 12.sp.clamp(10.0, 16.0),
                                ),
                              ),
                              backgroundColor: AppTheme.primaryColor
                                  .withOpacity(0.1),
                              side: BorderSide.none,
                            ),
                          )
                          .toList(),
                    ),
                    SizedBox(height: 32.h),

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
      icon: Icon(icon, size: 18.sp.clamp(16.0, 24.0)),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? AppTheme.primaryColor : Colors.transparent,
        foregroundColor: isPrimary
            ? AppTheme.backgroundColor
            : AppTheme.primaryColor,
        side: isPrimary ? null : const BorderSide(color: AppTheme.primaryColor),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        textStyle: GoogleFonts.robotoMono(fontWeight: FontWeight.bold),
      ),
    );
  }
}
