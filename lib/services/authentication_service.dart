import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationServices extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  // Send reset password email - Forgot Password Page
  Future resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
    notifyListeners();
  }

  // Logout
  Future signout() async {
    await _firebaseAuth.signOut();
    notifyListeners();
  }
}
