import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class MarksScreen extends StatelessWidget {
  const MarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Summary metrics
          Row(
            children: const [
              Expanded(child: MetricCard(label: 'CGPA (Sem 5)', value: '8.4')),
              SizedBox(width: 12),
              Expanded(child: MetricCard(label: 'SPI (Sem 5)', value: '8.7')),
              SizedBox(width: 12),
              Expanded(child: MetricCard(label: 'Class Rank', value: '12', subtitle: '/ 60 students')),
            ],
          ),
          const SizedBox(height: 16),

          // Bar chart (manual)
          SectionCard(
            title: 'Marks overview – Semester 5',
            child: Column(
              children: AppData.results.map((r) => _MarkBar(r)).toList(),
            ),
          ),

          // Detailed table
          SectionCard(
            title: 'Detailed results',
            child: Column(
              children: [
                _TableHeader(),
                ...AppData.results.map((r) => _ResultRow(r)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MarkBar extends StatelessWidget {
  final SubjectResult result;
  const _MarkBar(this.result);

  Color get barColor {
    if (result.marks >= 85) return AppTheme.primary;
    if (result.marks >= 70) return const Color(0xFF185FA5);
    return const Color(0xFFEF9F27);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(result.subject,
                    style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimary)),
              ),
              Text('${result.marks}/${result.total}',
                  style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: barColor)),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: result.marks / result.total,
            backgroundColor: AppTheme.surface,
            valueColor: AlwaysStoppedAnimation(barColor),
            borderRadius: BorderRadius.circular(4),
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
              child: Text('Subject',
                  style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary))),
          Text('Marks',
              style: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary)),
          const SizedBox(width: 12),
          Text('Grade',
              style: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final SubjectResult result;
  const _ResultRow(this.result);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 1, color: AppTheme.border),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(result.subject,
                    style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimary)),
              ),
              Text('${result.marks} / ${result.total}',
                  style: GoogleFonts.nunito(
                      fontSize: 13, color: AppTheme.textSecondary)),
              const SizedBox(width: 12),
              GradeChip(grade: result.grade),
            ],
          ),
        ),
      ],
    );
  }
}
