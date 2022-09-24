import 'package:flutter/material.dart';
import 'package:moments/utils/colors.dart';

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      content,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: secondaryColor,
  ));
}
