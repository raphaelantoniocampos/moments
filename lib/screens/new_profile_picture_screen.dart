import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moments/layout/screen_layout.dart';
import 'package:moments/screens/feed_screen.dart';
import 'package:moments/screens/sign_up_screen.dart';
import 'dart:io';

import '../utils/colors.dart';
import 'camera_screen.dart';

class NewProfilePictureScreen extends StatefulWidget {
  const NewProfilePictureScreen({Key? key}) : super(key: key);

  @override
  State<NewProfilePictureScreen> createState() => _NewProfilePictureScreenState();
}

class _NewProfilePictureScreenState extends State<NewProfilePictureScreen> {
  File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Flexible(
              flex: 2,
              child: Container(),
            ),
            //svg image
            SvgPicture.asset(
              'assets/moments_logo.svg',
              color: primaryColor,
              height: 200,
            ),
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
                        final gettingImage = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CameraScreen(
                                      isRecordingAvailable: false,
                                    )));
                        print('print image: ${gettingImage.toString()}');
                        setState(() {
                          image = gettingImage;
                        });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScreenLayout(),
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
