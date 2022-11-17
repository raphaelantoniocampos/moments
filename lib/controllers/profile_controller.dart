import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:moments/constants.dart';

import 'package:moments/models/user.dart' as model;
import '../models/post.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});

  Map<String, dynamic> get user => _user.value;

  Rx<String> _uid = "".obs;

  updateUserId(String uid) {
    _uid.value = uid;
    getUserData();
  }

  getUserData() async {
    DocumentSnapshot userDoc =
        await firebaseFirestore.collection('users').doc(_uid.value).get();
    final userData = userDoc.data()! as dynamic;
    String username = userData['username'];
    String profilePic = userData['profilePic'];
    String coverPic = userData['coverPic'];
    List connections = userData['connections'];
    List connecting = userData['connecting'];
    bool isConnected = false;
    bool isConnecting = false;
    bool iAmConnecting = false;
    bool reachedLimit = connections.length >= limitConnections;

    if (connections.contains(authController.user.uid)) {
      isConnected = true;
    } else {
      isConnected = false;
    }
    if (connecting.contains(authController.user.uid)) {
      isConnecting = true;
    } else {
      isConnecting = false;
    }

    await firebaseFirestore
        .collection('users')
        .doc(authController.user.uid)
        .get()
        .then((value) {
      if ((value.data()! as dynamic)['connecting'].contains(_uid.value)) {
        iAmConnecting = true;
      } else {
        iAmConnecting = false;
      }
    });

    //
    // firebaseFirestore
    //     .collection('users')
    //     .doc(authController.user.uid)
    //     .get()
    //     .then((value) {
    //   if ((value.data()! as dynamic).contains(_uid.value)) {
    //     isConnecting = true;
    //   } else {
    //     isConnecting = false;
    //   }
    // });

    _user.value = {
      'connections': connections.length,
      'connecting': connecting.length,
      'isConnected': isConnected,
      'isConnecting': isConnecting,
      'iAmConnecting': iAmConnecting,
      'reachedLimit': reachedLimit,
      'profilePic': profilePic,
      'username': username,
      'coverPic': coverPic,
    };
    update();
  }

  connect() async {
    var doc = await firebaseFirestore.collection('users').doc(_uid.value).get();

    // IF IS CONNECTED => REMOVE CONNECTION
    if ((doc.data()! as dynamic)['connections']
        .contains(authController.user.uid)) {
      await firebaseFirestore.collection('users').doc(_uid.value).update({
        'connections': FieldValue.arrayRemove([authController.user.uid])
      });
      await firebaseFirestore
          .collection('users')
          .doc(authController.user.uid)
          .update({
        'connections': FieldValue.arrayRemove([_uid.value])
      });
      _user.value.update('connections', (value) => value - 1);
      _user.value.update('isConnected', (value) => false);
    }
    //IF USER IS CONNECTING and USER HAS LESS THAN LIMIT CONNECTIONS => ADD CONNECTION, REMOVE CONNECTING
    else if ((doc.data()! as dynamic)['connecting']
        .contains(authController.user.uid) && !(_user.value['reachedLimit'])) {
      await firebaseFirestore.collection('users').doc(_uid.value).update({
        'connections': FieldValue.arrayUnion([authController.user.uid])
      });
      await firebaseFirestore
          .collection('users')
          .doc(authController.user.uid)
          .update({
        'connections': FieldValue.arrayUnion([_uid.value])
      });
      await firebaseFirestore
          .collection('users')
          .doc(authController.user.uid)
          .update({
        'connecting': FieldValue.arrayRemove([_uid.value])
      });
      await firebaseFirestore.collection('users').doc(_uid.value).update({
        'connecting': FieldValue.arrayRemove([authController.user.uid])
      });

      _user.value.update('connections', (value) => value + 1);
      _user.value.update('connecting', (value) => value - 1);
      _user.value.update('isConnected', (value) => true);
      _user.value.update('isConnecting', (value) => false);
      _user.value.update('iAmConnecting', (value) => false);
    }
    //IF I AM CONNECTING => REMOVE CONNECTING
    else if (_user.value['iAmConnecting']) {
      await firebaseFirestore
          .collection('users')
          .doc(authController.user.uid)
          .update({
        'connecting': FieldValue.arrayRemove([_uid.value])
      });
      _user.value.update('iAmConnecting', (value) => false);
    }
    //IF IS NOT CONNECTING => ADD CONNECTING
    else {
      await firebaseFirestore
          .collection('users')
          .doc(authController.user.uid)
          .update({
        'connecting': FieldValue.arrayUnion([_uid.value])
      });
      _user.value.update('iAmConnecting', (value) => true);
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
}
