import 'package:flutter/material.dart';
import '../services/auth_service.dart';

// Global notifier — holds the currently logged-in AppUser
// Any widget can listen to this and rebuild when the user changes
class CurrentUser extends ChangeNotifier {
  AppUser? _user;

  AppUser? get user => _user;

  String get name => _user?.name ?? '';
  String get email => _user?.email ?? '';
  String get rollNo => _user?.rollNo ?? '';
  String get department => _user?.department ?? '';
  String get semester => _user?.semester ?? '';
  String get uid => _user?.uid ?? '';

  String get initials {
    final parts = name.split(' ').where((w) => w.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
  }

  void setUser(AppUser? user) {
    _user = user;
    notifyListeners();
  }

  void clear() {
    _user = null;
    notifyListeners();
  }
}

// Singleton instance — import this anywhere in the app
final currentUser = CurrentUser();
