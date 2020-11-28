import 'package:BlogApp/screens/home_screen.dart';
import 'package:BlogApp/widgets/blog_widget.dart';
import 'package:BlogApp/widgets/progress_indicator_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TimelinePage extends StatefulWidget {
  final String uid;
  TimelinePage({this.uid});
  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  List<Blog> blogs;

  @override
  void initState() {
    super.initState();
    getTimeline();
  }

  getTimeline() async {
    QuerySnapshot snapshot =
        await timelineRef.orderBy('timestamp', descending: true).get();

    List<Blog> blogs =
        snapshot.docs.map((doc) => Blog.fromDocument(doc)).toList();

    setState(() {
      this.blogs = blogs;
    });
  }

  /* ****************************************** */

  buildTimeline() {
    if (blogs == null) {
      return circularProgress();
    } else if (blogs.isEmpty) {
      return noBlogsMsg();
    } else {
      return ListView(
        children: blogs,
      );
    }
  }

  /* ***************************************** */

  noBlogsMsg() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: Lottie.asset('animation/nodata.json'),
        ),
        Container(
          child: Text(
            'No Blogs',
            style: TextStyle(
              fontSize: 40.0,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'Timeline',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: RefreshIndicator(
            child: buildTimeline(), onRefresh: () => getTimeline()),
      ),
    );
  }
}
