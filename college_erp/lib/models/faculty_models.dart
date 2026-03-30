// ── Faculty-specific models ──

class FacultyStudent {
  final String id;
  String name;
  String rollNo;
  String email;
  String phone;
  double cgpa;
  String semester;
  String department;

  FacultyStudent({
    required this.id,
    required this.name,
    required this.rollNo,
    required this.email,
    required this.phone,
    required this.cgpa,
    required this.semester,
    required this.department,
  });

  String get initials => name.split(' ').map((w) => w[0]).take(2).join();
}

class AttendanceEntry {
  final String studentId;
  final String subject;
  final String date;
  bool isPresent;

  AttendanceEntry({
    required this.studentId,
    required this.subject,
    required this.date,
    this.isPresent = true,
  });
}

class MarksEntry {
  final String studentId;
  final String subject;
  final String examType;
  int marks;
  final int totalMarks;

  MarksEntry({
    required this.studentId,
    required this.subject,
    required this.examType,
    required this.marks,
    required this.totalMarks,
  });
}

class FacultyNotice {
  final String id;
  final String title;
  final String body;
  final String date;
  final String postedBy;
  final FacultyNoticeType type;

  FacultyNotice({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.postedBy,
    required this.type,
  });
}

enum FacultyNoticeType { exam, event, holiday, general }

class LeaveApplication {
  final String id;
  final String facultyName;
  final String fromDate;
  final String toDate;
  final String reason;
  final String appliedOn;
  LeaveStatus status;

  LeaveApplication({
    required this.id,
    required this.facultyName,
    required this.fromDate,
    required this.toDate,
    required this.reason,
    required this.appliedOn,
    this.status = LeaveStatus.pending,
  });
}

enum LeaveStatus { pending, approved, rejected }

// ── Mutable mock data store ──
class FacultyData {
  static List<FacultyStudent> students = [
    FacultyStudent(id: '1', name: 'Smit Shah', rollNo: '22IT0045', email: 'smit.shah@jgu.ac.in', phone: '+91 98765 43210', cgpa: 8.4, semester: 'Sem 6', department: 'IT'),
    FacultyStudent(id: '2', name: 'Rishi Koshti', rollNo: '22IT0031', email: 'rishi.koshti@jgu.ac.in', phone: '+91 91234 56789', cgpa: 7.9, semester: 'Sem 6', department: 'IT'),
    FacultyStudent(id: '3', name: 'Keval Joshi', rollNo: '22IT0022', email: 'keval.joshi@jgu.ac.in', phone: '+91 93456 78901', cgpa: 8.8, semester: 'Sem 6', department: 'IT'),
    FacultyStudent(id: '4', name: 'Adarsh Pathak', rollNo: '22IT0003', email: 'adarsh.pathak@jgu.ac.in', phone: '+91 94567 89012', cgpa: 7.5, semester: 'Sem 6', department: 'IT'),
    FacultyStudent(id: '5', name: 'Hitarth Parekh', rollNo: '22IT0019', email: 'hitarth.parekh@jgu.ac.in', phone: '+91 95678 90123', cgpa: 8.1, semester: 'Sem 6', department: 'IT'),
  ];

  static final List<FacultyNotice> notices = [
    FacultyNotice(id: '1', title: 'Mid-semester exam schedule released', body: 'Mid-semester examination schedule for Sem 6 has been released. Exams begin April 7.', date: '27 Mar 2026', postedBy: 'Prof. Gayan', type: FacultyNoticeType.exam),
    FacultyNotice(id: '2', title: 'Techfest 2026 registrations open', body: 'Techfest 2026 registrations are open. Last date: April 2.', date: '26 Mar 2026', postedBy: 'Student Council', type: FacultyNoticeType.event),
    FacultyNotice(id: '3', title: 'College holiday on March 31', body: 'College will remain closed on March 31 for the semester break.', date: '25 Mar 2026', postedBy: 'Administration', type: FacultyNoticeType.holiday),
  ];

  static final List<LeaveApplication> leaves = [
    LeaveApplication(id: '1', facultyName: 'Asst. Prof. Shikhashree Gayan', fromDate: '01 Apr 2026', toDate: '02 Apr 2026', reason: 'Medical appointment', appliedOn: '28 Mar 2026', status: LeaveStatus.pending),
    LeaveApplication(id: '2', facultyName: 'Asst. Prof. Shikhashree Gayan', fromDate: '10 Mar 2026', toDate: '10 Mar 2026', reason: 'Family function', appliedOn: '05 Mar 2026', status: LeaveStatus.approved),
  ];

  static final List<String> subjects = [
    'Mobile App Dev',
    'Project Work',
  ];

  static final Map<String, Map<String, int>> marksData = {
    '1': {'Mobile App Dev': 88, 'Project Work': 92},
    '2': {'Mobile App Dev': 74, 'Project Work': 80},
    '3': {'Mobile App Dev': 91, 'Project Work': 95},
    '4': {'Mobile App Dev': 65, 'Project Work': 70},
    '5': {'Mobile App Dev': 82, 'Project Work': 85},
  };

  // attendance: studentId -> subject -> List of bool (each class)
  static final Map<String, Map<String, List<bool>>> attendanceData = {
    '1': {'Mobile App Dev': [true, true, false, true, true], 'Project Work': [true, true, true, true, true]},
    '2': {'Mobile App Dev': [true, false, true, true, false], 'Project Work': [true, true, false, true, true]},
    '3': {'Mobile App Dev': [true, true, true, true, true], 'Project Work': [true, true, true, true, true]},
    '4': {'Mobile App Dev': [false, true, false, true, true], 'Project Work': [true, false, true, false, true]},
    '5': {'Mobile App Dev': [true, true, true, false, true], 'Project Work': [true, true, true, true, false]},
  };
}
