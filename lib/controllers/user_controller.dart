import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:moments/constants.dart';

import 'package:moments/models/user.dart' as model;
import '../models/post.dart';

class UserController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  final Rx<List<Post>> _postList = Rx<List<Post>>([]);

  Map<String, dynamic> get user => _user.value;

  List<Post> get postList => _postList.value;

  Rx<String> _uid = "".obs;

  updateUserId(String uid) async {
    _uid.value = uid;

    await getUserData();
    await getPostsData();
  }

  getUserData() async {
    _user.value = {};
    DocumentSnapshot userDoc =
        await firebaseFirestore.collection('users').doc(_uid.value).get();
    final userData = userDoc.data()! as dynamic;
    String username = userData['username'];
    String profilePic = userData['profilePic'];
    String coverPic = userData['coverPic'];
    List friends = userData['friends'];
    List asked = userData['asked'];
    bool isFriend = false;
    bool askedCurrentUser = false;
    bool wasAsked = false;
    bool reachedLimit = friends.length >= limitFriends;

    if (friends.contains(authController.user.uid)) {
      isFriend = true;
    } else {
      isFriend = false;
    }
    if (asked.contains(authController.user.uid)) {
      askedCurrentUser  = true;
    } else {
      askedCurrentUser  = false;
    }

    await firebaseFirestore
        .collection('users')
        .doc(authController.user.uid)
        .get()
        .then((value) {
      if ((value.data()! as dynamic)['asked'].contains(_uid.value)) {
        wasAsked = true;
      } else {
        wasAsked = false;
      }
    });

    _user.value = {
      'friends': friends,
      'asked': asked.length,
      'isFriend': isFriend,
      'askedCurrentUser': askedCurrentUser ,
      'wasAsked': wasAsked,
      'reachedLimit': reachedLimit,
      'profilePic': profilePic,
      'username': username,
      'coverPic': coverPic,
    };
    update();

    print('username: ${_user.value['username']}');
  }

  getPostsData() async {
    _postList.value = [];
    var canView = [true];

    if (_user.value['isFriend'] || _uid.value == authController.user.uid) {
      canView.add(false);
    }

    var postsDoc = await firebaseFirestore
        .collection('posts')
        .where('uid', isEqualTo: _uid.value)
        .where('isPublic', whereIn: canView)
        .orderBy('datePublished', descending: true)
        .get();

    for (var element in postsDoc.docs) {
      _postList.value.add(Post.fromSnap(element));
    }

    update();
  }

  addFriend() async {
    var doc = await firebaseFirestore.collection('users').doc(_uid.value).get();

    // IF IS FRIEND => REMOVE FRIEND
    if ((doc.data()! as dynamic)['friends']
        .contains(authController.user.uid)) {
      await firebaseFirestore.collection('users').doc(_uid.value).update({
        'friends': FieldValue.arrayRemove([authController.user.uid])
      });
      await firebaseFirestore
          .collection('users')
          .doc(authController.user.uid)
          .update({
        'friends': FieldValue.arrayRemove([_uid.value])
      });
      _user.value.update('friends', (value) => value - 1);
      _user.value.update('isFriend', (value) => false);
    }
    //IF USER IS ASKING and USER HAS LESS THAN LIMIT FRIENDS => ADD FRIEND, REMOVE ASKED
    else if ((doc.data()! as dynamic)['asked']
            .contains(authController.user.uid) &&
        !(_user.value['reachedLimit'])) {
      await firebaseFirestore.collection('users').doc(_uid.value).update({
        'friends': FieldValue.arrayUnion([authController.user.uid])
      });
      await firebaseFirestore
          .collection('users')
          .doc(authController.user.uid)
          .update({
        'friends': FieldValue.arrayUnion([_uid.value])
      });
      await firebaseFirestore
          .collection('users')
          .doc(authController.user.uid)
          .update({
        'asked': FieldValue.arrayRemove([_uid.value])
      });
      await firebaseFirestore.collection('users').doc(_uid.value).update({
        'asked': FieldValue.arrayRemove([authController.user.uid])
      });

      _user.value.update('friends', (value) => value + 1);
      _user.value.update('asked', (value) => value - 1);
      _user.value.update('isFriend', (value) => true);
      _user.value.update('askedCurrentUser', (value) => false);
      _user.value.update('wasAsked', (value) => false);
    }
    //IF USER WAS ASKED => REMOVE ASKED
    else if (_user.value['wasAsked']) {
      await firebaseFirestore
          .collection('users')
          .doc(authController.user.uid)
          .update({
        'asked': FieldValue.arrayRemove([_uid.value])
      });
      _user.value.update('wasAsked', (value) => false);
    }
    //IF IS NOT ASKED => ADD ASKED
    else {
      await firebaseFirestore
          .collection('users')
          .doc(authController.user.uid)
          .update({
        'asked': FieldValue.arrayUnion([_uid.value])
      });
      _user.value.update('wasAsked', (value) => true);
    }
    update();
  }

  Future<void> changeProfilePic(Post post) async {
    String res = '';
    try {
      var collection = firebaseFirestore.collection('users');
      model.User user = await authController.getUserDetails();
      String imageUrl;
      if (post.isVideo) {
        imageUrl = post.thumbnail;
      } else {
        imageUrl = post.downloadUrl;
      }
      user.profilePic = imageUrl;
      Map<String, Object?> data = user.toJson();
      collection.doc(firebaseAuth.currentUser!.uid).update(data);
      res = 'Success';
    } catch (e) {
      res = e.toString();
      Get.snackbar("Change Profile Pic", res);
    }
    update();
  }

  Future<void> changeCoverPic(Post post) async {
    String res = '';
    try {
      var collection = firebaseFirestore.collection('users');
      model.User user = await authController.getUserDetails();
      String imageUrl;
      if (post.isVideo) {
        imageUrl = post.thumbnail;
      } else {
        imageUrl = post.downloadUrl;
      }
      user.coverPic = imageUrl;
      Map<String, Object?> data = user.toJson();
      collection.doc(firebaseAuth.currentUser!.uid).update(data);
      res = 'Success';
    } catch (e) {
      res = e.toString();
      Get.snackbar("Change Profile Pic", res);
    }
    update();
  }
}
