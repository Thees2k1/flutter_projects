import 'package:flutter/foundation.dart';

/// Global singleton — imported by router.dart and any page that needs auth.
final authService = AuthService();

class AuthService extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> login({required String email, required String password}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _isLoggedIn = false;
    notifyListeners();
  }
}
