import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver{
  CameraController? controller;
  bool _isCameraInitialized = false;

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraControler = controller;
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // Dispose previous controller
    await previousCameraControler?.dispose();

    //Replace with new controller
    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }

    //Update UI
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    //Initialize controller
    try {
      await cameraController.initialize();
    } on CameraException catch (err) {
      print('Error initializing camera: $err');
    }

    if (mounted) {
      setState(() {
        _isCameraInitialized = controller!.value.isInitialized;
      });
    }
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    onNewCameraSelected(cameras[0]);
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    //App state changed before initializing
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive){
      //Free up memory when camera is not active
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed){
      //Reinitialize camera
      onNewCameraSelected(cameraController.description);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isCameraInitialized ? AspectRatio(
          aspectRatio: 1 / controller!.value.aspectRatio,
      child: controller!.buildPreview(),
      )
          : Container(),
    );
  }
}
