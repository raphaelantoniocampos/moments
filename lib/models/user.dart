import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants.dart';

class User {
  final String email;
  final String uid;
  String profilePic;
  String coverPic;
  final String username;
  List public;
  List hiding;
  final List asked;
  final List friends;

  User(
      {required this.profilePic,
      required this.coverPic,
      required this.uid,
      required this.username,
      required this.public,
      required this.hiding,
      required this.asked,
      required this.friends,
      required this.email});

  Map<String, dynamic> toJson() => {
        "profilePic": profilePic,
        "coverPic": coverPic,
        "username": username,
        "public": public,
        "hiding": hiding,
        "email": email,
        "uid": uid,
        "asked": asked,
        "friends": friends,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data()! as Map<String, dynamic>;

    return User(
      username: snapshot['username'],
      public: snapshot['public'],
      hiding: snapshot['hiding'],
      profilePic: snapshot['profilePic'],
      coverPic: snapshot['coverPic'],
      email: snapshot['email'],
      uid: snapshot['uid'],
      asked: snapshot['asked'],
      friends: snapshot['friends'],
    );
  }

  static Future<User> fromUid(String uid) async {
    var snap = await firebaseFirestore.collection('users').doc(uid).get();
    return User.fromSnap(snap);
  }
}
