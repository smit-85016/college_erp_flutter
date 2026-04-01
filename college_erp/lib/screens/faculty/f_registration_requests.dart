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
        content: Text('$studentName approved!', style: GoogleFonts.nunito()),
        backgroundColor: AppTheme.primary,
      ));
    }
  }

  void _reject(BuildContext context, String requestId, String studentUid, String studentName) {
    final reasonCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Reject Registration', style: GoogleFonts.nunito(fontWeight: FontWeight.w700)),
        content: TextField(controller: reasonCtrl),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await AuthService.rejectStudent(requestId, studentUid, reasonCtrl.text);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Reject'),
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

        // 🔴 ERROR HANDLING (VERY IMPORTANT)
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        // ⏳ LOADING STATE
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // 📦 SAFE DATA HANDLING
        final docs = snapshot.data?.docs ?? [];

        // 📭 NO DATA
        if (docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.inbox, size: 50, color: Colors.grey),
                const SizedBox(height: 10),
                Text(
                  'No pending requests',
                  style: GoogleFonts.nunito(fontSize: 16),
                ),
              ],
            ),
          );
        }

        // ✅ SHOW LIST
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

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(name,
                        style: GoogleFonts.nunito(
                            fontSize: 16, fontWeight: FontWeight.bold)),

                    Text(roll, style: GoogleFonts.nunito(color: _blue)),

                    const SizedBox(height: 8),

                    Text("Dept: $dept | $sem"),
                    Text("Email: $email"),
                    Text("Phone: $phone"),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () =>
                                _reject(context, requestId, studentUid, name),
                            child: const Text("Reject"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () =>
                                _approve(context, requestId, studentUid, name),
                            child: const Text("Approve"),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}