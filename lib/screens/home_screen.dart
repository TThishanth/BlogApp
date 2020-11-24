import 'package:BlogApp/screens/authentication_screen/auth_screen.dart';
import 'package:BlogApp/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User user = FirebaseAuth.instance.currentUser;
  var _isAuth = false;

  buildAuthScreen() {
    return Authentication();
  }

  buildUnAuthScreen() {
    final _authRef =
        Provider.of<AuthenticationServices>(context, listen: false);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(user.uid),
          RaisedButton(
            onPressed: () {
              _authRef.signout().whenComplete(() {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Authentication(),
                    ));
              });
            },
            child: Text('SignOut'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
