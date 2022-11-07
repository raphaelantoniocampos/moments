import 'package:flutter/material.dart';
import 'package:moments/utils/constants.dart';

import '../screens/login_screen.dart';

class ConfigButton extends StatelessWidget {
  const ConfigButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          barrierColor: blackTransparent,
          context: context,
          builder: (context) => Dialog(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ),
              shrinkWrap: true,
              children: [
                InkWell(
                  onTap: () async {
                    await authController.signOut();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: const Text('Log out'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      icon: const Icon(Icons.settings),
    );
  }
}
