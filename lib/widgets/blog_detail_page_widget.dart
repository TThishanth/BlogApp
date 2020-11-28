import 'package:BlogApp/widgets/blog_widget.dart';
import 'package:BlogApp/widgets/progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:BlogApp/screens/home_screen.dart';
import 'package:get_time_ago/get_time_ago.dart';

class BlogDetailPage extends StatefulWidget {
  final String blogId;
  BlogDetailPage({this.blogId});

  @override
  _BlogDetailPageState createState() => _BlogDetailPageState();
}

class _BlogDetailPageState extends State<BlogDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: timelineRef.doc(widget.blogId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          Blog blog = Blog.fromDocument(snapshot.data);
          return ListView(
            children: [
              ListTile(
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                child: Image.network(blog.mediaUrl),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  blog.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 10.0,
                ),
                child: Text(
                  blog.blogBody,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                child: Text(
                  TimeAgo.getTimeAgo(blog.timestamp.toDate()),
                  textAlign: TextAlign.right,
                ),
              ),
              Divider(),
            ],
          );
        },
      ),
    );
  }
}
