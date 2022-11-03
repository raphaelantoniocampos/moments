import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String profilePic;
  final String username;
  final List connecting;
  final List connections;

  const User(
      {required this.profilePic,
      required this.uid,
      required this.username,
      required this.connecting,
      required this.connections,
      required this.email});

  Map<String, dynamic> toJson() => {
        "photoUrl": profilePic,
        "username": username,
        "email": email,
        "uid": uid,
        "connecting": connecting,
        "connections": connections,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot['username'],
      profilePic: snapshot['photoUrl'],
      email: snapshot['email'],
      uid: snapshot['uid'],
      connecting: snapshot['connecting'],
      connections: snapshot['connections'],
    );
  }
}
