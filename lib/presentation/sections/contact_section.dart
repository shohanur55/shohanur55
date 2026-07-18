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
          // Clear fields
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
              final isMobile = width < 600;
              final isTablet = width >= 600 && width < 1024;
              final isDesktop = width >= 1024;

              final horizontalPadding = isMobile ? 16.0 : (isTablet ? 32.0 : 48.0);
              final verticalPadding = isMobile ? 40.0 : (isTablet ? 60.0 : 80.0);

              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                      Align(
                        alignment: Alignment.center,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: isDesktop ? 600.0 : double.infinity,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Send me a message',
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFFD6DAF0),
                                  fontSize: isMobile
                                      ? 28.sp.clamp(24.0, 32.0)
                                      : 34.sp.clamp(28.0, 34.0),
                                  fontWeight: FontWeight.w700,
                                  height: 1.14,
                                ),
                              ),
                              const SizedBox(height: 24),
                              _buildContactForm(isMobile: isMobile),
                              const SizedBox(height: 48),
                              Text(
                                'Contact Information',
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFFD6DAF0),
                                  fontSize: isMobile
                                      ? 28.sp.clamp(24.0, 32.0)
                                      : 34.sp.clamp(28.0, 34.0),
                                  fontWeight: FontWeight.w700,
                                  height: 1.14,
                                ),
                              ),
                              const SizedBox(height: 24),
                              _buildContactDetailsCard(isMobile: isMobile),
                            ],
                          ),
                        ),
                      ),
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
          mainAxisAlignment: !isMobile ? MainAxisAlignment.start : MainAxisAlignment.center,
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.white.withOpacity(0.10),
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
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: const Color(0xFF0E223F).withOpacity(0.4),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Mail details
          _buildDetailItem(
            icon: FontAwesomeIcons.envelope,
            title: 'Communication With Mail',
            label: 'Email Address 01: ',
            value: 'mshohan088@gmail.com',
            onTap: () => _launchURL('mailto:mshohan088@gmail.com'),
          ),
          SizedBox(height: 32.h),
          // WhatsApp details
          _buildDetailItem(
            icon: FontAwesomeIcons.whatsapp,
            title: 'Contact What-app',
            label: 'What-app Number: ',
            value: '+8801853205092',
            onTap: () => _launchURL('https://wa.me/8801853205092'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required FaIconData icon,
    required String title,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLayeredCircleIcon(icon),
            SizedBox(height: 16.h),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: const Color(0xFFD6DAF0),
                fontSize: 24.sp.clamp(18.0, 26.0),
                fontWeight: FontWeight.w700,
                height: 1.03,
              ),
            ),
            SizedBox(height: 10.h),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: label,
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFD6DAF0),
                      fontSize: 14.sp.clamp(12.0, 16.0),
                      fontWeight: FontWeight.w500,
                      height: 1.43,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFD7D9FF),
                      fontSize: 14.sp.clamp(12.0, 16.0),
                      fontWeight: FontWeight.w400,
                      height: 1.43,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLayeredCircleIcon(FaIconData icon) {
    return SizedBox(
      width: 44.w,
      height: 44.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Layer 1: Outer container
          Opacity(
            opacity: 0.20,
            child: Container(
              width: 44.w,
              height: 44.h,
              decoration: ShapeDecoration(
                color: Colors.white.withOpacity(0.10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(322.22),
                ),
              ),
            ),
          ),
          // Layer 2: White background circle
          Container(
            width: 40.09.w,
            height: 40.09.h,
            decoration: ShapeDecoration(
              color: const Color(0xFFFDFEFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(322.22),
              ),
            ),
          ),
          // Layer 3: Middle opacity circle
          Opacity(
            opacity: 0.50,
            child: Container(
              width: 36.18.w,
              height: 36.18.h,
              decoration: ShapeDecoration(
                color: Colors.white.withOpacity(0.10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(322.22),
                ),
              ),
            ),
          ),
          // Layer 4: Primary Color circle with negative space icon
          Container(
            width: 32.27.w,
            height: 32.27.h,
            decoration: ShapeDecoration(
              color: const Color(0xFF64FFDA),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(322.22),
              ),
            ),
            child: Center(
              child: FaIcon(
                icon,
                color: const Color(0xFF0A192F),
                size: 16.sp.clamp(12.0, 18.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

