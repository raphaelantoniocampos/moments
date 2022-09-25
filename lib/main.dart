import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moments/providers/user_provider.dart';
import 'package:moments/screens/camera_screen.dart';
import 'package:moments/screens/loading_screen.dart';
import 'package:moments/screens/login_screen.dart';
import 'package:moments/screens/new_profile_picture_screen.dart';

import 'responsive/mobile_screen_layout.dart';
import 'responsive/responsive_layout_screen.dart';
import 'responsive/web_screen_layout.dart';
import 'utils/colors.dart';
import 'package:provider/provider.dart';


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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Moments',
        theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: mobileBackgroundColor,
            primaryColor: primaryColor,
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(primaryColor))),
            colorScheme:
                ColorScheme.fromSwatch().copyWith(secondary: primaryColor)),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.idTokenChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                    mobileScreenLayout: MobileScreenLayout(),
                    webScreenLayout: WebScreenLayout());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            return const LoginScreen();
          },
        ),

        // const LoginScreen(),

        // CameraScreen(startWithRearCamera: false,),

        // const SignUpScreen(),

        routes: {
          '/login_screen': (context) => const LoginScreen(),
          '/camera_screen': (context) => CameraScreen(),
          '/new_profile_picture_screen': (context) => const NewProfilePicture(),
          'loading_screen': (context) => const LoadingScreen(),
        },
      ),
    );
  }
}
