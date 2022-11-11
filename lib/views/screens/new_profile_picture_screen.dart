import 'package:flutter/material.dart';
import 'package:moments/controllers/upload_post_controller.dart';
import 'package:moments/views/screens/main_screen.dart';
import 'package:moments/controllers/profile_pic_controller.dart';

import '../../constants.dart';
import 'camera_screen.dart';
import 'loading_screen.dart';

class NewProfilePictureScreen extends StatefulWidget {
  const NewProfilePictureScreen({Key? key}) : super(key: key);

  @override
  State<NewProfilePictureScreen> createState() =>
      _NewProfilePictureScreenState();
}

class _NewProfilePictureScreenState extends State<NewProfilePictureScreen> {
  bool isLoading = false;

  Future<String> _uploadPost(image) async {
    setState(() {
      isLoading = true;
    });
    return await UploadPostController().uploadPost(image);
  }

  void _changeProfilePic(String downloadUrl) async {
    ProfilePicController().changeProfilePic(downloadUrl);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const LoadingScreen()
        : Scaffold(
            body: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                width: double.infinity,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Container(),
                      ),
                      const Text("moments"),
                      const Center(
                        child: Text(
                          'Take your profile pic',
                          style: TextStyle(fontSize: 20, color: secondaryColor),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),

                      // add photo widget
                      Stack(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.white38,
                            radius: 150,
                            backgroundImage: NetworkImage(
                                'https://www.pngall.com/wp-content/uploads/5/Profile-PNG-File.png'),
                          ),
                          Positioned(
                              bottom: 0,
                              left: 200,
                              child: IconButton(
                                color: primaryColor,
                                iconSize: 50,
                                onPressed: () async {
                                  final image = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CameraScreen(
                                        isRecordingAvailable: false,
                                      ),
                                    ),
                                  );
                                  String downloadUrl = await _uploadPost(image);
                                  _changeProfilePic(downloadUrl);

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MainScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.add_a_photo),
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Flexible(
                        flex: 2,
                        child: Container(),
                      ),
                    ]),
              ),
            ),
          );
  }
}
