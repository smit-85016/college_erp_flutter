import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_theme.dart';
import '../screens/login_screen.dart';
import '../services/auth_service.dart';
import '../providers/current_user.dart';
import 'package:college_erp/faculty/f_dashboard_screen.dart';
import 'package:college_erp/faculty/f_students_screen.dart';
import 'package:college_erp/faculty/f_attendance_screen.dart';
import 'package:college_erp/faculty/f_marks_screen.dart';
import 'package:college_erp/faculty/f_notice_screen.dart';
import 'package:college_erp/faculty/f_leave_screen.dart';
import 'faculty/f_registration_requests.dart';

class FacultyDashboardScreen extends StatefulWidget {
  const FacultyDashboardScreen({super.key});
  @override
  State<FacultyDashboardScreen> createState() => _FacultyDashboardScreenState();
}

class _FacultyDashboardScreenState extends State<FacultyDashboardScreen> {
  int _selectedIndex = 0;

  static const _blue = Color(0xFF185FA5);
  static const _blueBg = Color(0xFFE6F1FB);

  final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.dashboard_outlined, 'activeIcon': Icons.dashboard, 'label': 'Dashboard'},
    {'icon': Icons.how_to_reg_outlined, 'activeIcon': Icons.how_to_reg, 'label': 'Requests'},
    {'icon': Icons.people_outline, 'activeIcon': Icons.people, 'label': 'My Students'},
    {'icon': Icons.calendar_today_outlined, 'activeIcon': Icons.calendar_today, 'label': 'Attendance'},
    {'icon': Icons.bar_chart_outlined, 'activeIcon': Icons.bar_chart, 'label': 'Marks Entry'},
    {'icon': Icons.campaign_outlined, 'activeIcon': Icons.campaign, 'label': 'Notice Board'},
    {'icon': Icons.event_note_outlined, 'activeIcon': Icons.event_note, 'label': 'Leave Management'},
  ];

  void _onSelectMenu(int index) {
    setState(() => _selectedIndex = index);
    Navigator.pop(context);
  }

  void _logout() {
    Navigator.pop(context);
    AuthService.logout();
    currentUser.clear();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  Widget _buildScreen() {
    final facultyId = currentUser.uid;
    switch (_selectedIndex) {
      case 0: return const FDashboardScreen();
      case 1: return FRegistrationRequestsScreen(facultyId: facultyId);
      case 2: return FStudentsScreen(facultyId: facultyId);
      case 3: return const FAttendanceScreen();
      case 4: return const FMarksScreen();
      case 5: return const FNoticeScreen();
      case 6: return const FLeaveScreen();
      default: return const FDashboardScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: currentUser,
      builder: (context, _) {
        // All values come from the logged-in faculty — fully dynamic
        final name = currentUser.name.isNotEmpty ? currentUser.name : 'Faculty';
        final dept = currentUser.department.isNotEmpty ? currentUser.department : '';
        final initials = currentUser.initials;
        final facultyId = currentUser.uid;

        return Scaffold(
          appBar: AppBar(
            leading: Builder(
              builder: (ctx) => IconButton(
                icon: Icon(_navItems[_selectedIndex]['activeIcon'] as IconData,
                    color: AppTheme.textPrimary),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
            title: Row(children: [
              Container(
                width: 30, height: 30,
                decoration: BoxDecoration(color: _blue, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.school, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Text(_navItems[_selectedIndex]['label'],
                  style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary)),
            ]),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: _blueBg, borderRadius: BorderRadius.circular(20)),
                child: Text('Faculty', style: GoogleFonts.nunito(
                    fontSize: 11, fontWeight: FontWeight.w600, color: _blue)),
              ),
              // Dynamic faculty avatar
              Container(
                margin: const EdgeInsets.only(right: 16),
                width: 34, height: 34,
                decoration: const BoxDecoration(color: _blue, shape: BoxShape.circle),
                child: Center(child: Text(initials,
                    style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white))),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(height: 1, color: AppTheme.border),
            ),
          ),

          drawer: Drawer(
            backgroundColor: Colors.white,
            child: SafeArea(
              child: Column(children: [
                // Dynamic header — shows the logged-in faculty's real name
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  color: _blue,
                  child: Row(children: [
                    Container(
                      width: 52, height: 52,
                      decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                      child: Center(child: Text(initials,
                          style: GoogleFonts.nunito(
                              fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(name,
                            style: GoogleFonts.nunito(
                                fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(dept.isNotEmpty ? '$dept Dept.' : 'Faculty',
                            style: GoogleFonts.nunito(fontSize: 11, color: Colors.white70)),
                        Text('JG University',
                            style: GoogleFonts.nunito(fontSize: 11, color: Colors.white60)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                              color: Colors.white24, borderRadius: BorderRadius.circular(20)),
                          child: Text('Faculty',
                              style: GoogleFonts.nunito(
                                  fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white)),
                        ),
                      ]),
                    ),
                  ]),
                ),

                const SizedBox(height: 8),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: _navItems.length,
                    itemBuilder: (ctx, i) {
                      final selected = i == _selectedIndex;

                      Widget title = Text(_navItems[i]['label'],
                          style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                              color: selected ? _blue : AppTheme.textPrimary));

                      // Live badge on Requests item
                      if (i == 1 && facultyId.isNotEmpty) {
                        title = StreamBuilder<QuerySnapshot>(
                          stream: AuthService.getPendingRequests(facultyId),
                          builder: (ctx, snap) {
                            final count = snap.data?.docs.length ?? 0;
                            return Row(children: [
                              Text('Requests', style: GoogleFonts.nunito(
                                  fontSize: 14,
                                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                                  color: selected ? _blue : AppTheme.textPrimary)),
                              if (count > 0) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFEF9F27),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text('$count', style: GoogleFonts.nunito(
                                      fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
                                ),
                              ],
                            ]);
                          },
                        );
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 2),
                        decoration: BoxDecoration(
                          color: selected ? _blueBg : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: Icon(
                            selected
                                ? _navItems[i]['activeIcon'] as IconData
                                : _navItems[i]['icon'] as IconData,
                            color: selected ? _blue : AppTheme.textSecondary, size: 22,
                          ),
                          title: title,
                          onTap: () => _onSelectMenu(i),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    },
                  ),
                ),

                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Color(0xFFE24B4A), size: 22),
                  title: Text('Logout', style: GoogleFonts.nunito(
                      fontSize: 14, fontWeight: FontWeight.w600,
                      color: const Color(0xFFE24B4A))),
                  onTap: _logout,
                ),
                const SizedBox(height: 8),
              ]),
            ),
          ),

          body: _buildScreen(),
        );
      },
    );
  }
}
