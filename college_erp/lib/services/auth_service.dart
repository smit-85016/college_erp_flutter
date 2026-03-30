import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ── Enums ──
enum UserRole { student, faculty }

enum RegistrationStatus { pending, approved, rejected }

// ── User model from Firestore ──
class AppUser {
  final String uid;
  final String email;
  final String name;
  final String rollNo; // students only
  final String department;
  final String semester;
  final UserRole role;
  final RegistrationStatus status;
  final String assignedFacultyId; // faculty uid who manages this student

  const AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.rollNo,
    required this.department,
    required this.semester,
    required this.role,
    required this.status,
    required this.assignedFacultyId,
  });

  factory AppUser.fromMap(String uid, Map<String, dynamic> data) => AppUser(
        uid: uid,
        email: data['email'] ?? '',
        name: data['name'] ?? '',
        rollNo: data['rollNo'] ?? '',
        department: data['department'] ?? '',
        semester: data['semester'] ?? '',
        role: data['role'] == 'faculty' ? UserRole.faculty : UserRole.student,
        status: _parseStatus(data['status']),
        assignedFacultyId: data['assignedFacultyId'] ?? '',
      );

  static RegistrationStatus _parseStatus(String? s) {
    switch (s) {
      case 'approved':
        return RegistrationStatus.approved;
      case 'rejected':
        return RegistrationStatus.rejected;
      default:
        return RegistrationStatus.pending;
    }
  }

  Map<String, dynamic> toMap() => {
        'email': email,
        'name': name,
        'rollNo': rollNo,
        'department': department,
        'semester': semester,
        'role': role == UserRole.faculty ? 'faculty' : 'student',
        'status': status == RegistrationStatus.approved
            ? 'approved'
            : status == RegistrationStatus.rejected
                ? 'rejected'
                : 'pending',
        'assignedFacultyId': assignedFacultyId,
        'createdAt': FieldValue.serverTimestamp(),
      };
}

// ── Pre-registered roll numbers ──
// Admin pre-loads these into Firestore collection: 'preregistered_rolls'
// Each doc: { rollNo: '22IT0045', facultyId: '<faculty_uid>', department: 'IT', semester: 'Sem 6' }

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _db = FirebaseFirestore.instance;

  // Current Firebase user
  static User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ── Get AppUser doc from Firestore ──
  static Future<AppUser?> getAppUser(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (!doc.exists) return null;
      return AppUser.fromMap(uid, doc.data()!);
    } catch (e) {
      return null;
    }
  }

  // ── Validate roll number (check preregistered_rolls collection) ──
  static Future<Map<String, dynamic>?> validateRollNumber(String rollNo) async {
    try {
      final snap = await _db
          .collection('preregistered_rolls')
          .where('rollNo', isEqualTo: rollNo.trim().toUpperCase())
          .where('used', isEqualTo: false)
          .limit(1)
          .get();
      if (snap.docs.isEmpty) return null;
      return {'id': snap.docs.first.id, ...snap.docs.first.data()};
    } catch (e) {
      return null;
    }
  }

  // ── Student Registration ──
  static Future<String?> registerStudent({
    required String email,
    required String password,
    required String name,
    required String rollNo,
    required String phone,
  }) async {
    // 🔒 BASIC VALIDATION
    if (rollNo.trim().isEmpty) return 'Roll number is required';
    if (name.trim().isEmpty) return 'Name is required';
    if (email.trim().isEmpty) return 'Email is required';
    if (password.length < 6) return 'Password must be at least 6 characters';

    try {
      // 1️⃣ Validate roll number
      final rollData = await validateRollNumber(rollNo);
      if (rollData == null) {
        return 'Roll number not found or already used.';
      }

      // 2️⃣ Create Firebase Auth account
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final uid = cred.user!.uid;

      // 3️⃣ Save student in Firestore (PENDING)
      await _db.collection('users').doc(uid).set({
        'email': email.trim(),
        'name': name.trim(),
        'rollNo': rollNo.trim().toUpperCase(),
        'phone': phone.trim(),
        'department': rollData['department'] ?? 'IT',
        'semester': rollData['semester'] ?? 'Sem 6',
        'role': 'student',
        'status': 'pending', // 🔥 IMPORTANT
        'assignedFacultyId': rollData['facultyId'] ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 4️⃣ Mark roll number as used
      await _db.collection('preregistered_rolls').doc(rollData['id']).update({
        'used': true,
        'usedBy': uid,
      });

      // 5️⃣ Create request for faculty approval
      await _db.collection('registration_requests').add({
        'studentUid': uid,
        'studentName': name.trim(),
        'studentEmail': email.trim(),
        'rollNo': rollNo.trim().toUpperCase(),
        'department': rollData['department'] ?? 'IT',
        'semester': rollData['semester'] ?? 'Sem 6',
        'phone': phone.trim(),
        'facultyId': rollData['facultyId'] ?? '',
        'status': 'pending',
        'requestedAt': FieldValue.serverTimestamp(),
      });

      // 6️⃣ Logout student (must wait for approval)
      await _auth.signOut();

      return null; // ✅ SUCCESS
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'Email already registered.';
      }
      if (e.code == 'weak-password') {
        return 'Password too weak (min 6 characters).';
      }
      return e.message ?? 'Registration failed.';
    } catch (e) {
      return 'Something went wrong. Try again.';
    }
  }

  // ── Login ──
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      final uid = cred.user!.uid;
      final appUser = await getAppUser(uid);

      if (appUser == null) {
        await _auth.signOut();
        return {'error': 'Account not found. Contact admin.'};
      }

      // Faculty can always login
      if (appUser.role == UserRole.faculty) {
        return {'user': appUser};
      }

      // Student: check approval status
      if (appUser.status == RegistrationStatus.pending) {
        await _auth.signOut();
        return {'error': 'Your registration is pending faculty approval.'};
      }
      if (appUser.status == RegistrationStatus.rejected) {
        await _auth.signOut();
        return {
          'error': 'Your registration was rejected. Contact your faculty.'
        };
      }

      return {'user': appUser};
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found')
        return {'error': 'No account found with this email.'};
      if (e.code == 'wrong-password') return {'error': 'Incorrect password.'};
      if (e.code == 'invalid-credential')
        return {'error': 'Invalid email or password.'};
      return {'error': e.message ?? 'Login failed.'};
    } catch (e) {
      return {'error': 'Something went wrong. Try again.'};
    }
  }

  // ── Logout ──
  static Future<void> logout() async {
    await _auth.signOut();
  }

  // ── Faculty: get pending registration requests ──
  static Stream<QuerySnapshot> getPendingRequests(String facultyId) {
    return _db
        .collection('registration_requests')
        .where('facultyId', isEqualTo: facultyId)
        .where('status', isEqualTo: 'pending')
        .orderBy('requestedAt', descending: true)
        .snapshots();
  }

  // ── Faculty: approve student ──
  static Future<void> approveStudent(
      String requestId, String studentUid) async {
    final batch = _db.batch();

    batch.update(_db.collection('registration_requests').doc(requestId),
        {'status': 'approved', 'reviewedAt': FieldValue.serverTimestamp()});

    batch.update(
        _db.collection('users').doc(studentUid), {'status': 'approved'});

    await batch.commit();
  }

  // ── Faculty: reject student ──
  static Future<void> rejectStudent(
      String requestId, String studentUid, String reason) async {
    final batch = _db.batch();

    batch.update(_db.collection('registration_requests').doc(requestId), {
      'status': 'rejected',
      'rejectReason': reason,
      'reviewedAt': FieldValue.serverTimestamp()
    });

    batch.update(_db.collection('users').doc(studentUid),
        {'status': 'rejected', 'rejectReason': reason});

    await batch.commit();
  }

  // ── Faculty: get all approved students ──
  static Stream<QuerySnapshot> getFacultyStudents(String facultyId) {
    return _db
        .collection('users')
        .where('role', isEqualTo: 'student')
        .where('assignedFacultyId', isEqualTo: facultyId)
        .where('status', isEqualTo: 'approved')
        .snapshots();
  }

  // ── Password reset ──
  static Future<String?> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Failed to send reset email.';
    }
  }
}
