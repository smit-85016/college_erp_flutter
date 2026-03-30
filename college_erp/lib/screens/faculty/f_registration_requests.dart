import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';

class FRegistrationRequestsScreen extends StatelessWidget {
  final String facultyId;
  const FRegistrationRequestsScreen({super.key, required this.facultyId});

  static const _blue = Color(0xFF185FA5);

  void _approve(BuildContext context, String requestId, String studentUid, String studentName) async {
    await AuthService.approveStudent(requestId, studentUid);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('$studentName approved! They can now login.', style: GoogleFonts.nunito()),
        backgroundColor: AppTheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    }
  }

  void _reject(BuildContext context, String requestId, String studentUid, String studentName) {
    final reasonCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Reject Registration', style: GoogleFonts.nunito(fontWeight: FontWeight.w700)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Reason for rejecting $studentName?', style: GoogleFonts.nunito(fontSize: 13, color: AppTheme.textSecondary)),
          const SizedBox(height: 12),
          TextField(
            controller: reasonCtrl,
            style: GoogleFonts.nunito(fontSize: 14),
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Enter reason (optional)',
              hintStyle: GoogleFonts.nunito(color: AppTheme.textSecondary, fontSize: 13),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel', style: GoogleFonts.nunito(color: AppTheme.textSecondary))),
          TextButton(
            onPressed: () async {
              await AuthService.rejectStudent(requestId, studentUid, reasonCtrl.text);
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('$studentName rejected.', style: GoogleFonts.nunito()),
                  backgroundColor: const Color(0xFFE24B4A),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ));
              }
            },
            child: Text('Reject', style: GoogleFonts.nunito(
                fontWeight: FontWeight.w700, color: const Color(0xFFE24B4A))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: AuthService.getPendingRequests(facultyId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 72, height: 72,
                decoration: BoxDecoration(color: AppTheme.primaryLight, shape: BoxShape.circle),
                child: Icon(Icons.check_circle_outline, size: 36, color: AppTheme.primary),
              ),
              const SizedBox(height: 16),
              Text('No pending requests', style: GoogleFonts.nunito(
                  fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
              const SizedBox(height: 8),
              Text('All student registrations are reviewed.',
                  style: GoogleFonts.nunito(fontSize: 13, color: AppTheme.textSecondary)),
            ]),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (ctx, i) {
            final data = docs[i].data() as Map<String, dynamic>;
            final requestId = docs[i].id;
            final studentUid = data['studentUid'] ?? '';
            final name = data['studentName'] ?? '';
            final roll = data['rollNo'] ?? '';
            final email = data['studentEmail'] ?? '';
            final phone = data['phone'] ?? '';
            final dept = data['department'] ?? '';
            final sem = data['semester'] ?? '';
            final initials = name.split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join();

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppTheme.border, width: 0.8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAEEDA),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFEF9F27), borderRadius: BorderRadius.circular(20)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.hourglass_empty, size: 12, color: Colors.white),
                        const SizedBox(width: 4),
                        Text('Pending Approval', style: GoogleFonts.nunito(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
                      ]),
                    ),
                    const Spacer(),
                    Text('New Registration', style: GoogleFonts.nunito(fontSize: 11, color: const Color(0xFF854F0B))),
                  ]),
                ),

                // Student details
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Container(
                        width: 50, height: 50,
                        decoration: BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                        child: Center(child: Text(initials,
                            style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white))),
                      ),
                      const SizedBox(width: 14),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(name, style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                        Text(roll, style: GoogleFonts.nunito(fontSize: 13, color: _blue, fontWeight: FontWeight.w600)),
                      ])),
                    ]),
                    const SizedBox(height: 14),
                    const Divider(height: 1, color: AppTheme.border),
                    const SizedBox(height: 14),

                    _DetailRow(Icons.school_outlined, 'Department', '$dept · $sem'),
                    _DetailRow(Icons.email_outlined, 'Email', email),
                    _DetailRow(Icons.phone_outlined, 'Phone', phone),
                  ]),
                ),

                // Action buttons
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Row(children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _reject(context, requestId, studentUid, name),
                        icon: const Icon(Icons.close, size: 16, color: Color(0xFFE24B4A)),
                        label: Text('Reject', style: GoogleFonts.nunito(
                            fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFFE24B4A))),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE24B4A), width: 1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _approve(context, requestId, studentUid, name),
                        icon: const Icon(Icons.check, size: 16),
                        label: Text('Approve', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary, foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ]),
                ),
              ]),
            );
          },
        );
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _DetailRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(children: [
        Icon(icon, size: 16, color: AppTheme.textSecondary),
        const SizedBox(width: 8),
        SizedBox(width: 80, child: Text(label,
            style: GoogleFonts.nunito(fontSize: 12, color: AppTheme.textSecondary))),
        Expanded(child: Text(value,
            style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary))),
      ]),
    );
  }
}
