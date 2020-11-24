import 'dart:async';

import 'package:BlogApp/screens/authentication_screen/auth_screen.dart';
import 'package:BlogApp/services/authentication_service.dart';
import 'package:BlogApp/widgets/authentication_widget/reset_password_body.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _resetPassKey = GlobalKey<ScaffoldState>();
  AuthenticationServices _authentication = AuthenticationServices();
  final _isLoading = false;

  void _submitResetPasswordForm(
    String email,
    BuildContext ctx,
  ) {
    try {
      
      _authentication.resetPassword(email);

      SnackBar snackBar = SnackBar(
        content: Text('A password reset link has been sent to ' + email),
        backgroundColor: Theme.of(ctx).primaryColor,
      );
      _resetPassKey.currentState.showSnackBar(snackBar);

      Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Authentication(),
          ),
        ),
      );
    } catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _resetPassKey,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: ResetPasswordForm(
            _submitResetPasswordForm,
            _isLoading,
          ),
        ),
      ),
    );
  }
}
