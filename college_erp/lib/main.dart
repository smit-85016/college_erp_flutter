import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

import 'theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/attendance_screen.dart';
import 'screens/timetable_screen.dart';
import 'screens/marks_screen.dart';
import 'screens/notice_board_screen.dart';
import 'screens/faculty_screen.dart';
import 'firebase_options.dart';

// 👉 ADD THIS (your animated splash)
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const CollegeERPApp());
}

class CollegeERPApp extends StatelessWidget {
  const CollegeERPApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus ERP – JG University',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      // 🔥 START FROM SPLASH
      home: SplashScreen(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _navItems = [
    {
      'icon': Icons.dashboard_outlined,
      'activeIcon': Icons.dashboard,
      'label': 'Dashboard'
    },
    {
      'icon': Icons.person_outline,
      'activeIcon': Icons.person,
      'label': 'Student Profile'
    },
    {
      'icon': Icons.calendar_today_outlined,
      'activeIcon': Icons.calendar_today,
      'label': 'Attendance'
    },
    {
      'icon': Icons.schedule_outlined,
      'activeIcon': Icons.schedule,
      'label': 'Timetable'
    },
    {
      'icon': Icons.bar_chart_outlined,
      'activeIcon': Icons.bar_chart,
      'label': 'Marks & Results'
    },
    {
      'icon': Icons.campaign_outlined,
      'activeIcon': Icons.campaign,
      'label': 'Notice Board'
    },
    {
      'icon': Icons.people_outline,
      'activeIcon': Icons.people,
      'label': 'Faculty'
    },
  ];

  final List<Widget> _screens = const [
    DashboardScreen(),
    ProfileScreen(),
    AttendanceScreen(),
    TimetableScreen(),
    MarksScreen(),
    NoticeBoardScreen(),
    FacultyScreen(),
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
          builder: (context) => IconButton(
            icon: Icon(
              _navItems[_selectedIndex]['activeIcon'],
              color: AppTheme.textPrimary,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
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
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = 1;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: AppTheme.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  'SS',
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
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
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  color: AppTheme.primary,
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Colors.white24,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            'SS',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Smit Shah',
                              style: GoogleFonts.nunito(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                          Text('B.Tech IT · Sem 6',
                              style: GoogleFonts.nunito(
                                  fontSize: 12, color: Colors.white70)),
                          Text('JG University',
                              style: GoogleFonts.nunito(
                                  fontSize: 11, color: Colors.white60)),
                        ],
                      ),
                    ],
                  ),
                ),
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
                        color: selected
                            ? AppTheme.primaryLight
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: Icon(
                          selected
                              ? _navItems[i]['activeIcon']
                              : _navItems[i]['icon'],
                          color: selected
                              ? AppTheme.primary
                              : AppTheme.textSecondary,
                        ),
                        title: Text(
                          _navItems[i]['label'],
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight:
                                selected ? FontWeight.w700 : FontWeight.w500,
                            color: selected
                                ? AppTheme.primaryDark
                                : AppTheme.textPrimary,
                          ),
                        ),
                        onTap: () => _onSelectMenu(i),
                      ),
                    );
                  },
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout,
                    color: Color(0xFFE24B4A), size: 22),
                title: Text(
                  'Logout',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFE24B4A),
                  ),
                ),
                onTap: _logout,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      body: _screens[_selectedIndex],
    );
  }
}
