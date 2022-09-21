import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moments/screens/camera_screen.dart';
import 'package:moments/screens/login_screen.dart';
import 'package:moments/screens/sign_up_screen.dart';

import 'responsive/mobile_screen_layout.dart';
import 'responsive/responsive_layout_screen.dart';
import 'responsive/web_screen_layout.dart';
import 'utils/colors.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAAndnjO5rVDsxJjCFFN2Bu988ulLGAd5Y',
        appId: '1:118833269793:web:de2f30e93d00f9820f6760',
        messagingSenderId: '118833269793',
        projectId: 'moments-a47d4',
        storageBucket: "moments-a47d4.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MomentsApp(
      // cameras: cameras,
      ));
}

class MomentsApp extends StatelessWidget {
  // final List<CameraDescription> cameras;
  const MomentsApp({
    Key? key,
    // required this.cameras
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moments',
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
          primaryColor: greenColor,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(primaryColor))),
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: greenColor)),
      home:

          const CameraScreen(),

          // const SignUpScreen(),

          // LoginScreen(),

      // ResponsiveLayout(
      //   mobileScreenLayout: MobileScreenLayout(),
      //   webScreenLayout: WebScreenLayout(),
      routes: {
        '/login_screen': (context) => const LoginScreen(),
        '/sign_up_screen': (context) => const SignUpScreen(),
      },
    );
  }
}
