import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moments/utils/colors.dart';

import '../main.dart';

class CameraScreen extends StatefulWidget {
  // start camera
  // 0 back
  // 1 front
  final int startCamera;

  const CameraScreen({Key? key, required this.startCamera}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? controller;
  bool _isCameraInitialized = false;
  double _minZoom = 1.0;
  double _maxZoom = 1.0;
  double _currentZoom = 1.0;

  final resolutionPresets = ResolutionPreset.values;
  ResolutionPreset currentResolutionPreset = ResolutionPreset.high;

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraControler = controller;
    final CameraController cameraController = CameraController(
      cameraDescription,
      currentResolutionPreset,
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

    //Get zoom levels
    cameraController.getMaxZoomLevel().then((value) => _maxZoom = value);
    cameraController.getMinZoomLevel().then((value) => _minZoom = value);
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    onNewCameraSelected(cameras[widget.startCamera]);
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

    if (state == AppLifecycleState.inactive) {
      //Free up memory when camera is not active
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      //Reinitialize camera
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isCameraInitialized
          ? Center(
              child: AspectRatio(
                aspectRatio: 1 / controller!.value.aspectRatio,
                child: Stack(
                  children: [
                    controller!.buildPreview(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        16.0,
                        8.0,
                        16.0,
                        8.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8, left: 8),
                              child: DropdownButton(
                                dropdownColor: blackTransparent,
                                underline: Container(),
                                value: currentResolutionPreset,
                                items: [
                                  for (ResolutionPreset preset
                                      in resolutionPresets)
                                    DropdownMenuItem(
                                      value: preset,
                                      child: Text(
                                        preset
                                            .toString()
                                            .split('.')[1]
                                            .toUpperCase(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    )
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    currentResolutionPreset =
                                        value! as ResolutionPreset;
                                    _isCameraInitialized = false;
                                  });
                                  onNewCameraSelected(controller!.description);
                                },
                                hint: const Text('Select item'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8, left: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Slider(
                                      value: _currentZoom,
                                      min: _minZoom,
                                      max: _maxZoom,
                                      activeColor: Colors.white,
                                      inactiveColor: Colors.black12,
                                      onChanged: (value) async {
                                        setState(() {
                                          _currentZoom = value;
                                        });
                                        await controller!.setZoomLevel(value);
                                      }),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius:
                                          BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${_currentZoom.toStringAsFixed(1)}x',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          : Container(),
    );
  }
}