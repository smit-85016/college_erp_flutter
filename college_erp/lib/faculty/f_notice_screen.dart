import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../models/faculty_models.dart';

class FNoticeScreen extends StatefulWidget {
  const FNoticeScreen({super.key});
  @override
  State<FNoticeScreen> createState() => _FNoticeScreenState();
}

class _FNoticeScreenState extends State<FNoticeScreen> {
  FacultyNoticeType? _filter;

  List<FacultyNotice> get filtered => _filter == null
      ? FacultyData.notices
      : FacultyData.notices.where((n) => n.type == _filter).toList();

  Color _tagBg(FacultyNoticeType t) => switch (t) {
        FacultyNoticeType.exam => const Color(0xFFFAEEDA),
        FacultyNoticeType.event => const Color(0xFFE6F1FB),
        FacultyNoticeType.holiday => const Color(0xFFFCEBEB),
        FacultyNoticeType.general => AppTheme.primaryLight,
      };

  Color _tagFg(FacultyNoticeType t) => switch (t) {
        FacultyNoticeType.exam => const Color(0xFF854F0B),
        FacultyNoticeType.event => const Color(0xFF185FA5),
        FacultyNoticeType.holiday => const Color(0xFFA32D2D),
        FacultyNoticeType.general => AppTheme.primaryDark,
      };

  String _tagLabel(FacultyNoticeType t) => switch (t) {
        FacultyNoticeType.exam => 'Exam',
        FacultyNoticeType.event => 'Event',
        FacultyNoticeType.holiday => 'Holiday',
        FacultyNoticeType.general => 'General',
      };

  void _postNotice() {
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();
    FacultyNoticeType selectedType = FacultyNoticeType.general;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding: EdgeInsets.only(
              left: 20, right: 20, top: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text('Post new notice',
                    style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                const Spacer(),
                IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
              ]),
              const SizedBox(height: 16),

              // Type selector
              Text('Notice type', style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
              const SizedBox(height: 8),
              Wrap(spacing: 8, children: FacultyNoticeType.values.map((t) {
                final sel = t == selectedType;
                return GestureDetector(
                  onTap: () => setModal(() => selectedType = t),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: sel ? _tagBg(t) : AppTheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: sel ? _tagFg(t) : AppTheme.border, width: 0.8),
                    ),
                    child: Text(_tagLabel(t), style: GoogleFonts.nunito(
                        fontSize: 12, fontWeight: FontWeight.w600,
                        color: sel ? _tagFg(t) : AppTheme.textSecondary)),
                  ),
                );
              }).toList()),
              const SizedBox(height: 16),

              // Title
              TextField(
                controller: titleCtrl,
                style: GoogleFonts.nunito(fontSize: 14),
                decoration: _fieldDecor('Notice title'),
              ),
              const SizedBox(height: 12),

              // Body
              TextField(
                controller: bodyCtrl,
                maxLines: 4,
                style: GoogleFonts.nunito(fontSize: 14),
                decoration: _fieldDecor('Notice details...'),
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity, height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (titleCtrl.text.isNotEmpty && bodyCtrl.text.isNotEmpty) {
                      setState(() {
                        FacultyData.notices.insert(0, FacultyNotice(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: titleCtrl.text,
                          body: bodyCtrl.text,
                          date: '28 Mar 2026',
                          postedBy: 'Prof. Gayan',
                          type: selectedType,
                        ));
                      });
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Notice posted!', style: GoogleFonts.nunito()),
                        backgroundColor: AppTheme.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ));
                    }
                  },
                  icon: const Icon(Icons.send_outlined, size: 18),
                  label: Text('Post Notice', style: GoogleFonts.nunito(fontWeight: FontWeight.w700, fontSize: 14)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary, foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldDecor(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: GoogleFonts.nunito(fontSize: 13, color: AppTheme.textSecondary),
    filled: true, fillColor: AppTheme.surface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppTheme.border, width: 0.8)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppTheme.border, width: 0.8)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppTheme.primary, width: 1.5)),
  );

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Filter chips + post button
      Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                _FilterChip('All', null),
                const SizedBox(width: 8),
                _FilterChip('Exam', FacultyNoticeType.exam),
                const SizedBox(width: 8),
                _FilterChip('Event', FacultyNoticeType.event),
                const SizedBox(width: 8),
                _FilterChip('Holiday', FacultyNoticeType.holiday),
              ]),
            ),
          ),
          GestureDetector(
            onTap: _postNotice,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                const Icon(Icons.add, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text('Post', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
              ]),
            ),
          ),
        ]),
      ),
      Container(height: 1, color: AppTheme.border),

      // Notices list
      Expanded(
        child: filtered.isEmpty
            ? Center(child: Text('No notices', style: GoogleFonts.nunito(color: AppTheme.textSecondary)))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filtered.length,
                itemBuilder: (ctx, i) {
                  final n = filtered[i];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppTheme.border, width: 0.8),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: _tagBg(n.type), borderRadius: BorderRadius.circular(20)),
                          child: Text(_tagLabel(n.type), style: GoogleFonts.nunito(fontSize: 10, fontWeight: FontWeight.w600, color: _tagFg(n.type))),
                        ),
                        const Spacer(),
                        Text(n.date, style: GoogleFonts.nunito(fontSize: 11, color: AppTheme.textSecondary)),
                      ]),
                      const SizedBox(height: 8),
                      Text(n.title, style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                      const SizedBox(height: 6),
                      Text(n.body, style: GoogleFonts.nunito(fontSize: 13, color: AppTheme.textSecondary, height: 1.5)),
                      const SizedBox(height: 8),
                      Text('Posted by: ${n.postedBy}',
                          style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w600, color: _tagFg(n.type))),
                    ]),
                  );
                },
              ),
      ),
    ]);
  }

  Widget _FilterChip(String label, FacultyNoticeType? type) {
    final selected = _filter == type;
    return GestureDetector(
      onTap: () => setState(() => _filter = type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppTheme.primary : AppTheme.border, width: 0.8),
        ),
        child: Text(label, style: GoogleFonts.nunito(
            fontSize: 13, fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppTheme.textSecondary)),
      ),
    );
  }
}
