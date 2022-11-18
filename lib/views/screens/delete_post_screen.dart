import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moments/controllers/post_controller.dart';

import '../../constants.dart';
import '../../resources/firestore_methods.dart';


class DeletePostScreen extends StatefulWidget {
  final String postId;

  const DeletePostScreen({Key? key, required this.postId}) : super(key: key);

  @override
  State<DeletePostScreen> createState() => _DeletePostScreenState();
}

class _DeletePostScreenState extends State<DeletePostScreen> {
  PostController postController = Get.put(PostController());
  double maxTime = 5;
  double currentTime = 0;

  void waitToDelete() {
    Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
      setState(() {
        if (currentTime >= maxTime) {
          timer.cancel();
          confirmDelete();
          // Navigator.of(context).pop();
        } else {
          currentTime += 0.1;
        }
      });
    });
  }

  void confirmDelete() {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Confirm delete',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: primaryColor),
                          onPressed: () async {
                            await postController.deletePost(widget.postId);
                            Navigator.of(context)
                              ..pop()
                              ..pop();
                          },
                          child: const Text(
                            'Delete',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: secondaryColor),
                          onPressed: () {
                            Navigator.of(context)
                              ..pop()
                              ..pop();
                          },
                          child: const Text(
                            'Cancel',
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ));
  }

  @override
  void initState() {
    waitToDelete();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 250,
              child: Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                  value: currentTime / maxTime,
                ),
              ),
            ),
            Text(
              NumberFormat('###.##', "en_US").format(currentTime),
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
