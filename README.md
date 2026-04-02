<div align="center">

# 🎓 Campus ERP 
### A Full-Featured College Management App built with Flutter & Firebase

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-Firestore-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey?style=for-the-badge)

> A modern, role-based campus ERP mobile application for students and faculty of JG University — built with Flutter, Dart, and Firebase.

</div>

---

## 📱 Screenshots


| Splash | Login | Dashboard | Drawer |
|--------|-------|-----------|--------|
| ![splash](/college_erp/assets/images/ss12.jpeg) | ![login](/college_erp/assets/images/ss3.jpeg) | ![dashboard](/college_erp/assets/images/ss1.jpeg) | ![drawer](/college_erp/assets/images/ss11.jpeg) |

| Attendance | Timetable | Marks | Notice Board |
|------------|-----------|-------|--------------|
| ![attendance](/college_erp/assets/images/ss4.jpeg) | ![timetable](/college_erp/assets/images/ss5.jpeg) | ![marks](/college_erp/assets/images/ss10.jpeg) | ![notices](/college_erp/assets/images/ss9.jpeg) |



---

## ✨ Features

### 🔐 Authentication
- Role-based login — **Student** and **Faculty** sections are fully isolated
- Students can only log in from the Student tab; Faculty from the Faculty tab
- Wrong-role login is blocked with a clear error message
- Forgot password via Firebase email reset
- New student registration

### 🏠 Student Dashboard
- Dynamic greeting with logged-in student's name
- Live stats — Attendance %, CGPA, Subject count, Unread notices
- Today's class schedule at a glance
- Recent notice board feed

### 👤 Student Profile
- Full profile view — name, roll number, department, semester, email
- Data pulled dynamically from Firebase Firestore

### 📅 Attendance Tracking
- Subject-wise attendance breakdown
- Visual indicator — above/below 75% minimum threshold
- Semester-level attendance summary

### 🗓️ Timetable
- Day-wise class schedule
- Subject name, timing, and room number
- Clean weekly view

### 📊 Marks & Results
- Subject-wise internal and external marks
- CGPA display per semester
- Class rank indicator

### 📢 Notice Board
- University-wide announcements
- Category tags (Exam, Event, Holiday, General)
- Date-stamped entries, unread count on dashboard

### 👩‍🏫 Faculty Directory
- Browse all faculty members
- Department and subject info
- Contact details

### 🎨 UI / UX
- Animated splash screen
- Consistent green (`#1A7A5E`) brand theme throughout
- Fully dynamic sidebar — shows logged-in user's name, initials, department, semester
- Dynamic avatar initials — updates on every login (no more hardcoded "SS"!)
- Google Fonts (Nunito) for clean, modern typography

---

## 🏗️ Project Structure

```
college-erp-flutter/
├── lib/
│   ├── main.dart                  # App entry, MainShell (drawer + nav)
│   ├── firebase_options.dart      # Firebase config (auto-generated)
│   ├── theme/
│   │   └── app_theme.dart         # Colors, text styles, theme data
│   ├── models/
│   │   └── app_user.dart          # AppUser model, UserRole enum
│   ├── providers/
│   │   └── current_user.dart      # Global CurrentUser ChangeNotifier
│   ├── services/
│   │   └── auth_service.dart      # Firebase Auth + Firestore logic
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── login_screen.dart
│   │   ├── dashboard_screen.dart
│   │   ├── profile_screen.dart
│   │   ├── attendance_screen.dart
│   │   ├── timetable_screen.dart
│   │   ├── marks_screen.dart
│   │   ├── notice_board_screen.dart
│   │   ├── faculty_screen.dart
│   │   ├── faculty_dashboard_screen.dart
│   │   └── auth/
│   │       └── register_screen.dart
│   └── widgets/
│       └── (shared reusable widgets)
├── screenshots/                   # App screenshots for README
├── pubspec.yaml
├── README.md
└── .gitignore
```

---

## 🚀 Getting Started

### Prerequisites

Make sure you have the following installed:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.x or above)
- [Dart SDK](https://dart.dev/get-dart) (comes with Flutter)
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/)
- A Firebase project set up at [console.firebase.google.com](https://console.firebase.google.com)

Verify your Flutter installation:
```bash
flutter doctor
```

---

### 🔧 Installation & Setup

#### 1. Clone the repository
```bash
git clone https://github.com/smit-85016/college-erp-flutter.git
cd college-erp-flutter
```

#### 2. Install dependencies
```bash
flutter pub get
```

#### 3. Set up Firebase

This app uses Firebase Auth and Firestore. You need to connect your own Firebase project.

**Step 1 — Install the FlutterFire CLI (if not already):**
```bash
dart pub global activate flutterfire_cli
```

**Step 2 — Connect your Firebase project:**
```bash
flutterfire configure
```
This will generate `lib/firebase_options.dart` automatically.

**Step 3 — Enable these services in your Firebase Console:**
- ✅ Authentication → Email/Password
- ✅ Cloud Firestore

---

### 🗄️ Firestore Database Structure

Create the following collections in Firestore:

#### `users` collection
Each document ID = Firebase Auth UID

```
users/
└── {uid}/
    ├── name        : "Adarsh Patel"       (String)
    ├── email       : "adarsh@gmail.com"     (String)
    ├── role        : "student"             (String) ← "student" or "faculty"
    ├── rollNo      : "21IT001"             (String)
    ├── department  : "B.Tech IT"           (String)
    ├── semester    : "Sem 6"              (String)
    └── uid         : "{uid}"              (String)
```
> passward is adarsh12345\
> ⚠️ **Important:** The `role` field must be either `"student"` or `"faculty"` exactly.  
> This is what enforces role-based login separation.

#### Example Faculty document
```
users/
└── {facultyUid}/
    ├── name        : "Prof. Mehta"
    ├── email       : "mehta@jgu.edu"
    ├── role        : "faculty"
    ├── department  : "IT Department"
    └── uid         : "{facultyUid}"
```

---

### ▶️ Run the App

```bash
# Run on connected Android/iOS device or emulator
flutter run

# Run in release mode
flutter run --release

# Build APK
flutter build apk --release

# Build for iOS
flutter build ios --release
```

---

## 📦 Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `firebase_core` | latest | Firebase initialization |
| `firebase_auth` | latest | Email/password authentication |
| `cloud_firestore` | latest | Realtime database |
| `google_fonts` | latest | Nunito font family |
| `flutter` | SDK | UI framework |

Full list in [`pubspec.yaml`](pubspec.yaml).

---

## 🔒 Security & Role Enforcement

This app enforces strict role-based access:

- The login screen has two tabs — **Student** and **Faculty**
- After Firebase Auth verifies credentials, the app fetches the user's `role` field from Firestore
- If the role does not match the selected tab, login is **blocked immediately** and the user is shown an error
- Faculty credentials **cannot** access the Student dashboard, and vice versa

```
Student tab  +  faculty credentials  →  ❌ Blocked
Faculty tab  +  student credentials  →  ❌ Blocked
Student tab  +  student credentials  →  ✅ Student Dashboard
Faculty tab  +  faculty credentials  →  ✅ Faculty Dashboard
```

---

## ⚠️ Known Limitations

- Password recovery email may land in spam depending on email provider
- Faculty dashboard features are still being expanded
- No push notifications yet for Notice Board updates
- Offline mode is not supported — requires active internet connection

---

## 🗺️ Roadmap

- [ ] Push notifications for new notices
- [ ] Faculty can mark attendance from the app
- [ ] Assignment submission module
- [ ] Dark mode support
- [ ] Offline caching with Firestore persistence
- [ ] Biometric login support

---

## 🤝 Contributing

Contributions are welcome!

```bash
# 1. Fork the repo
# 2. Create your feature branch
git checkout -b feature/your-feature-name

# 3. Commit your changes
git commit -m "Add: your feature description"

# 4. Push to the branch
git push origin feature/your-feature-name

# 5. Open a Pull Request
```

Please make sure your code follows the existing style and has no lint warnings (`flutter analyze`).

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Developed by:** Smit Shah

---
<div align="center">

[![Download APK](https://img.shields.io/badge/Download-APK%20v1.0-brightgreen?style=for-the-badge&logo=android&logoColor=white)](https://github.com/YOUR_USERNAME/college-erp-flutter/releases/download/v1.0.0/app-release.apk)

</div>
---

<div align="center">

Made with ❤️ and Flutter &nbsp;|&nbsp; JG University Campus ERP &nbsp;|&nbsp; v1.0

</div>