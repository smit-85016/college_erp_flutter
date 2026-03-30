import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../login_screen.dart';

class PendingScreen extends StatelessWidget {
  final String name;
  const PendingScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 90, height: 90,
                decoration: BoxDecoration(
                    color: const Color(0xFFFAEEDA),
                    shape: BoxShape.circle),
                child: const Icon(Icons.hourglass_top_rounded,
                    size: 44, color: Color(0xFF854F0B)),
              ),
              const SizedBox(height: 28),

              Text('Registration Submitted!',
                  style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                  textAlign: TextAlign.center),
              const SizedBox(height: 12),

              Text(
                'Hi $name, your registration request has been sent to your class teacher for approval.',
                style: GoogleFonts.nunito(fontSize: 14, color: AppTheme.textSecondary, height: 1.6),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),

              // Steps
              _Step('1', 'Registration submitted', true),
              _Step('2', 'Faculty reviews your request', false),
              _Step('3', 'You get approved & can login', false),

              const SizedBox(height: 36),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: AppTheme.primaryLight, borderRadius: BorderRadius.circular(14)),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Icon(Icons.info_outline, size: 18, color: AppTheme.primaryDark),
                  const SizedBox(width: 10),
                  Expanded(child: Text(
                    'Once your class teacher approves, you can login with your registered email and password.',
                    style: GoogleFonts.nunito(fontSize: 12, color: AppTheme.primaryDark, height: 1.5),
                  )),
                ]),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity, height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (_) => false,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary, foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: Text('Back to Login',
                      style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final String num, label;
  final bool done;
  const _Step(this.num, this.label, this.done);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: done ? AppTheme.primary : AppTheme.surface,
            shape: BoxShape.circle,
            border: Border.all(color: done ? AppTheme.primary : AppTheme.border, width: 1.5),
          ),
          child: Center(child: done
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : Text(num, style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textSecondary))),
        ),
        const SizedBox(width: 12),
        Text(label, style: GoogleFonts.nunito(
            fontSize: 13,
            fontWeight: done ? FontWeight.w600 : FontWeight.w400,
            color: done ? AppTheme.primary : AppTheme.textSecondary)),
      ]),
    );
  }
}
