import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class NoticeBoardScreen extends StatefulWidget {
  const NoticeBoardScreen({super.key});

  @override
  State<NoticeBoardScreen> createState() => _NoticeBoardScreenState();
}

class _NoticeBoardScreenState extends State<NoticeBoardScreen> {
  NoticeType? _filter;

  List<Notice> get filtered => _filter == null
      ? AppData.notices
      : AppData.notices.where((n) => n.type == _filter).toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter chips
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip('All', null),
                const SizedBox(width: 8),
                _FilterChip('Exam', NoticeType.exam),
                const SizedBox(width: 8),
                _FilterChip('Event', NoticeType.event),
                const SizedBox(width: 8),
                _FilterChip('Holiday', NoticeType.holiday),
              ],
            ),
          ),
        ),
        const Divider(height: 1, color: AppTheme.border),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            itemBuilder: (ctx, i) => _NoticeCard(filtered[i]),
          ),
        ),
      ],
    );
  }

  Widget _FilterChip(String label, NoticeType? type) {
    final selected = _filter == type;
    return GestureDetector(
      onTap: () => setState(() => _filter = type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? AppTheme.primary : AppTheme.border,
              width: 0.8),
        ),
        child: Text(label,
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppTheme.textSecondary,
            )),
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  final Notice notice;
  const _NoticeCard(this.notice);

  Color get tagBg => switch (notice.type) {
        NoticeType.exam => const Color(0xFFFAEEDA),
        NoticeType.event => const Color(0xFFE6F1FB),
        NoticeType.holiday => const Color(0xFFFCEBEB),
        NoticeType.general => AppTheme.primaryLight,
      };

  Color get tagFg => switch (notice.type) {
        NoticeType.exam => const Color(0xFF854F0B),
        NoticeType.event => const Color(0xFF185FA5),
        NoticeType.holiday => const Color(0xFFA32D2D),
        NoticeType.general => AppTheme.primaryDark,
      };

  String get tagLabel => switch (notice.type) {
        NoticeType.exam => 'Exam',
        NoticeType.event => 'Event',
        NoticeType.holiday => 'Holiday',
        NoticeType.general => 'General',
      };

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                NoticeTag(label: tagLabel, bg: tagBg, fg: tagFg),
                const Spacer(),
                Text(notice.date,
                    style: GoogleFonts.nunito(
                        fontSize: 11, color: AppTheme.textSecondary)),
              ],
            ),
            const SizedBox(height: 8),
            Text(notice.title,
                style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary)),
            const SizedBox(height: 6),
            Text(notice.body,
                style: GoogleFonts.nunito(
                    fontSize: 13,
                    height: 1.5,
                    color: AppTheme.textSecondary)),
            const SizedBox(height: 8),
            Text('Issued by: ${notice.issuedBy}',
                style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: tagFg)),
          ],
        ),
      ),
    );
  }
}
