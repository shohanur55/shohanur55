import 'dart:math' as math;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
              // Image slider area
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(8.r),
                    ),
                    child: SizedBox(
                      height: 340.h,
                      width: double.infinity,
                      child: widget.project.images.isEmpty
                          ? _buildFallbackImage()
                          : LayoutBuilder(
                              builder: (context, constraints) {
                                final imageCount = widget.project.images.length;
                                final maxVisible = math.max(
                                  1,
                                  math.min(
                                    imageCount,
                                    (constraints.maxWidth / 112.w).floor(),
                                  ),
                                );
                                final viewportFraction = (1 / maxVisible)
                                    .clamp(0.18, 1.0)
                                    .toDouble();

                                return CarouselSlider.builder(
                                  itemCount: imageCount,
                                  options: CarouselOptions(
                                    height: 340.h,
                                    viewportFraction: viewportFraction,
                                    autoPlay: true,
                                    autoPlayInterval:
                                        const Duration(seconds: 2),
                                    autoPlayAnimationDuration: const Duration(
                                      milliseconds: 750,
                                    ),
                                    autoPlayCurve: Curves.easeInOutCubic,
                                    enlargeCenterPage: true,
                                    enlargeFactor: 0.18,
                                    enableInfiniteScroll: imageCount > 1,
                                    padEnds: true,
                                    onPageChanged: (index, reason) {
                                      setState(() => _currentImageIndex = index);
                                    },
                                  ),
                                  itemBuilder: (context, index, realIndex) {
                                    final imagePath = widget.project.images[index];
                                    final isSelected = index == _currentImageIndex;
                                    return AnimatedPadding(
                                      duration: const Duration(milliseconds: 220),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4.w,
                                        vertical: isSelected ? 0 : 10.h,
                                      ),
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 220),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14.r),
                                          border: Border.all(
                                            color: isSelected
                                                ? AppTheme.primaryColor
                                                : Colors.white.withOpacity(0.10),
                                            width: isSelected ? 1.6 : 1,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: isSelected
                                                  ? AppTheme.primaryColor
                                                      .withOpacity(0.18)
                                                  : Colors.black.withOpacity(
                                                      0.10,
                                                    ),
                                              blurRadius: isSelected ? 18 : 8,
                                              offset: Offset(
                                                0,
                                                isSelected ? 10.h : 4.h,
                                              ),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(13.r),
                                          child: _buildProjectImage(
                                            imagePath,
                                            fit: BoxFit.contain,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10.w,
                                              vertical: 8.h,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ),
                  if (widget.project.images.length > 1)
                    Positioned(
                      top: 12.h,
                      left: 12.w,
                      child: _buildImageCounter(),
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
                  padding: EdgeInsets.only(top: 10.h, bottom: 6.h),
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
                padding: EdgeInsets.fromLTRB(16.r, 14.r, 16.r, 16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Store Links
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.project.title,
                            style: GoogleFonts.roboto(
                              color: AppTheme.textColor,
                              fontSize: 20.sp.clamp(16.0, 24.0),
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (widget.project.playStoreUrl != null) ...[
                          SizedBox(width: 8.w),
                          _buildStoreIcon(
                            icon: FontAwesomeIcons.googlePlay,
                            url: widget.project.playStoreUrl!,
                          ),
                        ],
                        if (widget.project.appStoreUrl != null) ...[
                          SizedBox(width: 8.w),
                          _buildStoreIcon(
                            icon: FontAwesomeIcons.appStoreIos,
                            url: widget.project.appStoreUrl!,
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 6.h),

                    // Technologies
                    Text(
                      widget.project.technologies.join(', '),
                      style: GoogleFonts.robotoMono(
                        color: AppTheme.primaryColor.withOpacity(0.95),
                        fontSize: 12.sp.clamp(10.0, 16.0),
                        letterSpacing: 0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),

                    // Description
                    Text(
                      widget.project.description,
                      style: GoogleFonts.roboto(
                        color: AppTheme.secondaryColor.withOpacity(0.95),
                        fontSize: 14,
                        height: 1.6,
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
                                decoration: TextDecoration.none,
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

  Widget _buildFallbackImage() {                                                                                                                                                                                                                                                                                                                                                
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.cardColor.withOpacity(0.95),
            AppTheme.backgroundColor.withOpacity(0.95),
          ],
        ),
      ),
      alignment: Alignment.center,
      child: Image.asset(
        AppConstants.profileImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        cacheWidth: 280,
        filterQuality: FilterQuality.low,
      ),
    );
  }

  Widget _buildProjectImage(
    String imagePath, {
    BoxFit fit = BoxFit.contain,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.backgroundColor.withOpacity(0.95),
            AppTheme.cardColor.withOpacity(0.95),
          ],
        ),
      ),
      child: Padding(
        padding: padding,
        child: imagePath.startsWith('http')
            ? Image.network(
                imagePath,
                fit: fit,
                width: double.infinity,
                height: double.infinity,
                filterQuality: FilterQuality.medium,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.primaryColor,
                    ),
                  );
                },
                errorBuilder: (_, __, ___) => _buildFallbackImage(),
              )
            : Image.asset(
                imagePath,
                fit: fit,
                width: double.infinity,
                height: double.infinity,
                cacheWidth: 400,
                filterQuality: FilterQuality.medium,
                gaplessPlayback: true,
                errorBuilder: (_, __, ___) => _buildFallbackImage(),
              ),
      ),
    );
  }

  Widget _buildImageCounter() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.45),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Text(
        '${_currentImageIndex + 1}/${widget.project.images.length}',
        style: GoogleFonts.robotoMono(
          color: Colors.white,
          fontSize: 11.sp.clamp(10.0, 14.0),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildStoreIcon({required FaIconData icon, required String url}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _launchUrl(url),
        borderRadius: BorderRadius.circular(6.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.primaryColor.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(6.r),
            color: AppTheme.primaryColor.withOpacity(0.14),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                icon,
                size: 14.sp.clamp(12.0, 16.0),
                color: AppTheme.primaryColor,
              ),
              SizedBox(width: 4.w),
              Text(
                icon == FontAwesomeIcons.googlePlay
                    ? 'Play Store'
                    : 'App Store',
                style: GoogleFonts.robotoMono(
                  color: AppTheme.primaryColor,
                  fontSize: 10.sp.clamp(8.0, 12.0),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
