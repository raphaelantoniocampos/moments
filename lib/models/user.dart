import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;

  final String username;
  final List friends;

  const User(
      {required this.photoUrl,
      required this.uid,
      required this.username,
      required this.friends,
      required this.email});

  Map<String, dynamic> toJson() => {
        "photoUrl": photoUrl,
        "username": username,
        "email": email,
        "uid": uid,
        "friends": friends,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot['username'],
      photoUrl: snapshot['photoUrl'],
      email: snapshot['email'],
      uid: snapshot['uid'],
      friends: snapshot['friends'],
    );
  }
}
