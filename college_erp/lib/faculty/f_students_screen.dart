import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';

class FStudentsScreen extends StatelessWidget {
  final String facultyId;

  const FStudentsScreen({super.key, required this.facultyId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: AuthService.getFacultyStudents(facultyId),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No students found',
              style: GoogleFonts.nunito(color: AppTheme.textSecondary),
            ),
          );
        }

        final students = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: students.length,
          itemBuilder: (ctx, i) {
            final data = students[i].data() as Map<String, dynamic>;

            final name = data['name'] ?? '';
            final roll = data['rollNo'] ?? '';
            final email = data['email'] ?? '';
            final phone = data['phone'] ?? '';
            final dept = data['department'] ?? '';
            final sem = data['semester'] ?? '';

            final initials = name
                .split(' ')
                .map((e) => e.isNotEmpty ? e[0] : '')
                .take(2)
                .join();

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppTheme.border),
                borderRadius: BorderRadius.circular(14),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                leading: CircleAvatar(
                  backgroundColor: AppTheme.primary,
                  child: Text(initials,
                      style: GoogleFonts.nunito(color: Colors.white)),
                ),
                title: Text(name,
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary)),
                subtitle: Text(
                  '$roll\n$dept · $sem',
                  style: GoogleFonts.nunito(
                      fontSize: 12, color: AppTheme.textSecondary),
                ),
                isThreeLine: true,
              ),
            );
          },
        );
      },
    );
  }
}