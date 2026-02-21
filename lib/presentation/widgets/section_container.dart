import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  const SectionContainer({
    super.key,
    required this.child,
    this.width,
    this.padding,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 1000;
    final isTablet = size.width > 600 && size.width <= 1000;

    double horizontalPadding = isDesktop ? 150.w : (isTablet ? 80.w : 20.w);
    double verticalPadding = isDesktop ? 80.h : 50.h;

    return Container(
      width: double.infinity,
      color: color,
      padding:
          padding ??
          EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: width ?? 1200.w,
          ),
          child: child,
        ),
      ),
    );
  }
}
