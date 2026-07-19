import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/section_container.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  bool _isSending = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) throw 'Could not launch $url';
  }

  Future<bool> sendContactMessage({
    required String name,
    required String phone,
    required String email,
    required String subject,
    required String message,
  }) async {
    try {
      final web3formsAccessKey = dotenv.env['WEB3FORMS_ACCESS_KEY'] ?? '';
      final response = await http.post(
        Uri.parse('https://api.web3forms.com/submit'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'access_key': web3formsAccessKey,
          'name': name,
          'phone': phone,
          'email': email,
          'subject': subject,
          'message': message,
        }),
      );
      final result = jsonDecode(response.body);
      return result['success'] == true;
    } catch (e) {
      return false;
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(
            color: isError ? Colors.white : const Color(0xFF0A192F),
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: isError ? Colors.redAccent : AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        margin: EdgeInsets.all(20.w),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSending = true;
      });

      final success = await sendContactMessage(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        subject: _subjectController.text.trim(),
        message: _messageController.text.trim(),
      );

      if (mounted) {
        setState(() {
          _isSending = false;
        });

        if (success) {
          _showSnackBar('Message sent!');
          _nameController.clear();
          _phoneController.clear();
          _emailController.clear();
          _subjectController.clear();
          _messageController.clear();
        } else {
          _showSnackBar('Failed to send message. Please try again.', isError: true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: SectionContainer(
          color: const Color(0xFF0A192F),
          width: 1400.w,
          padding: EdgeInsets.zero,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final isMobile = width < 768;

              final horizontalPadding = isMobile ? 16.0 : 48.0;
              final verticalPadding = isMobile ? 40.0 : 80.0;

              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Section heading (centered) ──────────────────────
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 24.w,
                                  height: 2,
                                  color: AppTheme.primaryColor,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'My Contact Information',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF64FFDA),
                                    fontSize: 16.sp.clamp(14.0, 18.0),
                                    fontWeight: FontWeight.w700,
                                    height: 1.55,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Container(
                                  width: 24.w,
                                  height: 2,
                                  color: AppTheme.primaryColor,
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              'Contact With Me',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: const Color(0xFFD6DAF0),
                                fontSize: 48.sp.clamp(28.0, 48.0),
                                fontWeight: FontWeight.w700,
                                height: 1.23,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 56.h),

                      // ── Body: mobile = stacked, desktop = side-by-side ──
                      if (isMobile)
                        _buildMobileLayout()
                      else
                        _buildDesktopLayout(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ── Mobile layout: form first, info cards below ─────────────────────────────
  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Send me a message',
          style: GoogleFonts.poppins(
            color: const Color(0xFFD6DAF0),
            fontSize: 28.sp.clamp(24.0, 32.0),
            fontWeight: FontWeight.w700,
            height: 1.14,
          ),
        ),
        const SizedBox(height: 24),
        _buildContactForm(isMobile: true),
        const SizedBox(height: 48),
        Text(
          'Contact Information',
          style: GoogleFonts.poppins(
            color: const Color(0xFFD6DAF0),
            fontSize: 28.sp.clamp(24.0, 32.0),
            fontWeight: FontWeight.w700,
            height: 1.14,
          ),
        ),
        const SizedBox(height: 24),
        _buildContactDetailsCard(isMobile: true),
      ],
    );
  }

  // ── Desktop / Tablet layout: form LEFT, info panel RIGHT ────────────────────
  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── LEFT: Contact Form ────────────────────────────────────────────
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Send me a message',
                style: GoogleFonts.poppins(
                  color: const Color(0xFFD6DAF0),
                  fontSize: 34.sp.clamp(28.0, 34.0),
                  fontWeight: FontWeight.w700,
                  height: 1.14,
                ),
              ),
              const SizedBox(height: 24),
              _buildContactForm(isMobile: false),
            ],
          ),
        ),

        SizedBox(width: 48.w),

        // ── RIGHT: Contact Information panel ─────────────────────────────
        Expanded(
          flex: 4,
          child: _buildRightInfoPanel(),
        ),
      ],
    );
  }

  // ── Right panel shown on desktop/tablet ─────────────────────────────────────
  Widget _buildRightInfoPanel() {
    return Container(
      padding: EdgeInsets.all(32.r),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B35),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Panel heading
          Text(
            'Contact Information',
            style: GoogleFonts.poppins(
              color: const Color(0xFFD6DAF0),
              fontSize: 24.sp.clamp(20.0, 28.0),
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Feel free to reach out through\nany of these channels.',
            style: GoogleFonts.poppins(
              color: AppTheme.secondaryColor,
              fontSize: 14.sp.clamp(12.0, 16.0),
              fontWeight: FontWeight.w400,
              height: 1.6,
            ),
          ),
          SizedBox(height: 32.h),

          // Teal accent divider
          Container(
            height: 2,
            width: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.primaryColor.withValues(alpha: 0.0),
                ],
              ),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          SizedBox(height: 32.h),

          // Email card
          _ContactInfoCard(
            icon: FontAwesomeIcons.envelope,
            title: 'Email Communication',
            label: 'Send inquiries to:',
            value: 'mshohan088@gmail.com',
            actionText: 'Send Email',
            onTap: () => _launchURL('mailto:mshohan088@gmail.com'),
          ),
          SizedBox(height: 20.h),

          // WhatsApp card
          _ContactInfoCard(
            icon: FontAwesomeIcons.whatsapp,
            title: 'WhatsApp Contact',
            label: 'Instant text / call:',
            value: '+8801853205092',
            actionText: 'Chat on WhatsApp',
            onTap: () => _launchURL('https://wa.me/8801853205092'),
          ),

          SizedBox(height: 32.h),

          // Bottom availability badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppTheme.primaryColor.withValues(alpha: 0.20),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF64FFDA),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    'Available for freelance & full-time roles',
                    style: GoogleFonts.poppins(
                      color: AppTheme.primaryColor,
                      fontSize: 13.sp.clamp(11.0, 14.0),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactForm({required bool isMobile}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!isMobile)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _nameController,
                  hintText: 'Your Name',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildTextField(
                  controller: _phoneController,
                  hintText: 'Phone Number',
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          )
        else
          Column(
            children: [
              _buildTextField(
                controller: _nameController,
                hintText: 'Your Name',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _phoneController,
                hintText: 'Phone Number',
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _emailController,
          hintText: 'Email Address',
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your email';
            }
            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegex.hasMatch(value.trim())) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _subjectController,
          hintText: 'Your Subject',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a subject';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _messageController,
          hintText: 'Your Message',
          maxLines: 8,
          borderRadius: 8.r,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your message';
            }
            return null;
          },
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment:
              !isMobile ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            _buildSubmitButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    String? Function(String?)? validator,
    int maxLines = 1,
    double? borderRadius,
    TextInputType? keyboardType,
  }) {
    final double radius = borderRadius ?? 30.r;
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 14.sp.clamp(12.0, 16.0),
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
          color: const Color(0xFFD7D9FF),
          fontSize: 14.sp.clamp(12.0, 16.0),
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: const Color(0xFF0E223F),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.white.withValues(alpha: 0.10),
          ),
          borderRadius: BorderRadius.circular(radius),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1.5,
            color: AppTheme.primaryColor,
          ),
          borderRadius: BorderRadius.circular(radius),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,
            color: Colors.redAccent,
          ),
          borderRadius: BorderRadius.circular(radius),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1.5,
            color: Colors.redAccent,
          ),
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return _isSending
        ? const Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
          )
        : MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _submitForm,
              child: Container(
                width: 206.w.clamp(180.0, 220.0),
                height: 55.h.clamp(48.0, 60.0),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: const Color(0x1964FFDA),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 2,
                      color: Color(0xFF64FFDA),
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: -123.w,
                      top: 56.h,
                      child: Container(
                        width: 418.w,
                        height: 157.h,
                        decoration: const ShapeDecoration(
                          color: Color(0xFFD9D9D9),
                          shape: OvalBorder(),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Send Message',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF64FFDA),
                          fontSize: 18.sp.clamp(14.0, 20.0),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget _buildContactDetailsCard({required bool isMobile}) {
    if (isMobile) {
      return Column(
        children: [
          _ContactInfoCard(
            icon: FontAwesomeIcons.envelope,
            title: 'Email Communication',
            label: 'Send inquiries to:',
            value: 'mshohan088@gmail.com',
            actionText: 'Send Email',
            onTap: () => _launchURL('mailto:mshohan088@gmail.com'),
          ),
          const SizedBox(height: 20),
          _ContactInfoCard(
            icon: FontAwesomeIcons.whatsapp,
            title: 'WhatsApp Contact',
            label: 'Instant text / call:',
            value: '+8801853205092',
            actionText: 'Chat on WhatsApp',
            onTap: () => _launchURL('https://wa.me/8801853205092'),
          ),
        ],
      );
    }
    // Desktop/tablet: cards are embedded in the right panel — not rendered here.
    return const SizedBox.shrink();
  }
}

class _ContactInfoCard extends StatefulWidget {
  final dynamic icon;
  final String title;
  final String label;
  final String value;
  final String actionText;
  final VoidCallback onTap;

  const _ContactInfoCard({
    required this.icon,
    required this.title,
    required this.label,
    required this.value,
    required this.actionText,
    required this.onTap,
  });

  @override
  State<_ContactInfoCard> createState() => _ContactInfoCardState();
}

class _ContactInfoCardState extends State<_ContactInfoCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: _isHovered
                ? const Color(0xFF0E223F).withValues(alpha: 0.8)
                : const Color(0xFF0E223F).withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: _isHovered
                  ? AppTheme.primaryColor
                  : Colors.white.withValues(alpha: 0.05),
              width: _isHovered ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AppTheme.primaryColor.withValues(alpha: 0.12)
                    : Colors.black.withValues(alpha: 0.05),
                blurRadius: _isHovered ? 20.r : 8.r,
                offset: Offset(0, _isHovered ? 8.h : 4.h),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildAnimatedIcon(),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFD6DAF0),
                        fontSize: 18.sp.clamp(16.0, 22.0),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Text(
                widget.label,
                style: GoogleFonts.poppins(
                  color: AppTheme.secondaryColor,
                  fontSize: 13.sp.clamp(11.0, 15.0),
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                widget.value,
                style: GoogleFonts.poppins(
                  color: const Color(0xFFD7D9FF),
                  fontSize: 14.sp.clamp(12.0, 16.0),
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 18.h),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: _isHovered
                      ? AppTheme.primaryColor.withValues(alpha: 0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: AppTheme.primaryColor,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        widget.actionText,
                        style: GoogleFonts.poppins(
                          color: AppTheme.primaryColor,
                          fontSize: 13.sp.clamp(11.0, 15.0),
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: AppTheme.primaryColor,
                      size: 14.sp.clamp(12.0, 16.0),
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

  Widget _buildAnimatedIcon() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 42.w,
      height: 42.h,
      decoration: BoxDecoration(
        color: _isHovered
            ? AppTheme.primaryColor
            : const Color(0xFF64FFDA).withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: FaIcon(
          widget.icon,
          color: _isHovered ? const Color(0xFF0A192F) : AppTheme.primaryColor,
          size: 18.sp.clamp(14.0, 20.0),
        ),
      ),
    );
  }
}
