import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? _currentUser;
  User? get currentUser => _currentUser;

  AuthProvider() {
    _firebaseAuth.authStateChanges().listen((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  bool get isAuthenticated => _currentUser != null;

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    notifyListeners();
  }

  // Add additional methods if needed, e.g., signInWithPhoneNumber, etc.
}
