import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String uid;
  String id;
  String audioUrl;
  // final Duration duration;
  final datePublished;
  List likes;


  Comment({
    required this.uid,
    required this.id,
    required this.audioUrl,
    required this.datePublished,
    required this.likes,
    // required this.duration,
  });

  Map<String, dynamic> toJson() =>
      {
        "uid": uid,
        "id": id,
        "audioUrl": audioUrl,
        "datePublished": datePublished,
        "likes": likes,
        // "duration" : duration,
      };

  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Comment(
      uid: snapshot['uid'],
      id: snapshot['id'],
      audioUrl: snapshot['audioUrl'],
      datePublished: snapshot['datePublished'],
      likes: snapshot['likes'],
      // duration: snapshot['duration'],
    );
  }
}