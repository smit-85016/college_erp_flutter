import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good morning";
    } else if (hour < 17) {
      return "Good afternoon";
    } else if (hour < 21) {
      return "Good evening";
    } else {
      return "Good night";
    }
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome banner
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${getGreeting()}, Smit!',
                      style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  const SizedBox(height: 4),
                  Text('B.Tech IT · JG University',
                      style: GoogleFonts.nunito(
                          fontSize: 13, color: Colors.white70)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Metrics grid (overflow-safe) ──
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  label: 'Attendance',
                  value: '84%',
                  subtitle: 'Above 75% min',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricCard(
                  label: 'CGPA (Sem 5)',
                  value: '8.4',
                  subtitle: 'Rank 12 / 60',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  label: 'Subjects',
                  value: '6',
                  subtitle: 'This semester',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricCard(
                  label: 'Notices',
                  value: '3',
                  subtitle: 'Unread today',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Today's schedule
          SectionCard(
            title: "Today's schedule",
            child: Column(
              children: [
                _ScheduleRow('9:00 – 10:00 AM', 'Mobile App Dev', 'Lab 3',
                    AppTheme.primaryLight, AppTheme.primaryDark),
                _ScheduleRow('10:00 – 11:00 AM', 'Cloud Computing', 'Room 201',
                    const Color(0xFFE6F1FB), const Color(0xFF185FA5)),
                _ScheduleRow('11:30 – 12:30 PM', 'Data Science', 'Room 105',
                    const Color(0xFFFAEEDA), const Color(0xFF854F0B)),
              ],
            ),
          ),

          // Recent notices
          SectionCard(
            title: 'Recent notices',
            child: Column(
              children:
                  AppData.notices.take(3).map((n) => _NoticeRow(n)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Overflow-safe MetricCard (local, replaces GridView version) ──
class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // ← key fix: don't expand infinitely
        children: [
          Text(
            label,
            style:
                GoogleFonts.nunito(fontSize: 12, color: AppTheme.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.nunito(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.nunito(fontSize: 11, color: AppTheme.primary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  final String time;
  final String subject;
  final String location;
  final Color chipBg;
  final Color chipFg;

  const _ScheduleRow(
      this.time, this.subject, this.location, this.chipBg, this.chipFg);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject,
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppTheme.textPrimary)),
                Text(time,
                    style: GoogleFonts.nunito(
                        fontSize: 12, color: AppTheme.textSecondary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
                color: chipBg, borderRadius: BorderRadius.circular(8)),
            child: Text(location,
                style: GoogleFonts.nunito(
                    fontSize: 11, fontWeight: FontWeight.w600, color: chipFg)),
          ),
        ],
      ),
    );
  }
}

class _NoticeRow extends StatelessWidget {
  final Notice notice;
  const _NoticeRow(this.notice);

  Color get tagBg => switch (notice.type) {
        NoticeType.exam => const Color(0xFFFAEEDA),
        NoticeType.event => const Color(0xFFE6F1FB),
        NoticeType.holiday => const Color(0xFFFCEBEB),
        NoticeType.general => const Color(0xFFE1F5EE),
      };

  Color get tagFg => switch (notice.type) {
        NoticeType.exam => const Color(0xFF854F0B),
        NoticeType.event => const Color(0xFF185FA5),
        NoticeType.holiday => const Color(0xFFA32D2D),
        NoticeType.general => const Color(0xFF0F6E56),
      };

  String get tagLabel => switch (notice.type) {
        NoticeType.exam => 'Exam',
        NoticeType.event => 'Event',
        NoticeType.holiday => 'Holiday',
        NoticeType.general => 'General',
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NoticeTag(label: tagLabel, bg: tagBg, fg: tagFg),
          const SizedBox(height: 4),
          Text(notice.title,
              style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary)),
          Text(notice.date,
              style: GoogleFonts.nunito(
                  fontSize: 11, color: AppTheme.textSecondary)),
          const Divider(height: 16),
        ],
      ),
    );
  }
}
