import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';

class FStudentsScreen extends StatefulWidget {
  final String facultyId;
  const FStudentsScreen({super.key, required this.facultyId});
  @override
  State<FStudentsScreen> createState() => _FStudentsScreenState();
}

class _FStudentsScreenState extends State<FStudentsScreen> {
  String _query = '';
  final _searchCtrl = TextEditingController();

  void _viewProfile(BuildContext context, Map<String, dynamic> data) {
    final name = data['name'] ?? '';
    final initials = name.split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join();
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
            decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
            child: Center(child: Text(initials,
                style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white))),
          ),
          const SizedBox(height: 12),
          Text(name, style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          Text(data['rollNo'] ?? '', style: GoogleFonts.nunito(fontSize: 13, color: AppTheme.textSecondary)),
          const SizedBox(height: 20),
          _ProfileRow(Icons.school, 'Department', '${data['department'] ?? ''} · ${data['semester'] ?? ''}'),
          _ProfileRow(Icons.email_outlined, 'Email', data['email'] ?? ''),
          _ProfileRow(Icons.phone_outlined, 'Phone', data['phone'] ?? ''),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Search bar
      Padding(
        padding: const EdgeInsets.all(16),
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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.border, width: 0.8)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.border, width: 0.8)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primary, width: 1.5)),
          ),
        ),
      ),

      // Live list from Firestore
      Expanded(
        child: StreamBuilder<QuerySnapshot>(
          stream: AuthService.getFacultyStudents(widget.facultyId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final allDocs = snapshot.data?.docs ?? [];
            final docs = _query.isEmpty
                ? allDocs
                : allDocs.where((d) {
                    final data = d.data() as Map<String, dynamic>;
                    return (data['name'] ?? '').toLowerCase().contains(_query) ||
                        (data['rollNo'] ?? '').toLowerCase().contains(_query);
                  }).toList();

            if (docs.isEmpty) {
              return Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.people_outline, size: 48, color: AppTheme.textSecondary),
                  const SizedBox(height: 12),
                  Text(_query.isNotEmpty ? 'No students match your search' : 'No approved students yet',
                      style: GoogleFonts.nunito(color: AppTheme.textSecondary)),
                ]),
              );
            }

            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('${docs.length} students',
                    style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: docs.length,
                  itemBuilder: (ctx, i) {
                    final data = docs[i].data() as Map<String, dynamic>;
                    final name = data['name'] ?? '';
                    final initials = name.split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join();

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
                          decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                          child: Center(child: Text(initials,
                              style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white))),
                        ),
                        title: Text(name, style: GoogleFonts.nunito(
                            fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                        subtitle: Text('${data['rollNo'] ?? ''} · ${data['department'] ?? ''} · ${data['semester'] ?? ''}',
                            style: GoogleFonts.nunito(fontSize: 12, color: AppTheme.textSecondary)),
                        trailing: IconButton(
                          icon: const Icon(Icons.visibility_outlined, size: 20, color: Color(0xFF185FA5)),
                          onPressed: () => _viewProfile(context, data),
                          tooltip: 'View profile',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ]);
          },
        ),
      ),
    ]);
  }
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
        SizedBox(width: 90, child: Text(label,
            style: GoogleFonts.nunito(fontSize: 13, color: AppTheme.textSecondary))),
        Expanded(child: Text(value,
            style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary))),
      ]),
    );
  }
}
