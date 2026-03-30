class Student {
  final String name;
  final String enrollmentNo;
  final String department;
  final String semester;
  final String email;
  final String phone;
  final String dob;
  final String advisor;
  final double cgpa;

  const Student({
    required this.name,
    required this.enrollmentNo,
    required this.department,
    required this.semester,
    required this.email,
    required this.phone,
    required this.dob,
    required this.advisor,
    required this.cgpa,
  });
}

class AttendanceRecord {
  final String subject;
  final int attended;
  final int total;

  const AttendanceRecord({
    required this.subject,
    required this.attended,
    required this.total,
  });

  double get percentage => (attended / total) * 100;
  bool get isSafe => percentage >= 75;
}

class TimetableSlot {
  final String day;
  final String time;
  final String subject;
  final String location;
  final SlotType type;

  const TimetableSlot({
    required this.day,
    required this.time,
    required this.subject,
    required this.location,
    required this.type,
  });
}

enum SlotType { lab, theory, math, free }

class SubjectResult {
  final String subject;
  final int marks;
  final int total;
  final String grade;

  const SubjectResult({
    required this.subject,
    required this.marks,
    required this.total,
    required this.grade,
  });
}

class Notice {
  final String title;
  final String body;
  final String date;
  final String issuedBy;
  final NoticeType type;

  const Notice({
    required this.title,
    required this.body,
    required this.date,
    required this.issuedBy,
    required this.type,
  });
}

enum NoticeType { exam, event, holiday, general }

class Faculty {
  final String name;
  final String designation;
  final String subject;
  final String email;
  final String initials;
  final int colorIndex;

  const Faculty({
    required this.name,
    required this.designation,
    required this.subject,
    required this.email,
    required this.initials,
    required this.colorIndex,
  });
}

// Mock data
class AppData {
  static const student = Student(
    name: 'Smit Shah',
    enrollmentNo: '22IT0045',
    department: 'Information Technology',
    semester: '6th Semester',
    email: 'smit.shah@jgu.ac.in',
    phone: '+91 98765 43210',
    dob: '12 August 2004',
    advisor: 'Asst. Prof. Shikhashree Gayan',
    cgpa: 8.4,
  );

  static const attendance = [
    AttendanceRecord(subject: 'Mobile App Dev', attended: 18, total: 20),
    AttendanceRecord(subject: 'Cloud Computing', attended: 16, total: 20),
    AttendanceRecord(subject: 'Data Science', attended: 17, total: 20),
    AttendanceRecord(subject: 'Cybersecurity', attended: 14, total: 20),
    AttendanceRecord(subject: 'Entrepreneurship', attended: 15, total: 20),
    AttendanceRecord(subject: 'Project Work', attended: 20, total: 20),
  ];

  static const results = [
    SubjectResult(subject: 'Operating Systems', marks: 87, total: 100, grade: 'A'),
    SubjectResult(subject: 'Computer Networks', marks: 81, total: 100, grade: 'A'),
    SubjectResult(subject: 'Database Systems', marks: 76, total: 100, grade: 'B'),
    SubjectResult(subject: 'Software Engineering', marks: 79, total: 100, grade: 'B'),
    SubjectResult(subject: 'Web Technologies', marks: 90, total: 100, grade: 'A+'),
    SubjectResult(subject: 'Microprocessors', marks: 68, total: 100, grade: 'B-'),
  ];

  static const notices = [
    Notice(
      title: 'Mid-semester exam schedule released',
      body: 'Mid-semester examination schedule for Sem 6 has been released. Exams begin April 7.',
      date: '27 Mar 2026',
      issuedBy: 'Academic Office',
      type: NoticeType.exam,
    ),
    Notice(
      title: 'Techfest 2026 registrations open',
      body: 'Techfest 2026 registrations are open. Last date to register is April 2.',
      date: '26 Mar 2026',
      issuedBy: 'Student Council',
      type: NoticeType.event,
    ),
    Notice(
      title: 'College holiday on March 31',
      body: 'College will remain closed on March 31 for the semester break.',
      date: '25 Mar 2026',
      issuedBy: 'Administration',
      type: NoticeType.holiday,
    ),
    Notice(
      title: 'Industry visit – Infosys Ahmedabad',
      body: 'Industry visit to Infosys Ahmedabad on April 5. Register before April 1.',
      date: '24 Mar 2026',
      issuedBy: 'Placement Cell',
      type: NoticeType.event,
    ),
    Notice(
      title: 'Project report deadline extended',
      body: 'Project report submission deadline extended to April 10.',
      date: '23 Mar 2026',
      issuedBy: 'Dept. of IT',
      type: NoticeType.exam,
    ),
  ];

  static const faculty = [
    Faculty(name: 'Asst. Prof. Shikhashree Gayan', designation: 'Assistant Professor', subject: 'Mobile App Dev · Project Guide', email: 'sg@jgu.ac.in', initials: 'SG', colorIndex: 0),
    Faculty(name: 'Prof. Rajesh Patel', designation: 'Professor', subject: 'Cloud Computing', email: 'rp@jgu.ac.in', initials: 'RP', colorIndex: 1),
    Faculty(name: 'Asst. Prof. Neha Kothari', designation: 'Assistant Professor', subject: 'Data Science', email: 'nk@jgu.ac.in', initials: 'NK', colorIndex: 2),
    Faculty(name: 'Prof. Ankit Mehta', designation: 'Professor', subject: 'Cybersecurity', email: 'am@jgu.ac.in', initials: 'AM', colorIndex: 3),
    Faculty(name: 'Asst. Prof. Priya Desai', designation: 'Assistant Professor', subject: 'Entrepreneurship', email: 'pd@jgu.ac.in', initials: 'PD', colorIndex: 4),
    Faculty(name: 'Prof. Vikram Shah', designation: 'Professor', subject: 'Project Coordinator', email: 'vs@jgu.ac.in', initials: 'VS', colorIndex: 5),
  ];

  static const timetable = {
    'Monday': [
      TimetableSlot(day: 'Monday', time: '9–10 AM', subject: 'Mobile App Dev', location: 'Lab 3', type: SlotType.lab),
      TimetableSlot(day: 'Monday', time: '10–11 AM', subject: 'Cloud Computing', location: 'Room 201', type: SlotType.theory),
      TimetableSlot(day: 'Monday', time: '11–12 PM', subject: 'Break', location: '', type: SlotType.free),
      TimetableSlot(day: 'Monday', time: '12–1 PM', subject: 'Data Science', location: 'Room 105', type: SlotType.math),
      TimetableSlot(day: 'Monday', time: '2–3 PM', subject: 'Project Work', location: 'Lab 1', type: SlotType.math),
    ],
    'Tuesday': [
      TimetableSlot(day: 'Tuesday', time: '9–10 AM', subject: 'Data Science', location: 'Room 105', type: SlotType.math),
      TimetableSlot(day: 'Tuesday', time: '10–11 AM', subject: 'Cybersecurity', location: 'Room 203', type: SlotType.lab),
      TimetableSlot(day: 'Tuesday', time: '11–12 PM', subject: 'Break', location: '', type: SlotType.free),
      TimetableSlot(day: 'Tuesday', time: '12–1 PM', subject: 'Entrepreneurship', location: 'Room 301', type: SlotType.theory),
      TimetableSlot(day: 'Tuesday', time: '2–3 PM', subject: 'MAD Lab', location: 'Lab 3', type: SlotType.lab),
    ],
  };
}
