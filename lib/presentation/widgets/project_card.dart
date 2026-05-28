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
                          ? _buildFallbackImage()
                          : Stack(
                              fit: StackFit.expand,
                              children: [
                                _buildProjectImage(widget.project.images.first),
                                if (widget.project.images.length > 1)
                                  Positioned(
                                    left: 12.w,
                                    right: 12.w,
                                    bottom: 12.h,
                                    child: _buildThumbnailStrip(),
                                  ),
                              ],
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
                    // Title and Store Links
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.project.title,
                            style: GoogleFonts.roboto(
                              color: AppTheme.secondaryColor,
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
                      maxLines: 2,
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

  Widget _buildFallbackImage() {
    return Container(
      color: AppTheme.primaryColor.withOpacity(0.08),
      alignment: Alignment.center,
      child: Image.asset(
        AppConstants.profileImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        filterQuality: FilterQuality.low,
      ),
    );
  }

  Widget _buildProjectImage(String imagePath) {
    return Container(
      color: AppTheme.primaryColor.withOpacity(0.08),
      child: imagePath.startsWith('http')
          ? Image.network(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              filterQuality: FilterQuality.low,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: AppTheme.primaryColor.withOpacity(0.08),
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppTheme.primaryColor,
                  ),
                );
              },
              errorBuilder: (_, __, ___) => _buildFallbackImage(),
            )
          : Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              filterQuality: FilterQuality.low,
              gaplessPlayback: true,
              errorBuilder: (_, __, ___) => _buildFallbackImage(),
            ),
    );
  }

  Widget _buildThumbnailStrip() {
    return SizedBox(
      height: 64.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.all(6.r),
          itemCount: widget.project.images.length,
          separatorBuilder: (_, __) => SizedBox(width: 6.w),
          itemBuilder: (context, index) {
            final imagePath = widget.project.images[index];
            return ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Container(
                width: 54.w,
                color: AppTheme.backgroundColor.withOpacity(0.55),
                child: imagePath.startsWith('http')
                    ? Image.network(
                        imagePath,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.low,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.image_not_supported_outlined,
                          color: AppTheme.primaryColor,
                          size: 18,
                        ),
                      )
                    : Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.low,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.image_not_supported_outlined,
                          color: AppTheme.primaryColor,
                          size: 18,
                        ),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStoreIcon({required IconData icon, required String url}) {
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
            color: AppTheme.primaryColor.withOpacity(0.1),
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
