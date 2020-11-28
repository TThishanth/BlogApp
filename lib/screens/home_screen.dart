import 'package:BlogApp/screens/authentication_screen/auth_screen.dart';
import 'package:BlogApp/screens/nav_pages/bookmark.dart';
import 'package:BlogApp/screens/nav_pages/notification.dart';
import 'package:BlogApp/screens/nav_pages/profile.dart';
import 'package:BlogApp/screens/nav_pages/timeline.dart';
import 'package:BlogApp/screens/nav_pages/upload.dart';
import 'package:BlogApp/services/authentication_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final postsRef = FirebaseFirestore.instance.collection('blogs');
final storageRef = FirebaseStorage.instance.ref();
final AuthenticationServices authServices = AuthenticationServices();
final timelineRef = FirebaseFirestore.instance.collection('timeline');
final notificationRef = FirebaseFirestore.instance.collection('notification');
final timestamp = DateTime.now();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User user = FirebaseAuth.instance.currentUser;
  PageController _pageController = PageController();
  var _isAuth = false;
  int currentIndex = 0;

  void _onTap(int page) {
    setState(() {
      currentIndex = page;
    });
    _pageController.jumpToPage(page);
  }

  buildAuthScreen() {
    return Authentication();
  }

  buildUnAuthScreen() {
    return Scaffold(
      body: PageView(
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        controller: _pageController,
        children: [
          TimelinePage(uid: user.uid),
          BookmarkPage(),
          UploadPage(uid: user.uid),
          NotificationPage(),
          ProfilePage(uid: user.uid),
        ],
      ),
      bottomNavigationBar: ConvexAppBar(
        onTap: _onTap,
        style: TabStyle.fixedCircle,
        backgroundColor: Colors.white,
        activeColor: Colors.orange,
        color: Colors.blueGrey,
        elevation: 5,
        items: [
          TabItem(
            icon: Icon(
              Icons.home,
              color: Colors.blueGrey,
            ),
            title: 'Home',
          ),
          TabItem(
            icon: Icon(
              Icons.bookmark,
              color: Colors.blueGrey,
            ),
            title: 'Bookmark',
          ),
          TabItem(
            icon: Icon(
              Icons.add,
              size: 40.0,
              color: Colors.white,
            ),
            title: 'Upload',
          ),
          TabItem(
            icon: Icon(
              Icons.notifications,
              color: Colors.blueGrey,
            ),
            title: 'Notification',
          ),
          TabItem(
            icon: Icon(
              Icons.person,
              color: Colors.blueGrey,
            ),
            title: 'Profile',
          ),
        ],
        initialActiveIndex: currentIndex,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 6, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
