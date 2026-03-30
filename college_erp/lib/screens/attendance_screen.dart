import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final totalAttended = AppData.attendance.fold(0, (s, a) => s + a.attended);
    final totalClasses = AppData.attendance.fold(0, (s, a) => s + a.total);
    final overall = (totalAttended / totalClasses * 100).roundToDouble();
    final safeLeaves = ((totalAttended - 0.75 * totalClasses) / 0.75).floor();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Overall circle
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircularPercentIndicator(
                    radius: 56,
                    lineWidth: 10,
                    percent: overall / 100,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${overall.toInt()}%',
                            style: GoogleFonts.nunito(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primary)),
                        Text('overall',
                            style: GoogleFonts.nunito(
                                fontSize: 10,
                                color: AppTheme.textSecondary)),
                      ],
                    ),
                    progressColor: AppTheme.primary,
                    backgroundColor: AppTheme.primaryLight,
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _StatItem('Classes attended', '$totalAttended / $totalClasses'),
                        const SizedBox(height: 12),
                        _StatItem('Safe leaves left', '$safeLeaves classes'),
                        const SizedBox(height: 12),
                        _StatItem('Minimum required', '75% per subject'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Subject-wise
          SectionCard(
            title: 'Subject-wise attendance',
            child: Column(
              children: AppData.attendance
                  .map((a) => _AttendanceRow(a))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.nunito(
                fontSize: 11, color: AppTheme.textSecondary)),
        Text(value,
            style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary)),
      ],
    );
  }
}

class _AttendanceRow extends StatelessWidget {
  final AttendanceRecord record;
  const _AttendanceRow(this.record);

  Color get barColor {
    if (record.percentage >= 85) return AppTheme.primary;
    if (record.percentage >= 75) return const Color(0xFFEF9F27);
    return const Color(0xFFE24B4A);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(record.subject,
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: AppTheme.textPrimary)),
              ),
              Text(
                '${record.attended}/${record.total} · ${record.percentage.toInt()}%',
                style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: barColor),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: record.percentage / 100,
            backgroundColor: AppTheme.surface,
            valueColor: AlwaysStoppedAnimation(barColor),
            borderRadius: BorderRadius.circular(4),
            minHeight: 6,
          ),
          const SizedBox(height: 6),
          const Divider(height: 1, color: AppTheme.border),
        ],
      ),
    );
  }
}
