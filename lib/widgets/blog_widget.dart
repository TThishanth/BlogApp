import 'package:BlogApp/models/user_model.dart' as usr;
import 'package:BlogApp/screens/home_screen.dart';
import 'package:BlogApp/widgets/progress_indicator_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Blog extends StatefulWidget {
  final String blogId;
  final String ownerId;
  final String title;
  final String description;
  final String blogBody;
  final String mediaUrl;
  final dynamic bookmarks;
  final Timestamp timestamp;

  Blog({
    this.blogId,
    this.ownerId,
    this.title,
    this.description,
    this.blogBody,
    this.mediaUrl,
    this.bookmarks,
    this.timestamp,
  });

  factory Blog.fromDocument(DocumentSnapshot doc) {
    return Blog(
      blogId: doc['blogId'],
      ownerId: doc['ownerId'],
      title: doc['title'],
      description: doc['description'],
      blogBody: doc['blogBody'],
      mediaUrl: doc['mediaUrl'],
      bookmarks: doc['bookmarks'],
      timestamp: doc['timestamp'],
    );
  }

  int getBookmarkCount(bookmarks) {
    // if no likes, return 0
    if (bookmarks == null) {
      return 0;
    }
    int count = 0;
    // if the key is explicitly set to true, add a like
    bookmarks.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  @override
  _BlogState createState() => _BlogState(
        blogId: this.blogId,
        ownerId: this.ownerId,
        title: this.title,
        description: this.description,
        blogBody: this.blogBody,
        mediaUrl: this.mediaUrl,
        bookmarks: this.bookmarks,
        timestamp: this.timestamp,
        bookmarkCount: getBookmarkCount(this.bookmarks),
      );
}

class _BlogState extends State<Blog> {
  final String currentUserId = FirebaseAuth.instance.currentUser.uid;
  final currentUser = FirebaseAuth.instance.currentUser;
  final String blogId;
  final String ownerId;
  final String title;
  final String description;
  final String blogBody;
  final String mediaUrl;
  final Timestamp timestamp;
  int bookmarkCount;
  Map bookmarks;
  bool isBookmarked;

  _BlogState({
    this.blogId,
    this.ownerId,
    this.title,
    this.description,
    this.blogBody,
    this.mediaUrl,
    this.timestamp,
    this.bookmarks,
    this.bookmarkCount,
  });

  /* ************************************** */

  // only owner can delete blog
  deleteBlog() async {
    // delete post itself
    postsRef.doc(ownerId).collection('userPosts').doc(blogId).get().then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    // delete post from timeline
    timelineRef.doc(blogId).get().then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  handleDeleteBlog(BuildContext ctx) {
    return showDialog(
      context: ctx,
      builder: (context) {
        return SimpleDialog(
          title: Text('Remove this blog?'),
          children: [
            SimpleDialogOption(
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                deleteBlog();
              },
            ),
            SimpleDialogOption(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  buildBlogHeader() {
    return FutureBuilder(
      future: usersRef.doc(ownerId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        usr.User user = usr.User.fromDocument(snapshot.data);
        bool isPostOwner = currentUserId == ownerId;
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(user.photoUrl),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text('by - ' + user.username),
          trailing: isPostOwner
              ? IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () => handleDeleteBlog(context),
                )
              : Text(''),
        );
      },
    );
  }

  /* ****************************************** */

  Container buildBlogImage() {
    return Container(
      child: Image.network(mediaUrl),
    );
  }

  /* ****************************************** */

  _handleBookmarkBlog() {
    bool _isBookmarked = bookmarks[currentUserId] == true;

    if (_isBookmarked) {
      postsRef
          .doc(ownerId)
          .collection('userPosts')
          .doc(blogId)
          .update({'bookmarks.$currentUserId': false});

      timelineRef.doc(blogId).update({'bookmarks.$currentUserId': false});

      setState(() {
        bookmarkCount -= 1;
        isBookmarked = false;
        bookmarks[currentUserId] = false;
      });
    } else if (!_isBookmarked) {
      postsRef
          .doc(ownerId)
          .collection('userPosts')
          .doc(blogId)
          .update({'bookmarks.$currentUserId': true});

      timelineRef.doc(blogId).update({'bookmarks.$currentUserId': true});

      setState(() {
        bookmarkCount += 1;
        isBookmarked = true;
        bookmarks[currentUserId] = true;
      });
    }
  }

  buildPostFooter() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: _handleBookmarkBlog,
                  child: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    size: 38.0,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                  'timestamp',
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              Container(
                child: Text(
                  '$bookmarkCount bookmarks',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(10.0),
          child: Text(
            description,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    isBookmarked = (bookmarks[currentUserId] == true);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildBlogHeader(),
        buildBlogImage(),
        buildPostFooter(),
        Divider(),
      ],
    );
  }
}
