import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String uid;
  String id;
  String text;
  final datePublished;
  List likes;


  Comment({
    required this.uid,
    required this.id,
    required this.text,
    required this.datePublished,
    required this.likes,
  });

  Map<String, dynamic> toJson() =>
      {
        "uid": uid,
        "id": id,
        "text": text,
        "datePublished": datePublished,
        "likes": likes,
      };

  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Comment(
      uid: snapshot['uid'],
      id: snapshot['id'],
      text: snapshot['text'],
      datePublished: snapshot['datePublished'],
      likes: snapshot['likes'],
    );
  }
}