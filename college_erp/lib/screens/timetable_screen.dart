import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  int _selectedDay = 0;
  final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

  final timetable = const [
    // Monday
    [
      {'time': '9–10 AM', 'subject': 'Mobile App Dev', 'loc': 'Lab 3', 'type': 'lab'},
      {'time': '10–11 AM', 'subject': 'Cloud Computing', 'loc': 'Room 201', 'type': 'theory'},
      {'time': '11–12 PM', 'subject': 'Break', 'loc': '', 'type': 'free'},
      {'time': '12–1 PM', 'subject': 'Data Science', 'loc': 'Room 105', 'type': 'math'},
      {'time': '2–3 PM', 'subject': 'Project Work', 'loc': 'Lab 1', 'type': 'math'},
    ],
    // Tuesday
    [
      {'time': '9–10 AM', 'subject': 'Data Science', 'loc': 'Room 105', 'type': 'math'},
      {'time': '10–11 AM', 'subject': 'Cybersecurity', 'loc': 'Room 203', 'type': 'lab'},
      {'time': '11–12 PM', 'subject': 'Break', 'loc': '', 'type': 'free'},
      {'time': '12–1 PM', 'subject': 'Entrepreneurship', 'loc': 'Room 301', 'type': 'theory'},
      {'time': '2–3 PM', 'subject': 'MAD Lab', 'loc': 'Lab 3', 'type': 'lab'},
    ],
    // Wednesday
    [
      {'time': '9–10 AM', 'subject': 'Cloud Computing', 'loc': 'Room 201', 'type': 'theory'},
      {'time': '10–11 AM', 'subject': 'Mobile App Dev', 'loc': 'Lab 3', 'type': 'lab'},
      {'time': '11–12 PM', 'subject': 'Break', 'loc': '', 'type': 'free'},
      {'time': '12–1 PM', 'subject': 'Cybersecurity', 'loc': 'Room 203', 'type': 'lab'},
      {'time': '2–3 PM', 'subject': 'Cloud Lab', 'loc': 'Lab 2', 'type': 'lab'},
    ],
    // Thursday
    [
      {'time': '9–10 AM', 'subject': 'Mobile App Dev', 'loc': 'Lab 3', 'type': 'lab'},
      {'time': '10–11 AM', 'subject': 'Cloud Computing', 'loc': 'Room 201', 'type': 'theory'},
      {'time': '11–12 PM', 'subject': 'Break', 'loc': '', 'type': 'free'},
      {'time': '12–1 PM', 'subject': 'Project Work', 'loc': 'Lab 1', 'type': 'math'},
      {'time': '2–4 PM', 'subject': 'Free / Self Study', 'loc': '', 'type': 'free'},
    ],
    // Friday
    [
      {'time': '9–10 AM', 'subject': 'Data Science', 'loc': 'Room 105', 'type': 'math'},
      {'time': '10–11 AM', 'subject': 'Cybersecurity', 'loc': 'Room 203', 'type': 'lab'},
      {'time': '11–12 PM', 'subject': 'Break', 'loc': '', 'type': 'free'},
      {'time': '12–1 PM', 'subject': 'Entrepreneurship', 'loc': 'Room 301', 'type': 'theory'},
      {'time': '2–3 PM', 'subject': 'Free / Self Study', 'loc': '', 'type': 'free'},
    ],
  ];

  Color _chipBg(String type) => switch (type) {
        'lab' => AppTheme.primaryLight,
        'theory' => const Color(0xFFE6F1FB),
        'math' => const Color(0xFFFAEEDA),
        _ => AppTheme.surface,
      };

  Color _chipFg(String type) => switch (type) {
        'lab' => AppTheme.primaryDark,
        'theory' => const Color(0xFF185FA5),
        'math' => const Color(0xFF854F0B),
        _ => AppTheme.textSecondary,
      };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Day selector
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            children: List.generate(5, (i) {
              final selected = i == _selectedDay;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedDay = i),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? AppTheme.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      days[i],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const Divider(height: 1, color: AppTheme.border),

        // Slots
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: timetable[_selectedDay].length,
            itemBuilder: (ctx, i) {
              final slot = timetable[_selectedDay][i];
              final isFree = slot['type'] == 'free';
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Time
                    SizedBox(
                      width: 80,
                      child: Text(slot['time']!,
                          style: GoogleFonts.nunito(
                              fontSize: 11,
                              color: AppTheme.textSecondary)),
                    ),
                    // Timeline dot
                    Column(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isFree ? AppTheme.border : AppTheme.primary,
                          ),
                        ),
                        if (i < timetable[_selectedDay].length - 1)
                          Container(
                            width: 1.5,
                            height: 60,
                            color: AppTheme.border,
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    // Card
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _chipBg(slot['type']!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(slot['subject']!,
                                  style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: _chipFg(slot['type']!),
                                  )),
                            ),
                            if (slot['loc']!.isNotEmpty)
                              Text(slot['loc']!,
                                  style: GoogleFonts.nunito(
                                      fontSize: 12,
                                      color: _chipFg(slot['type']!))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
