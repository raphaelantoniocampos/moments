import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:moments/constants.dart';
import 'package:moments/providers/user_provider.dart';
import 'package:get/get.dart';
import 'package:moments/views/screens/loading_screen.dart';
import 'package:moments/views/screens/login_screen.dart';

import 'controllers/auth_controller.dart';
import 'views/screens/main_screen.dart';
import 'package:provider/provider.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  await Firebase.initializeApp().then(
    (value) => Get.put(
      AuthController(),
    ),
  );

  runApp(
    const MomentsApp(),
  );
}

class MomentsApp extends StatelessWidget {
  const MomentsApp({
    Key? key,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Moments',
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: backgroundColor,
          primaryColor: primaryColor,
          appBarTheme: const AppBarTheme(
              backgroundColor: backgroundColor,
              elevation: appBarElevation,
              foregroundColor: primaryColor),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(primaryColor),
            ),
          ),
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: primaryColor),
        ),
        home: const LoadingScreen(),
      ),
    );
  }
}
