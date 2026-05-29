import 'dart:math' as math;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  final Map<String, double> _imageAspectRatios = {};
  final Set<String> _pendingAspectRatioLoads = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _primeImageAspectRatios();
  }

  void _primeImageAspectRatios() {
    for (final image in widget.project.images) {
      if (_imageAspectRatios.containsKey(image) ||
          _pendingAspectRatioLoads.contains(image)) {
        continue;
      }

      _pendingAspectRatioLoads.add(image);

      final ImageProvider provider = image.startsWith('http')
          ? NetworkImage(image)
          : AssetImage(image);
      final stream = provider.resolve(createLocalImageConfiguration(context));

      late final ImageStreamListener listener;
      listener = ImageStreamListener(
        (ImageInfo info, bool synchronousCall) {
          if (!mounted) {
            return;
          }

          setState(() {
            _imageAspectRatios[image] = info.image.width / info.image.height;
            _pendingAspectRatioLoads.remove(image);
          });

          stream.removeListener(listener);
        },
        onError: (Object error, StackTrace? stackTrace) {
          _pendingAspectRatioLoads.remove(image);
          stream.removeListener(listener);
        },
      );

      stream.addListener(listener);
    }
  }

  double _currentImageAspectRatio() {
    if (widget.project.images.isEmpty) {
      return 9 / 16;
    }

    return _imageAspectRatios[widget.project.images[_currentImageIndex]] ??
        9 / 16;
  }

  @override
  Widget build(BuildContext context) {
    // Determine dialog width based on screen size
    final double dialogWidth = MediaQuery.of(context).size.width > 800
        ? 800.w
        : MediaQuery.of(context).size.width * 0.9;

    // Compute taller image height for phone-like screenshots (cap to avoid overflow)
    final double screenH = MediaQuery.of(context).size.height;
    final double imageHeight = math.min(screenH * 1.2, 700.h); // 1.2x screen height or max 400h
    final double currentImageAspectRatio = _currentImageAspectRatio();

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
                        borderRadius: BorderRadius.circular(16.r),
                        child: SizedBox(
                          height: imageHeight,
                          width: double.infinity,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final imageCount = widget.project.images.length;
                              final targetImageWidth =
                                  imageHeight * currentImageAspectRatio;
                              final viewportFraction =
                                  (targetImageWidth / constraints.maxWidth)
                                      .clamp(0.18, 0.95)
                                  .toDouble();

                              return CarouselSlider.builder(
                                itemCount: imageCount,
                                options: CarouselOptions(
                                  height: imageHeight,
                                  viewportFraction: viewportFraction,
                                  autoPlay: true,
                                  autoPlayInterval: const Duration(seconds: 4),
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
                                  final image = widget.project.images[index];
                                  final isSelected =
                                      index == _currentImageIndex;
                                  return AnimatedPadding(
                                    duration: const Duration(milliseconds: 220),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4.w,
                                      vertical: 0,
                                    ),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 220,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          14.r,
                                        ),
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
                                        borderRadius: BorderRadius.circular(
                                          13.r,
                                        ),
                                        child: image.startsWith('http')
                                            ? Image.network(
                                                image,
                                                fit: BoxFit.contain,
                                                width: double.infinity,
                                                height: double.infinity,
                                                filterQuality:
                                                    FilterQuality.medium,
                                                loadingBuilder:
                                                    (
                                                      context,
                                                      child,
                                                      loadingProgress,
                                                    ) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                              color: AppTheme
                                                                  .primaryColor,
                                                            ),
                                                      );
                                                    },
                                                errorBuilder: (_, __, ___) =>
                                                    const Center(
                                                      child: Icon(
                                                        Icons
                                                            .image_not_supported_outlined,
                                                        color: AppTheme
                                                            .primaryColor,
                                                        size: 36,
                                                      ),
                                                    ),
                                              )
                                            : Image.asset(
                                                image,
                                                fit: BoxFit.contain,
                                                width: double.infinity,
                                                height: double.infinity,
                                                filterQuality:
                                                    FilterQuality.high,
                                                gaplessPlayback: true,
                                                errorBuilder: (_, __, ___) =>
                                                    const Center(
                                                      child: Icon(
                                                        Icons
                                                            .image_not_supported_outlined,
                                                        color: AppTheme
                                                            .primaryColor,
                                                        size: 36,
                                                      ),
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
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(18.r),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundColor.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: AppTheme.primaryColor.withOpacity(0.12),
                        ),
                      ),
                      child: Text(
                        widget.project.description,
                        style: GoogleFonts.roboto(
                          color: AppTheme.textColor,
                          fontSize: 16.sp.clamp(14.0, 18.0),
                          height: 1.7,
                        ),
                        textAlign: TextAlign.justify,
                      ),
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
                      spacing: 10.w,
                      runSpacing: 10.h,
                      children: widget.project.technologies
                          .map(
                            (tech) => Chip(
                              label: Text(
                                tech,
                                style: GoogleFonts.robotoMono(
                                  color: AppTheme.primaryColor,
                                  fontSize: 12.sp.clamp(10.0, 16.0),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              backgroundColor: AppTheme.primaryColor
                                  .withOpacity(0.08),
                              side: BorderSide(
                                color: AppTheme.primaryColor.withOpacity(0.15),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    SizedBox(height: 32.h),

                    // Links
                    Wrap(
                      spacing: 16.w,
                      runSpacing: 16.h,
                      alignment: WrapAlignment.end,
                      children: [
                        if (widget.project.githubUrl != null)
                          _LinkButton(
                            icon: Icons.code,
                            label: 'View Code',
                            url: widget.project.githubUrl!,
                          ),
                        if (widget.project.liveUrl != null)
                          _LinkButton(
                            icon: Icons.open_in_new,
                            label: 'Live Demo',
                            url: widget.project.liveUrl!,
                            isPrimary: true,
                          ),
                        if (widget.project.playStoreUrl != null)
                          _LinkButton(
                            icon: FontAwesomeIcons.googlePlay,
                            label: 'Play Store',
                            url: widget.project.playStoreUrl!,
                            isPrimary: true,
                          ),
                        if (widget.project.appStoreUrl != null)
                          _LinkButton(
                            icon: FontAwesomeIcons.appStoreIos,
                            label: 'App Store',
                            url: widget.project.appStoreUrl!,
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
