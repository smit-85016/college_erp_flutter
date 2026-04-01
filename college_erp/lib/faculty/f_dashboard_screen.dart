import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../models/faculty_models.dart';
import '../../providers/current_user.dart';
import '../../widgets/common_widgets.dart';

class FDashboardScreen extends StatelessWidget {
  const FDashboardScreen({super.key});

  static const _blue = Color(0xFF185FA5);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: currentUser,
      builder: (context, _) {
        final name = currentUser.name.isNotEmpty ? currentUser.name : 'Faculty';
        final firstName = name.split(' ').first;
        final dept = currentUser.department.isNotEmpty ? currentUser.department : 'IT';
        final initials = currentUser.initials;
        final totalStudents = FacultyData.students.length;
        final avgCgpa = totalStudents > 0
            ? FacultyData.students.fold(0.0, (s, st) => s + st.cgpa) / totalStudents
            : 0.0;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome banner — dynamic faculty name
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: _blue, borderRadius: BorderRadius.circular(16)),
                child: Row(children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Welcome, $firstName!',
                          style: GoogleFonts.nunito(
                              fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text('$dept Dept · JG University',
                          style: GoogleFonts.nunito(fontSize: 12, color: Colors.white70)),
                      const SizedBox(height: 12),
                      Row(children: [
                        _PillStat('${FacultyData.subjects.length} Subjects'),
                        const SizedBox(width: 8),
                        _PillStat('$totalStudents Students'),
                      ]),
                    ]),
                  ),
                  Container(
                    width: 56, height: 56,
                    decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                    child: Center(child: Text(initials,
                        style: GoogleFonts.nunito(
                            fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white))),
                  ),
                ]),
              ),
              const SizedBox(height: 16),

              // Metrics
              Row(children: [
                Expanded(child: _FMetric('Total Students', '$totalStudents', 'Sem 6 · $dept')),
                const SizedBox(width: 12),
                Expanded(child: _FMetric('Avg CGPA', avgCgpa.toStringAsFixed(1), 'Class average')),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: _FMetric('Subjects', '${FacultyData.subjects.length}', 'This semester')),
                const SizedBox(width: 12),
                Expanded(child: _FMetric('Notices', '${FacultyData.notices.length}', 'Posted')),
              ]),
              const SizedBox(height: 20),

              // Today's classes
              _SectionTitle("Today's classes"),
              const SizedBox(height: 10),
              _ClassCard('9:00 – 10:00 AM', 'Mobile App Dev', 'Lab 3',
                  '$dept Sem 6 · $totalStudents students'),
              const SizedBox(height: 8),
              _ClassCard('2:00 – 3:00 PM', 'Project Work', 'Lab 1',
                  '$dept Sem 6 · $totalStudents students'),
              const SizedBox(height: 20),

              _SectionTitle('Recent notices'),
              const SizedBox(height: 10),
              ...FacultyData.notices.take(2).map((n) => _NoticePreview(n)),
            ],
          ),
        );
      },
    );
  }
}

class _PillStat extends StatelessWidget {
  final String label;
  const _PillStat(this.label);
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
        child: Text(label, style: GoogleFonts.nunito(
            fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
      );
}

class _FMetric extends StatelessWidget {
  final String label, value, sub;
  const _FMetric(this.label, this.value, this.sub);
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(label, style: GoogleFonts.nunito(fontSize: 12, color: AppTheme.textSecondary),
              maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Text(value, style: GoogleFonts.nunito(
              fontSize: 26, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          const SizedBox(height: 4),
          Text(sub, style: GoogleFonts.nunito(fontSize: 11, color: const Color(0xFF185FA5)),
              maxLines: 1, overflow: TextOverflow.ellipsis),
        ]),
      );
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) => Text(title,
      style: GoogleFonts.nunito(
          fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary));
}

class _ClassCard extends StatelessWidget {
  final String time, subject, location, info;
  const _ClassCard(this.time, this.subject, this.location, this.info);
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppTheme.border, width: 0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [
          Container(
              width: 4, height: 44,
              decoration: BoxDecoration(
                  color: const Color(0xFF185FA5), borderRadius: BorderRadius.circular(4))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(subject, style: GoogleFonts.nunito(
                fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
            Text(info, style: GoogleFonts.nunito(fontSize: 12, color: AppTheme.textSecondary)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: const Color(0xFFE6F1FB), borderRadius: BorderRadius.circular(6)),
              child: Text(location, style: GoogleFonts.nunito(
                  fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF185FA5))),
            ),
            const SizedBox(height: 4),
            Text(time, style: GoogleFonts.nunito(fontSize: 11, color: AppTheme.textSecondary)),
          ]),
        ]),
      );
}

class _NoticePreview extends StatelessWidget {
  final FacultyNotice notice;
  const _NoticePreview(this.notice);
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppTheme.border, width: 0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(notice.title, style: GoogleFonts.nunito(
              fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
          const SizedBox(height: 4),
          Text(notice.date, style: GoogleFonts.nunito(fontSize: 11, color: AppTheme.textSecondary)),
        ]),
      );
}
