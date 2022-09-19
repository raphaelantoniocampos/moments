import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'responsive/mobile_screen_layout.dart';
import 'responsive/responsive_layout_screen.dart';
import 'responsive/web_screen_layout.dart';
import 'utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

  runApp(const MomentsApp());
}

class MomentsApp extends StatelessWidget {
  const MomentsApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Moments',
        theme: ThemeData.dark()
            .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        home: const ResponsiveLayout(
          mobileScreenLayout: MobileScreenLayout(),
          webScreenLayout: WebScreenLayout(),
        ));
  }
}
