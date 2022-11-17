import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:moments/controllers/post_controller.dart';
import 'package:moments/controllers/profile_controller.dart';
import 'package:moments/controllers/search_controller.dart';
import 'package:moments/views/screens/main_screen.dart';
import 'package:path_provider/path_provider.dart';


import 'package:moments/models/user.dart' as model;
import '../constants.dart';
import '../views/screens/login_screen.dart';
import '../views/screens/new_profile_picture_screen.dart';
import 'comment_controller.dart';

class AuthController extends GetxController {
  final ProfileController profileController = Get.put(ProfileController());
  final CommentController commentController = Get.put(CommentController());
  final PostController postController = Get.put(PostController());
  final SearchController searchController = Get.put(SearchController());
  static AuthController instance = Get.find();
  late Rx<User?> _user;

  User get user => _user.value!;

  @override
  void onReady() {
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(
      firebaseAuth.authStateChanges(),
    );
    ever(_user, _setInitialScreen);
    super.onReady();
  }

  _setInitialScreen(User? user) async {
    if (user == null) {
      Get.offAll(
        () => const LoginScreen(),
      );
    } else {
      model.User modelUser = await getUserDetails();
      if (modelUser.profilePic == initialProfilePic) {
        Get.offAll(
          () => const NewProfilePictureScreen(),
        );
      } else {
        Get.offAll(
          () => const MainScreen(),
        );
      }
    }
  }

  //registering the user
  void registerUser(String username, String email, String password) async {
    String res;
    try {
      if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        //save user to auth and firebase firestore
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
        // String downloadUrl = await _uploadToStorage(image);
        model.User user = model.User(
            profilePic: initialProfilePic,
            coverPic: initialCoverPic,
            uid: cred.user!.uid,
            username: username,
            public: [],
            hiding: [],
            connecting: [],
            connections: [],
            email: email);
        await firebaseFirestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
        res = 'Success';
      } else {
        res = 'Please enter all the fields';
      }
    } catch (err) {
      res = err.toString();
    }
    Get.snackbar('Creating account', res);
  }

  void loginUser(String email, String password) async {
    String res = '';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'Success';
      } else {
        res = 'Please enter all the fields';
      }
    } catch (err) {
      res = err.toString();
    }
    Get.snackbar('Logging in', res);
  }

  Future<model.User> getUserDetails() async {
    User currentUser = firebaseAuth.currentUser!;

    DocumentSnapshot snap = (await firebaseFirestore
        .collection('users')
        .doc(currentUser.uid)
        .get());

    return model.User.fromSnap(snap);
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
    Get.delete<CommentController>();
    Get.delete<PostController>();
    Get.delete<ProfileController>();
    Get.delete<SearchController>();

  }

}
