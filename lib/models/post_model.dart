import 'package:cloud_firestore/cloud_firestore.dart';

class BlogPost {
  final String blogId;
  final String ownerId;
  final String title;
  final String description;
  final String blogBody;
  final String mediaUrl;
  final dynamic bookmarks;
  final DateTime timestamp;

  BlogPost({
    this.blogId,
    this.ownerId,
    this.title,
    this.description,
    this.blogBody,
    this.mediaUrl,
    this.bookmarks,
    this.timestamp,
  });

  factory BlogPost.fromDocument(DocumentSnapshot doc) {
    return BlogPost(
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
}
