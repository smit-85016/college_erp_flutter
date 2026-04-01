import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../theme/app_theme.dart';
import '../screens/login_screen.dart';
import '../services/auth_service.dart';

// ✅ ADD ALL REQUIRED IMPORTS
import 'package:college_erp/faculty/f_dashboard_screen.dart';
import 'faculty/f_students_screen.dart';
import 'package:college_erp/faculty/f_attendance_screen.dart';
import 'package:college_erp/faculty/f_marks_screen.dart';
import 'package:college_erp/faculty/f_notice_screen.dart';
import 'package:college_erp/faculty/f_leave_screen.dart';
import 'package:college_erp/screens/faculty/f_registration_requests.dart';
import 'package:college_erp/faculty/f_attendance_screen.dart';

class FacultyDashboardScreen extends StatefulWidget {
  const FacultyDashboardScreen({super.key});

  @override
  State<FacultyDashboardScreen> createState() =>
      _FacultyDashboardScreenState();
}

class _FacultyDashboardScreenState extends State<FacultyDashboardScreen> {
  int _selectedIndex = 0;
  AppUser? _facultyUser;

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

  @override
  void initState() {
    super.initState();
    _loadFacultyUser();
  }

  void _loadFacultyUser() async {
    final uid = AuthService.currentUser?.uid;
    if (uid == null) return;

    final user = await AuthService.getAppUser(uid);
    if (mounted) {
      setState(() {
        _facultyUser = user;
      });
    }
  }

  void _onSelectMenu(int index) {
    setState(() => _selectedIndex = index);
    Navigator.pop(context);
  }

  void _logout() async {
    Navigator.pop(context);
    await AuthService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  // ✅ SAFE SCREEN BUILDER
    Widget _buildScreen() {
  if (_facultyUser == null) {
    return const Center(child: CircularProgressIndicator());
  }

   final facultyId = _facultyUser!.uid;

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
    final facultyId =
        _facultyUser?.uid ?? AuthService.currentUser?.uid ?? '';

    final initials = _facultyUser?.name
            .split(' ')
            .map((w) => w.isNotEmpty ? w[0] : '')
            .take(2)
            .join() ??
        'SG';

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: Icon(
              _navItems[_selectedIndex]['activeIcon'],
              color: AppTheme.textPrimary,
            ),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  color: _blue, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.school, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            Text(
              _navItems[_selectedIndex]['label'],
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
                color: _blueBg, borderRadius: BorderRadius.circular(20)),
            child: Text(
              'Faculty',
              style: GoogleFonts.nunito(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _blue,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            width: 34,
            height: 34,
            decoration:
                const BoxDecoration(color: _blue, shape: BoxShape.circle),
            child: Center(
              child: Text(
                initials,
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
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
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 24),
                color: _blue,
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                          color: Colors.white24,
                          shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          initials,
                          style: GoogleFonts.nunito(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _facultyUser?.name ?? 'Faculty',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: _navItems.length,
                  itemBuilder: (ctx, i) {
                    final selected = i == _selectedIndex;

                    return ListTile(
                      leading: Icon(
                        selected
                            ? _navItems[i]['activeIcon']
                            : _navItems[i]['icon'],
                        color: selected
                            ? _blue
                            : AppTheme.textSecondary,
                      ),
                      title: Text(
                        _navItems[i]['label'],
                        style: GoogleFonts.nunito(
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                      onTap: () => _onSelectMenu(i),
                    );
                  },
                ),
              ),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.logout,
                    color: Color(0xFFE24B4A)),
                title: const Text('Logout'),
                onTap: _logout,
              ),
            ],
          ),
        ),
      ),

      body: _buildScreen(),
    );
  }
}