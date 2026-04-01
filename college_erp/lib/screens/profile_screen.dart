import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_theme.dart';
import '../providers/current_user.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _extraData;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final uid = currentUser.uid;
    if (uid.isEmpty) { setState(() => _loading = false); return; }
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists && mounted) {
        setState(() { _extraData = doc.data(); _loading = false; });
      } else {
        setState(() => _loading = false);
      }
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: currentUser,
      builder: (context, _) {
        if (_loading) {
          return const Center(child: CircularProgressIndicator());
        }

        final name = currentUser.name.isNotEmpty ? currentUser.name : (_extraData?['name'] ?? 'Student');
        final email = currentUser.email.isNotEmpty ? currentUser.email : (_extraData?['email'] ?? '');
        final rollNo = currentUser.rollNo.isNotEmpty ? currentUser.rollNo : (_extraData?['rollNo'] ?? '');
        final dept = currentUser.department.isNotEmpty ? currentUser.department : (_extraData?['department'] ?? '');
        final sem = currentUser.semester.isNotEmpty ? currentUser.semester : (_extraData?['semester'] ?? '');
        final phone = _extraData?['phone'] ?? '';
        final initials = currentUser.initials;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            // Avatar card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(children: [
                  Container(
                    width: 64, height: 64,
                    decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                    child: Center(child: Text(initials,
                        style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white))),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(name, style: GoogleFonts.nunito(
                        fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                    Text('$dept · $sem',
                        style: GoogleFonts.nunito(fontSize: 13, color: AppTheme.textSecondary)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: AppTheme.primaryLight, borderRadius: BorderRadius.circular(20)),
                      child: Text('Active · $sem',
                          style: GoogleFonts.nunito(fontSize: 11,
                              fontWeight: FontWeight.w600, color: AppTheme.primaryDark)),
                    ),
                  ])),
                ]),
              ),
            ),
            const SizedBox(height: 12),

            // Details card — all from Firebase
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  _InfoRow('Enrollment No.', rollNo.isNotEmpty ? rollNo : '—'),
                  _InfoRow('Department', dept.isNotEmpty ? dept : '—'),
                  _InfoRow('Semester', sem.isNotEmpty ? sem : '—'),
                  _InfoRow('Email', email.isNotEmpty ? email : '—'),
                  _InfoRow('Mobile', phone.isNotEmpty ? phone : '—', isLast: true),
                ]),
              ),
            ),
          ]),
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  final bool isLast;
  const _InfoRow(this.label, this.value, {this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(children: [
          SizedBox(width: 130, child: Text(label,
              style: GoogleFonts.nunito(fontSize: 13, color: AppTheme.textSecondary))),
          Expanded(child: Text(value, style: GoogleFonts.nunito(
              fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.textPrimary))),
        ]),
      ),
      if (!isLast) const Divider(height: 1, color: AppTheme.border),
    ]);
  }
}
