import 'package:BlogApp/screens/home_screen.dart';
import 'package:BlogApp/widgets/authentication_widget/auth_body.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  var _isLoading = false;
  final _auth = FirebaseAuth.instance;
  final DateTime timestamp = DateTime.now();

  void _submitAuthForm(
    String username,
    String email,
    String password,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential userCredential;

    try {
      setState(() {
        _isLoading = true;
      });

      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await userCredential.user.updateProfile(
          displayName: username,
          photoURL:
              'https://ui-avatars.com/api/?name=$username&background=ff5733&color=fff&length=1',
        );

        List<String> splitList = username.split(' ');
        List<String> indexList = [];

        for (int i = 0; i < splitList.length; i++) {
          for (int j = 0; j < splitList[i].length + i; j++) {
            indexList.add(splitList[i].substring(0, j).toLowerCase());
          }
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user.uid)
            .set({
          "uid": userCredential.user.uid,
          "username": username,
          "email": email,
          "searchIndex": indexList,
          "bio": '',
          "photoURL": userCredential.user.photoURL ??
              'https://ui-avatars.com/api/?name=$username&background=ff5733&color=fff&length=1',
          "timestamp": timestamp,
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      var message = 'An error occured, Please check your credentials.';

      if (e.message != null) {
        message = e.message;
      }

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Container(
                child: AuthBody(
                  _submitAuthForm,
                  _isLoading,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
