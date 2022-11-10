import 'package:flutter/material.dart';

import '../../constants.dart';


class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        child: const Center(
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        ),
      ),
    );
  }
}
