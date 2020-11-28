import 'package:BlogApp/models/user_model.dart' as usr;
import 'package:BlogApp/widgets/blog_detail_page_widget.dart';
import 'package:BlogApp/widgets/progress_indicator_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:BlogApp/screens/home_screen.dart';
import 'package:page_transition/page_transition.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final String currentUserId = FirebaseAuth.instance.currentUser.uid;

  buildListTile(ownerId, blogTitle) {
    return FutureBuilder(
      future: usersRef.doc(ownerId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return circularProgress();
        }
        usr.User _user = usr.User.fromDocument(snapshot.data);
        return Card(
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(_user.photoUrl),
            ),
            title: Text(
              _user.username + ' is posted new Blog',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text('About ' + blogTitle),
          ),
        );
      },
    );
  }

  /* *************************************************** */

  goBlogDetailPage(blogId) {
    Navigator.push(
      context,
      PageTransition(
        child: BlogDetailPage(blogId: blogId),
        type: PageTransitionType.fade,
      ),
    );
  }

  buildNotification() {
    return StreamBuilder(
      stream: notificationRef.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: Text('No Notifications'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return circularProgress();
        }
        final doc = snapshot.data.docs;

        return ListView.builder(
          itemCount: doc.length,
          itemBuilder: (context, index) {
            bool _isCurrentUser = doc[index]['ownerId'] == currentUserId;
            return GestureDetector(
              onTap: () => goBlogDetailPage(doc[index]['blogId']),
              child: !_isCurrentUser
                  ? buildListTile(
                      doc[index]['ownerId'],
                      doc[index]['title'],
                    )
                  : Text(''),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'Notifications',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
          child: buildNotification(),
        ),
      ),
    );
  }
}
