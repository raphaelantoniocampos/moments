import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moments/views/screens/user_list_screen.dart';
import 'package:moments/views/widgets/comment_card.dart';
import 'package:moments/views/widgets/profile_button.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:moments/controllers/comment_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../constants.dart';

class CommentScreen extends StatefulWidget {
  final String postId;

  const CommentScreen({Key? key, required this.postId}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {

  // final TextEditingController _commentController = TextEditingController();
  bool isLoading = false;

  CommentController commentController = Get.put(
    CommentController(),
  );

  // void initializer() async {
  //   pathToAudio = 'sdcard/Download/temp.wav';
  //   Directory directory = Directory(path.dirname(pathToAudio));
  //   if (!directory.existsSync()) {
  //     directory.createSync();
  //   }
  //   _recordingSession = FlutterSoundRecorder();
  //   await _recordingSession.openRecorder();
  //   await _recordingSession.setSubscriptionDuration(const Duration(
  //       milliseconds: 10));
  // }

  @override
  void initState() {
    commentController.updatePostId(widget.postId);
    // initializer();
    // getPermissionStatus();
    super.initState();
  }

  // getPermissionStatus() async {
  //   await Permission.microphone.request();
  //   await Permission.storage.request();
  //   await Permission.manageExternalStorage.request();
  //   var status = await Permission.microphone.request();
  //   var status2 = await Permission.storage.request();
  //   var status3 = await Permission.manageExternalStorage.request();
  //   if (status.isGranted) {
  //     print(' storage request ${status2.isGranted}');
  //     print(' external request ${status3.isGranted}');
  //     debugPrint('Microphone Permission: Granted');
  //   } else {
  //     debugPrint('Microphone Permission: Denied');
  //   }
  // }

  // Future<void> startRecording() async {
  //   _recordingSession.openRecorder();
  //   await _recordingSession.startRecorder(
  //     toFile: 'path/to/recording.wav',
  //     codec: Codec.pcm16WAV,
  //   );
  //   // StreamSubscription _recorderSubscription =
  //   _recordingSession.onProgress!.listen((e) {
  //     var date = DateTime.fromMillisecondsSinceEpoch(
  //         e.duration.inMilliseconds,
  //         isUtc: true);
  //     var timeText = DateFormat('mm:ss:SS', 'en_GB').format(date);
  //     setState(() {
  //       _timerText = timeText.substring(0, 8);
  //     });
  //   });
  // }
  //
  // Future<String?> stopRecording() async {
  //   _recordingSession.closeRecorder();
  //   return await _recordingSession.stopRecorder();
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Comments"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          height: size.height - 80,
          child: Column(
            children: [
              Expanded(
                child: Obx(() {
                  final comments = commentController.comments;
                  return ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return FutureBuilder(
                            future: firebaseFirestore
                                .collection('users')
                                .where('uid', isEqualTo: comment.uid)
                                .get(),
                            builder: (context,
                                AsyncSnapshot<
                                    QuerySnapshot<
                                        Map<String, dynamic>>>
                                snapshot) {
                              if (snapshot.hasError ||
                                  !snapshot.hasData) {
                                return const ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: primaryColor,
                                    backgroundImage:
                                    NetworkImage(initialProfilePic),
                                  ),
                                );
                              }
                              final user = snapshot.data!.docs[0].data();
                              return CommentCard(
                                  user: user, comment: comment);
                            });
                      });
                }),
              ),
              const Divider(),
              Row(
                children: [
                  GestureDetector(
                    onLongPress: () {
                      commentController.startRecording();
                    },
                    onLongPressUp: (){
                      commentController.stopRecording();
                      commentController.postComment(widget.postId);
                    },
                    child: Icon(
                      Icons.play_circle,
                      size: 40,
                    ),
                  ),
                  // Text(_timerText)
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              // ListTile(
              //   title: TextFormField(
              //     controller: _commentController,
              //     style:
              //         const TextStyle(fontSize: 16, color: Colors.black),
              //     decoration: const InputDecoration(
              //       labelText: "Comment",
              //       labelStyle: TextStyle(
              //           fontSize: 20,
              //           color: secondaryColor,
              //           fontWeight: FontWeight.w700),
              //       enabledBorder: UnderlineInputBorder(
              //         borderSide: BorderSide(color: primaryColor),
              //       ),
              //       focusedBorder: UnderlineInputBorder(
              //         borderSide: BorderSide(color: primaryColor),
              //       ),
              //     ),
              //   ),
              //   trailing: IconButton(
              //     onPressed: () {
              //       // commentController
              //       //     .postComment(_commentController.text);
              //       // _commentController.text = '';
              //     },
              //     icon: const Icon(
              //       Icons.send,
              //       color: secondaryColor,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
