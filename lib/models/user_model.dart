import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String email;
  final String photoUrl;

  User({
    this.id,
    this.username,
    this.email,
    this.photoUrl,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc['uid'],
      username: doc['username'],
      email: doc['email'],
      photoUrl: doc['photoURL'],
    );
  }
}

