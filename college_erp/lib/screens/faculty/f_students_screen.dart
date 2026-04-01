import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../models/faculty_models.dart';

class FStudentsScreen extends StatefulWidget {
  const FStudentsScreen({super.key});
  @override
  State<FStudentsScreen> createState() => _FStudentsScreenState();
}

class _FStudentsScreenState extends State<FStudentsScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  List<FacultyStudent> get filtered => FacultyData.students
      .where((s) =>
          s.name.toLowerCase().contains(_query) ||
          s.rollNo.toLowerCase().contains(_query))
      .toList();

  void _addStudent() {
    final nameCtrl = TextEditingController();
    final rollCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final cgpaCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            left: 20, right: 20, top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text('Add new student',
                  style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
              const Spacer(),
              IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
            ]),
            const SizedBox(height: 16),
            _ModalField('Full Name', nameCtrl, TextInputType.name),
            _ModalField('Roll Number', rollCtrl, TextInputType.text),
            _ModalField('Email', emailCtrl, TextInputType.emailAddress),
            _ModalField('Phone', phoneCtrl, TextInputType.phone),
            _ModalField('CGPA', cgpaCtrl, TextInputType.number),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  if (nameCtrl.text.isNotEmpty && rollCtrl.text.isNotEmpty) {
                    setState(() {
                      FacultyData.students.add(FacultyStudent(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: nameCtrl.text,
                        rollNo: rollCtrl.text,
                        email: emailCtrl.text,
                        phone: phoneCtrl.text,
                        cgpa: double.tryParse(cgpaCtrl.text) ?? 0.0,
                        semester: 'Sem 6',
                        department: 'IT',
                      ));
                    });
                    Navigator.pop(ctx);
                    _showSnack('Student added successfully!', AppTheme.primary);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text('Add Student', style: GoogleFonts.nunito(fontWeight: FontWeight.w700, fontSize: 15)),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void _removeStudent(FacultyStudent student) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Remove Student', style: GoogleFonts.nunito(fontWeight: FontWeight.w700)),
        content: Text('Remove ${student.name} from your class?', style: GoogleFonts.nunito()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel', style: GoogleFonts.nunito(color: AppTheme.textSecondary))),
          TextButton(
            onPressed: () {
              setState(() => FacultyData.students.removeWhere((s) => s.id == student.id));
              Navigator.pop(ctx);
              _showSnack('${student.name} removed.', const Color(0xFFE24B4A));
            },
            child: Text('Remove', style: GoogleFonts.nunito(color: const Color(0xFFE24B4A), fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _viewProfile(FacultyStudent student) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
            child: Center(child: Text(student.initials,
                style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white))),
          ),
          const SizedBox(height: 12),
          Text(student.name, style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          Text(student.rollNo, style: GoogleFonts.nunito(fontSize: 13, color: AppTheme.textSecondary)),
          const SizedBox(height: 20),
          _ProfileRow(Icons.school, 'Department', '${student.department} · ${student.semester}'),
          _ProfileRow(Icons.email_outlined, 'Email', student.email),
          _ProfileRow(Icons.phone_outlined, 'Phone', student.phone),
          _ProfileRow(Icons.bar_chart, 'CGPA', '${student.cgpa}'),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: GoogleFonts.nunito()),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Search + Add
      Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Expanded(
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v.toLowerCase()),
              style: GoogleFonts.nunito(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search by name or roll no...',
                hintStyle: GoogleFonts.nunito(fontSize: 13, color: AppTheme.textSecondary),
                prefixIcon: const Icon(Icons.search, size: 20, color: AppTheme.textSecondary),
                filled: true, fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.border, width: 0.8)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.border, width: 0.8)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.primary, width: 1.5)),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _addStudent,
            child: Container(
              width: 46, height: 46,
              decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.person_add, color: Colors.white, size: 22),
            ),
          ),
        ]),
      ),

      // Count
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(children: [
          Text('${filtered.length} students',
              style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
        ]),
      ),
      const SizedBox(height: 8),

      // List
      Expanded(
        child: filtered.isEmpty
            ? Center(child: Text('No students found', style: GoogleFonts.nunito(color: AppTheme.textSecondary)))
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filtered.length,
                itemBuilder: (ctx, i) {
                  final s = filtered[i];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppTheme.border, width: 0.8),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      leading: Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                        child: Center(child: Text(s.initials,
                            style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white))),
                      ),
                      title: Text(s.name, style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                      subtitle: Text('${s.rollNo} · CGPA: ${s.cgpa}',
                          style: GoogleFonts.nunito(fontSize: 12, color: AppTheme.textSecondary)),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(
                          icon: const Icon(Icons.visibility_outlined, size: 20, color: Color(0xFF185FA5)),
                          onPressed: () => _viewProfile(s),
                          tooltip: 'View profile',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20, color: Color(0xFFE24B4A)),
                          onPressed: () => _removeStudent(s),
                          tooltip: 'Remove student',
                        ),
                      ]),
                    ),
                  );
                },
              ),
      ),
    ]);
  }
}

Widget _ModalField(String label, TextEditingController ctrl, TextInputType type) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(
      controller: ctrl,
      keyboardType: type,
      style: GoogleFonts.nunito(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.nunito(fontSize: 13, color: AppTheme.textSecondary),
        filled: true, fillColor: AppTheme.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppTheme.border, width: 0.8)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppTheme.border, width: 0.8)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppTheme.primary, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    ),
  );
}

class _ProfileRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _ProfileRow(this.icon, this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(children: [
        Icon(icon, size: 18, color: AppTheme.textSecondary),
        const SizedBox(width: 12),
        SizedBox(width: 90, child: Text(label, style: GoogleFonts.nunito(fontSize: 13, color: AppTheme.textSecondary))),
        Expanded(child: Text(value, style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary))),
      ]),
    );
  }
}
