import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String postId;
  final datePublished;
  final String postUrl;
  final likes;
  final bool isVideo;
  final bool isPublic;

  const Post({
    required this.description,
    required this.uid,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.likes,
    required this.isVideo,
    required this.isPublic,
  });

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "postId": postId,
        "datePublished": datePublished,
        "postUrl": postUrl,
        "likes": likes,
        "isVideo": isVideo,
        "isPublic": isPublic,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      description: snapshot['description'],
      uid: snapshot['uid'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      postUrl: snapshot['postUrl'],
      likes: snapshot['likes'],
      isVideo: snapshot['isVideo'],
      isPublic: snapshot['isPublic'],
    );
  }
}
