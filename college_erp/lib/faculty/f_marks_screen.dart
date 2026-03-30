import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../models/faculty_models.dart';

class FMarksScreen extends StatefulWidget {
  const FMarksScreen({super.key});
  @override
  State<FMarksScreen> createState() => _FMarksScreenState();
}

class _FMarksScreenState extends State<FMarksScreen> {
  String _selectedSubject = FacultyData.subjects.first;
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _controllers.clear();
    for (var s in FacultyData.students) {
      final existing = FacultyData.marksData[s.id]?[_selectedSubject];
      _controllers[s.id] = TextEditingController(
          text: existing != null ? '$existing' : '');
    }
  }

  @override
  void dispose() {
    for (var c in _controllers.values) c.dispose();
    super.dispose();
  }

  void _saveMarks() {
    for (var s in FacultyData.students) {
      final val = int.tryParse(_controllers[s.id]?.text ?? '');
      if (val != null) {
        FacultyData.marksData.putIfAbsent(s.id, () => <String, int>{})[_selectedSubject] = val;

      }
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Marks saved for $_selectedSubject!', style: GoogleFonts.nunito()),
      backgroundColor: AppTheme.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  Color _gradeColor(int? marks) {
    if (marks == null) return AppTheme.textSecondary;
    if (marks >= 85) return AppTheme.primary;
    if (marks >= 70) return const Color(0xFF185FA5);
    if (marks >= 55) return const Color(0xFFEF9F27);
    return const Color(0xFFE24B4A);
  }

  String _grade(int? marks) {
    if (marks == null) return '–';
    if (marks >= 90) return 'A+';
    if (marks >= 80) return 'A';
    if (marks >= 70) return 'B';
    if (marks >= 60) return 'C';
    if (marks >= 50) return 'D';
    return 'F';
  }

  double get _classAvg {
    final vals = FacultyData.students
        .map((s) => FacultyData.marksData[s.id]?[_selectedSubject])
        .whereType<int>()
        .toList();
    if (vals.isEmpty) return 0;
    return vals.fold(0, (a, b) => a + b) / vals.length;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Subject selector
      Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: FacultyData.subjects.map((sub) {
                final sel = sub == _selectedSubject;
                return GestureDetector(
                  onTap: () => setState(() {
                    _selectedSubject = sub;
                    _initControllers();
                  }),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: sel ? AppTheme.primary : AppTheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: sel ? AppTheme.primary : AppTheme.border, width: 0.8),
                    ),
                    child: Text(sub, style: GoogleFonts.nunito(
                        fontSize: 13, fontWeight: FontWeight.w600,
                        color: sel ? Colors.white : AppTheme.textSecondary)),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          // Class average
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: AppTheme.primaryLight, borderRadius: BorderRadius.circular(10)),
              child: Text('Class average: ${_classAvg.toStringAsFixed(1)} / 100',
                  style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primaryDark)),
            ),
            const Spacer(),
            Text('Out of 100', style: GoogleFonts.nunito(fontSize: 12, color: AppTheme.textSecondary)),
          ]),
        ]),
      ),
      Container(height: 1, color: AppTheme.border),

      // Header row
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: Row(children: [
          Expanded(child: Text('Student', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary))),
          SizedBox(width: 80, child: Text('Marks', textAlign: TextAlign.center, style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary))),
          SizedBox(width: 44, child: Text('Grade', textAlign: TextAlign.center, style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary))),
        ]),
      ),

      // Student list
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: FacultyData.students.length,
          itemBuilder: (ctx, i) {
            final s = FacultyData.students[i];
            final ctrl = _controllers[s.id]!;
            final currentMarks = int.tryParse(ctrl.text);

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppTheme.border, width: 0.8),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(children: [
                // Avatar + name
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                  child: Center(child: Text(s.initials,
                      style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white))),
                ),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(s.name, style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                  Text(s.rollNo, style: GoogleFonts.nunito(fontSize: 11, color: AppTheme.textSecondary)),
                ])),
                // Marks input
                SizedBox(
                  width: 72,
                  child: TextField(
                    controller: ctrl,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    onChanged: (_) => setState(() {}),
                    style: GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                    decoration: InputDecoration(
                      hintText: '0',
                      hintStyle: GoogleFonts.nunito(color: AppTheme.textSecondary),
                      filled: true, fillColor: AppTheme.surface,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppTheme.border, width: 0.8)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppTheme.border, width: 0.8)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppTheme.primary, width: 1.5)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Grade chip
                Container(
                  width: 38, height: 32,
                  decoration: BoxDecoration(
                    color: _gradeColor(currentMarks).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(child: Text(_grade(currentMarks),
                      style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: _gradeColor(currentMarks)))),
                ),
              ]),
            );
          },
        ),
      ),

      // Save button
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: SizedBox(
          width: double.infinity, height: 50,
          child: ElevatedButton.icon(
            onPressed: _saveMarks,
            icon: const Icon(Icons.save_outlined, size: 20),
            label: Text('Save Marks · $_selectedSubject', style: GoogleFonts.nunito(fontWeight: FontWeight.w700, fontSize: 14)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary, foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
          ),
        ),
      ),
    ]);
  }
}
