import 'dart:async';

import 'package:flutter/material.dart';

class DeletePostScreen extends StatefulWidget {
  const DeletePostScreen({Key? key}) : super(key: key);

  @override
  State<DeletePostScreen> createState() => _DeletePostScreenState();
}

class _DeletePostScreenState extends State<DeletePostScreen> {
  double value = 1;

  void waitToDelete() {
    Timer.periodic(const Duration(milliseconds: 1), (Timer timer) {
      setState(() {
        if (value <= 0) {
          timer.cancel();
          Navigator.of(context).pop();
        } else {
          value = value - 0.0001;
        }
      });
    });
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
        child: Center(
          child: CircularProgressIndicator(
            value: value,
          ),
        ),
      ),
    );
  }
}
