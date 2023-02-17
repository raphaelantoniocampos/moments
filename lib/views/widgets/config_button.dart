import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:moments/constants.dart';

import '../screens/login_screen.dart';

class ConfigButton extends StatelessWidget {
  final Color color;

  ConfigButton({Key? key, this.color = primaryColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final randomColor = listColors[Random().nextInt(listColors.length)];
    return IconButton(
      onPressed: () {
        showDialog(
          barrierColor: blackTransparent,
          context: context,
          builder: (context) => Dialog(
            child: Container(
              decoration: BoxDecoration(
                color: randomColor,
                border: Border.all(width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(1.5, 1.5),
                  ),
                ],
              ),
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                shrinkWrap: true,
                children: [
                  InkWell(
                    onTap: () => Get.offAll(() => const LoginScreen()),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      child: const Text(
                        'Log out',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Helvetica Neue',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      icon: Icon(
        Icons.settings,
        color: color,
      ),
    );
  }
}
