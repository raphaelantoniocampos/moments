import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String postId;
  final datePublished;
  final String postUrl;
  final likes;
  final bool isVideo;
  final String thumbnail;
  final bool isPublic;
  final int commentCount;

  Post({
    required this.description,
    required this.uid,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.likes,
    required this.isVideo,
    required this.thumbnail,
    required this.isPublic,
    required this.commentCount,
  });

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "postId": postId,
        "datePublished": datePublished,
        "postUrl": postUrl,
        "likes": likes,
        "isVideo": isVideo,
        "thumbnail": thumbnail,
        "isPublic": isPublic,
        "commentCount": commentCount,
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
      thumbnail: snapshot['thumbnail'],
      isPublic: snapshot['isPublic'],
      commentCount: snapshot['commentCount'],
    );
  }
}
