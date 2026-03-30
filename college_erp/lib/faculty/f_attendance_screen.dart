import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../models/faculty_models.dart';

class FAttendanceScreen extends StatefulWidget {
  const FAttendanceScreen({super.key});
  @override
  State<FAttendanceScreen> createState() => _FAttendanceScreenState();
}

class _FAttendanceScreenState extends State<FAttendanceScreen> {
  String _selectedSubject = FacultyData.subjects.first;
  // today's attendance: studentId -> present?
  late Map<String, bool> _todayAttendance;

  @override
  void initState() {
    super.initState();
    _resetAttendance();
  }

  void _resetAttendance() {
    _todayAttendance = {for (var s in FacultyData.students) s.id: true};
  }

  void _saveAttendance() {
    // append today's record into mock data
    for (var s in FacultyData.students) {
      FacultyData.attendanceData
          .putIfAbsent(s.id, () => {})
          .putIfAbsent(_selectedSubject, () => [])
          .add(_todayAttendance[s.id] ?? true);
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Attendance saved for $_selectedSubject!', style: GoogleFonts.nunito()),
      backgroundColor: AppTheme.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  int get presentCount => _todayAttendance.values.where((v) => v).length;

  double _getOverallPct(String studentId) {
    final subData = FacultyData.attendanceData[studentId]?[_selectedSubject];
    if (subData == null || subData.isEmpty) return 0;
    return (subData.where((b) => b).length / subData.length) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Subject selector + stats bar
      Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          // Subject chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: FacultyData.subjects.map((sub) {
                final sel = sub == _selectedSubject;
                return GestureDetector(
                  onTap: () => setState(() {
                    _selectedSubject = sub;
                    _resetAttendance();
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
          // Stats row
          Row(children: [
            _StatPill('Present', '$presentCount', AppTheme.primaryLight, AppTheme.primaryDark),
            const SizedBox(width: 8),
            _StatPill('Absent', '${FacultyData.students.length - presentCount}',
                const Color(0xFFFCEBEB), const Color(0xFFA32D2D)),
            const SizedBox(width: 8),
            _StatPill('Total', '${FacultyData.students.length}',
                const Color(0xFFE6F1FB), const Color(0xFF185FA5)),
            const Spacer(),
            // Mark all present/absent
            GestureDetector(
              onTap: () => setState(() { for (var k in _todayAttendance.keys) _todayAttendance[k] = true; }),
              child: Text('All P', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primary)),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => setState(() { for (var k in _todayAttendance.keys) _todayAttendance[k] = false; }),
              child: Text('All A', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFFE24B4A))),
            ),
          ]),
        ]),
      ),
      Container(height: 1, color: AppTheme.border),

      // Student list
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: FacultyData.students.length,
          itemBuilder: (ctx, i) {
            final s = FacultyData.students[i];
            final present = _todayAttendance[s.id] ?? true;
            final overallPct = _getOverallPct(s.id);

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: present ? AppTheme.border : const Color(0xFFF7C1C1),
                  width: 0.8,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(children: [
                // Avatar
                Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                    color: present ? AppTheme.primary : const Color(0xFFE24B4A),
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Text(s.initials,
                      style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white))),
                ),
                const SizedBox(width: 12),
                // Name + overall
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(s.name, style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                  const SizedBox(height: 2),
                  Row(children: [
                    Text(s.rollNo, style: GoogleFonts.nunito(fontSize: 11, color: AppTheme.textSecondary)),
                    const SizedBox(width: 8),
                    Text('Overall: ${overallPct.toStringAsFixed(0)}%',
                        style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w600,
                            color: overallPct >= 75 ? AppTheme.primary : const Color(0xFFE24B4A))),
                  ]),
                ])),
                // P / A toggle
                Row(children: [
                  _AttBtn('P', present, AppTheme.primary, const Color(0xFF9FE1CB), () => setState(() => _todayAttendance[s.id] = true)),
                  const SizedBox(width: 6),
                  _AttBtn('A', !present, const Color(0xFFE24B4A), const Color(0xFFF7C1C1), () => setState(() => _todayAttendance[s.id] = false)),
                ]),
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
            onPressed: _saveAttendance,
            icon: const Icon(Icons.save_outlined, size: 20),
            label: Text('Save Attendance · $_selectedSubject', style: GoogleFonts.nunito(fontWeight: FontWeight.w700, fontSize: 14)),
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

class _StatPill extends StatelessWidget {
  final String label, value;
  final Color bg, fg;
  const _StatPill(this.label, this.value, this.bg, this.fg);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text('$label: $value', style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w600, color: fg)),
    );
  }
}

class _AttBtn extends StatelessWidget {
  final String label;
  final bool active;
  final Color activeColor, activeBg;
  final VoidCallback onTap;
  const _AttBtn(this.label, this.active, this.activeColor, this.activeBg, this.onTap);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: active ? activeBg : AppTheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: active ? activeColor : AppTheme.border, width: active ? 1.5 : 0.8),
        ),
        child: Center(child: Text(label, style: GoogleFonts.nunito(
            fontSize: 13, fontWeight: FontWeight.w700,
            color: active ? activeColor : AppTheme.textSecondary))),
      ),
    );
  }
}
