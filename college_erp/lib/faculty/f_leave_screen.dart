import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../models/faculty_models.dart';

class FLeaveScreen extends StatefulWidget {
  const FLeaveScreen({super.key});
  @override
  State<FLeaveScreen> createState() => _FLeaveScreenState();
}

class _FLeaveScreenState extends State<FLeaveScreen> {
  void _applyLeave() {
    final fromCtrl = TextEditingController();
    final toCtrl = TextEditingController();
    final reasonCtrl = TextEditingController();

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
              Text('Apply for leave',
                  style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
              const Spacer(),
              IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
            ]),
            const SizedBox(height: 16),
            _LeaveField('From date (e.g. 01 Apr 2026)', fromCtrl),
            _LeaveField('To date (e.g. 03 Apr 2026)', toCtrl),
            _LeaveField('Reason for leave', reasonCtrl, maxLines: 3),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity, height: 48,
              child: ElevatedButton(
                onPressed: () {
                  if (fromCtrl.text.isNotEmpty && reasonCtrl.text.isNotEmpty) {
                    setState(() {
                      FacultyData.leaves.insert(0, LeaveApplication(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        facultyName: 'Asst. Prof. Shikhashree Gayan',
                        fromDate: fromCtrl.text,
                        toDate: toCtrl.text.isEmpty ? fromCtrl.text : toCtrl.text,
                        reason: reasonCtrl.text,
                        appliedOn: '28 Mar 2026',
                        status: LeaveStatus.pending,
                      ));
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Leave application submitted!', style: GoogleFonts.nunito()),
                      backgroundColor: AppTheme.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary, foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text('Submit Application', style: GoogleFonts.nunito(fontWeight: FontWeight.w700, fontSize: 15)),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Color _statusBg(LeaveStatus s) => switch (s) {
        LeaveStatus.pending => const Color(0xFFFAEEDA),
        LeaveStatus.approved => AppTheme.primaryLight,
        LeaveStatus.rejected => const Color(0xFFFCEBEB),
      };

  Color _statusFg(LeaveStatus s) => switch (s) {
        LeaveStatus.pending => const Color(0xFF854F0B),
        LeaveStatus.approved => AppTheme.primaryDark,
        LeaveStatus.rejected => const Color(0xFFA32D2D),
      };

  String _statusLabel(LeaveStatus s) => switch (s) {
        LeaveStatus.pending => 'Pending',
        LeaveStatus.approved => 'Approved',
        LeaveStatus.rejected => 'Rejected',
      };

  IconData _statusIcon(LeaveStatus s) => switch (s) {
        LeaveStatus.pending => Icons.hourglass_empty,
        LeaveStatus.approved => Icons.check_circle_outline,
        LeaveStatus.rejected => Icons.cancel_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final pending = FacultyData.leaves.where((l) => l.status == LeaveStatus.pending).length;
    final approved = FacultyData.leaves.where((l) => l.status == LeaveStatus.approved).length;

    return Column(children: [
      // Stats + apply button
      Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Row(children: [
            _LeaveStat('Total Applied', '${FacultyData.leaves.length}'),
            const SizedBox(width: 12),
            _LeaveStat('Approved', '$approved'),
            const SizedBox(width: 12),
            _LeaveStat('Pending', '$pending'),
          ]),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity, height: 44,
            child: ElevatedButton.icon(
              onPressed: _applyLeave,
              icon: const Icon(Icons.add, size: 18),
              label: Text('Apply for Leave', style: GoogleFonts.nunito(fontWeight: FontWeight.w700, fontSize: 14)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),
        ]),
      ),
      Container(height: 1, color: AppTheme.border),

      // Leave list
      Expanded(
        child: FacultyData.leaves.isEmpty
            ? Center(child: Text('No leave applications', style: GoogleFonts.nunito(color: AppTheme.textSecondary)))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: FacultyData.leaves.length,
                itemBuilder: (ctx, i) {
                  final l = FacultyData.leaves[i];
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
                        Expanded(
                          child: Text(l.reason,
                              style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: _statusBg(l.status), borderRadius: BorderRadius.circular(20)),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Icon(_statusIcon(l.status), size: 12, color: _statusFg(l.status)),
                            const SizedBox(width: 4),
                            Text(_statusLabel(l.status),
                                style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w600, color: _statusFg(l.status))),
                          ]),
                        ),
                      ]),
                      const SizedBox(height: 10),
                      Row(children: [
                        _DateChip(Icons.calendar_today_outlined, 'From', l.fromDate),
                        const SizedBox(width: 12),
                        _DateChip(Icons.calendar_today_outlined, 'To', l.toDate),
                      ]),
                      const SizedBox(height: 8),
                      Text('Applied on: ${l.appliedOn}',
                          style: GoogleFonts.nunito(fontSize: 11, color: AppTheme.textSecondary)),
                    ]),
                  );
                },
              ),
      ),
    ]);
  }
}

class _LeaveStat extends StatelessWidget {
  final String label, value;
  const _LeaveStat(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(10)),
        child: Column(children: [
          Text(value, style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          Text(label, style: GoogleFonts.nunito(fontSize: 11, color: AppTheme.textSecondary), textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  final IconData icon;
  final String label, date;
  const _DateChip(this.icon, this.label, this.date);
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, size: 13, color: AppTheme.textSecondary),
      const SizedBox(width: 4),
      Text('$label: ', style: GoogleFonts.nunito(fontSize: 12, color: AppTheme.textSecondary)),
      Text(date, style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
    ]);
  }
}

Widget _LeaveField(String hint, TextEditingController ctrl, {int maxLines = 1}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(
      controller: ctrl,
      maxLines: maxLines,
      style: GoogleFonts.nunito(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.nunito(fontSize: 13, color: AppTheme.textSecondary),
        filled: true, fillColor: AppTheme.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppTheme.border, width: 0.8)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppTheme.border, width: 0.8)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppTheme.primary, width: 1.5)),
      ),
    ),
  );
}
