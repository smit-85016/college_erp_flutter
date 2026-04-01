import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// 🔥 PREMIUM APP LOGO (UPDATED)
Widget appLogo({double size = 100}) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF34A853), Color(0xFF2E8B57)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(size * 0.25),
      boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 15,
          offset: Offset(0, 6),
        )
      ],
    ),
    child: Icon(
      Icons.school,
      color: Colors.white,
      size: size * 0.5,
    ),
  );
}

class MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String? subtitle;
  final Color? valueColor;

  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    this.subtitle,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.nunito(
                  fontSize: 12, color: AppTheme.textSecondary)),
          const SizedBox(height: 6),
          Text(value,
              style: GoogleFonts.nunito(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: valueColor ?? AppTheme.textPrimary,
              )),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!,
                style: GoogleFonts.nunito(
                    fontSize: 11, color: AppTheme.primary)),
          ]
        ],
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const SectionCard({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary)),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class NoticeTag extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;

  const NoticeTag(
      {super.key,
      required this.label,
      required this.bg,
      required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: GoogleFonts.nunito(
              fontSize: 10, fontWeight: FontWeight.w600, color: fg)),
    );
  }
}

class AvatarCircle extends StatelessWidget {
  final String initials;
  final Color color;
  final double size;

  const AvatarCircle(
      {super.key,
      required this.initials,
      required this.color,
      this.size = 44});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Center(
        child: Text(initials,
            style: GoogleFonts.nunito(
                fontSize: size * 0.3,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
      ),
    );
  }
}

class GradeChip extends StatelessWidget {
  final String grade;

  const GradeChip({super.key, required this.grade});

  Color get bg {
    if (grade.startsWith('A')) return const Color(0xFFE1F5EE);
    if (grade.startsWith('B')) return const Color(0xFFE6F1FB);
    return const Color(0xFFFAEEDA);
  }

  Color get fg {
    if (grade.startsWith('A')) return const Color(0xFF0F6E56);
    if (grade.startsWith('B')) return const Color(0xFF185FA5);
    return const Color(0xFF854F0B);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(grade,
          style: GoogleFonts.nunito(
              fontSize: 12, fontWeight: FontWeight.w600, color: fg)),
    );
  }
}