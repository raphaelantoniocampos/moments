import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moments/providers/user_provider.dart';
import 'package:moments/screens/loading_screen.dart';
import 'package:moments/screens/login_screen.dart';
import 'package:moments/utils/global_variables.dart';

import 'layout/mobile_screen_layout.dart';
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
      child: MaterialApp(
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
        home: StreamBuilder(
          stream: FirebaseAuth.instance.idTokenChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const MobileScreenLayout();
              } else if (snapshot.hasError) {
                return const LoginScreen();
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingScreen();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
