import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class FacultyScreen extends StatelessWidget {
  const FacultyScreen({super.key});

  static const avatarColors = [
    Color(0xFF185FA5),
    Color(0xFF854F0B),
    Color(0xFF3B6D11),
    Color(0xFF993556),
    Color(0xFF534AB7),
    Color(0xFF0F6E56),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: AppData.faculty.length,
      itemBuilder: (ctx, i) => _FacultyCard(AppData.faculty[i], avatarColors[i % avatarColors.length]),
    );
  }
}

class _FacultyCard extends StatelessWidget {
  final Faculty faculty;
  final Color avatarColor;

  const _FacultyCard(this.faculty, this.avatarColor);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            AvatarCircle(initials: faculty.initials, color: avatarColor, size: 52),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(faculty.name,
                      style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary)),
                  Text(faculty.designation,
                      style: GoogleFonts.nunito(
                          fontSize: 12, color: AppTheme.textSecondary)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(faculty.subject,
                        style: GoogleFonts.nunito(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryDark)),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.email_outlined,
                          size: 13, color: avatarColor),
                      const SizedBox(width: 4),
                      Text(faculty.email,
                          style: GoogleFonts.nunito(
                              fontSize: 12, color: avatarColor)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
