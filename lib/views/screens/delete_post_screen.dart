import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moments/controllers/post_controller.dart';

import '../../constants.dart';


class DeletePostScreen extends StatefulWidget {
  final String postId;

  const DeletePostScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _DeletePostScreenState createState() => _DeletePostScreenState();
}

class _DeletePostScreenState extends State<DeletePostScreen> {
  late final PostController _postController;
  final double _maxTime = 5;
  double _currentTime = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 100), _updateTimer);
    _postController = Get.put(PostController());
  }

  void _updateTimer(Timer timer) {
    setState(() {
      if (_currentTime >= _maxTime) {
        timer.cancel();
        _confirmDelete();
      } else {
        _currentTime += 0.1;
      }
    });
  }

  void _confirmDelete() {
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
                    style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                    onPressed: () async {
                      await _postController.deletePost(widget.postId);
                      Navigator.of(context)..pop()..pop();
                    },
                    child: const Text('Delete'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)..pop()..pop();
                    },
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
                  value: _currentTime / _maxTime,
                ),
              ),
            ),
            Text(
              NumberFormat('###.##', "en_US").format(_currentTime),
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

