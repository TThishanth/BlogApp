import 'package:BlogApp/screens/authentication_screen/auth_screen.dart';
import 'package:BlogApp/screens/home_screen.dart';
import 'package:BlogApp/models/user_model.dart';
import 'package:BlogApp/widgets/progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  ProfilePage({this.uid});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: usersRef
              .doc(widget.uid)
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return circularProgress();
            }
            User user = User.fromDocument(snapshot.data);
            return Column(
              children: [
                Stack(
                  overflow: Overflow.visible,
                  children: [
                    Container(
                      height: size.height * 0.2,
                      color: Theme.of(context).accentColor,
                    ),
                    Positioned(
                      top: 70.0,
                      left: 117.0,
                      child: CircleAvatar(
                        radius: 80.0,
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(user.photoUrl),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 90.0,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        user.username,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        user.email,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        height: 200.0,
                        child: Lottie.asset('animation/profile.json'),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 30.0,
                        ),
                        color: Colors.orange,
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        onPressed: () {
                          authServices.signout();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Authentication(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
