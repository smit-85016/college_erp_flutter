import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../screens/login_screen.dart';
import 'faculty/f_dashboard_screen.dart';
import 'faculty/f_students_screen.dart';
import 'faculty/f_attendance_screen.dart';
import 'faculty/f_marks_screen.dart';
import 'faculty/f_notice_screen.dart';
import 'faculty/f_leave_screen.dart';

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
    {'icon': Icons.people_outline, 'activeIcon': Icons.people, 'label': 'My Students'},
    {'icon': Icons.calendar_today_outlined, 'activeIcon': Icons.calendar_today, 'label': 'Attendance'},
    {'icon': Icons.bar_chart_outlined, 'activeIcon': Icons.bar_chart, 'label': 'Marks Entry'},
    {'icon': Icons.campaign_outlined, 'activeIcon': Icons.campaign, 'label': 'Notice Board'},
    {'icon': Icons.event_note_outlined, 'activeIcon': Icons.event_note, 'label': 'Leave Management'},
  ];

  final List<Widget> _screens = const [
    FDashboardScreen(),
    FStudentsScreen(),
    FAttendanceScreen(),
    FMarksScreen(),
    FNoticeScreen(),
    FLeaveScreen(),
  ];

  void _onSelectMenu(int index) {
    setState(() => _selectedIndex = index);
    Navigator.pop(context);
  }

  void _logout() {
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        ]),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: _blueBg, borderRadius: BorderRadius.circular(20)),
            child: Text('Faculty', style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w600, color: _blue)),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              width: 34, height: 34,
              decoration: const BoxDecoration(color: _blue, shape: BoxShape.circle),
              child: Center(child: Text('SG',
                  style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white))),
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
          child: Column(children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              color: _blue,
              child: Row(children: [
                Container(
                  width: 52, height: 52,
                  decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                  child: Center(child: Text('SG',
                      style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white))),
                ),
                const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Asst. Prof. Shikhashree Gayan',
                      style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                  Text('Mobile App Dev · IT Dept.',
                      style: GoogleFonts.nunito(fontSize: 11, color: Colors.white70)),
                  Text('JG University',
                      style: GoogleFonts.nunito(fontSize: 11, color: Colors.white60)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
                    child: Text('Faculty', style: GoogleFonts.nunito(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ]),
              ]),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: _navItems.length,
                itemBuilder: (ctx, i) {
                  final selected = i == _selectedIndex;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 2),
                    decoration: BoxDecoration(
                      color: selected ? _blueBg : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Icon(
                        selected ? _navItems[i]['activeIcon'] as IconData : _navItems[i]['icon'] as IconData,
                        color: selected ? _blue : AppTheme.textSecondary,
                        size: 22,
                      ),
                      title: Text(_navItems[i]['label'],
                          style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                              color: selected ? _blue : AppTheme.textPrimary)),
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
              title: Text('Logout', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFFE24B4A))),
              onTap: _logout,
            ),
            const SizedBox(height: 8),
          ]),
        ),
      ),

      body: _screens[_selectedIndex],
    );
  }
}
