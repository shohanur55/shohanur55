import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/constants.dart';
import '../../data/models/project_model.dart';
import 'project_detail_dialog.dart';

class ProjectCard extends StatefulWidget {
  final Project project;

  const ProjectCard({super.key, required this.project});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovered = false;
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _showProjectDetails,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()
            ..translate(0.0, _isHovered ? -5.h : 0.0),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.2 : 0.1),
                blurRadius: _isHovered ? 12.r : 6.r,
                offset: Offset(0, _isHovered ? 8.h : 4.h),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Slider Area - multiple images visible together
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(8.r),
                    ),
                    child: SizedBox(
                      height: 280.h,
                      width: double.infinity,
                      child: widget.project.images.isEmpty
                          ? Container(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              child: Image.asset(
                                AppConstants.profileImage,
                                fit: BoxFit.cover,
                              ),
                            )
                          : CarouselSlider.builder(
                              itemCount: widget.project.images.length,
                              options: CarouselOptions(
                                height: 280.h,
                                viewportFraction: 0.32,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 3),
                                autoPlayAnimationDuration: const Duration(
                                  milliseconds: 800,
                                ),
                                autoPlayCurve: Curves.easeInOut,
                                enlargeCenterPage: false,
                                padEnds: false,
                                onPageChanged: (index, reason) {
                                  setState(() => _currentImageIndex = index);
                                },
                              ),
                              itemBuilder: (context, index, realIndex) {
                                final image = widget.project.images[index];
                                return Container(
                                  margin: const EdgeInsets.only(right: 2),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor.withOpacity(
                                      0.1,
                                    ),
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
                                      fit: BoxFit.cover,
                                      alignment: Alignment.topCenter,
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                  // GitHub Link Overlay
                  if (widget.project.githubUrl != null)
                    Positioned(
                      top: 10.h,
                      right: 10.w,
                      child: Material(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20.r),
                        child: InkWell(
                          onTap: () => _launchUrl(widget.project.githubUrl!),
                          borderRadius: BorderRadius.circular(20.r),
                          child: Padding(
                            padding: EdgeInsets.all(8.r),
                            child: Icon(
                              Icons.code,
                              color: Colors.white,
                              size: 20.sp.clamp(16.0, 24.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              // Dot indicators - outside/below the image area
              if (widget.project.images.length > 1)
                Padding(
                  padding: EdgeInsets.only(top: 12.h, bottom: 4.h),
                  child: Row(
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
                ),

              // Content Area
              Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      widget.project.title,
                      style: GoogleFonts.roboto(
                        color: AppTheme.secondaryColor,
                        fontSize: 20.sp.clamp(16.0, 24.0),
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),

                    // Technologies
                    Text(
                      widget.project.technologies.join(', '),
                      style: GoogleFonts.robotoMono(
                        color: AppTheme.primaryColor,
                        fontSize: 12.sp.clamp(10.0, 16.0),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),

                    // Description
                    Text(
                      widget.project.description,
                      style: GoogleFonts.roboto(
                        color: AppTheme.textColor,
                        fontSize: 14,
                        height: 1.5,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                    ),
                    // SizedBox(height: 16.h),

                    // Read More Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _showProjectDetails,
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.primaryColor,
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Read More',
                              style: GoogleFonts.robotoMono(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12.sp.clamp(10.0, 16.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProjectDetails() {
    showDialog(
      context: context,
      builder: (context) => ProjectDetailDialog(project: widget.project),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }
}
