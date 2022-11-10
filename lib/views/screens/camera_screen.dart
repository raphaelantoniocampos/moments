import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants.dart';
import '../../main.dart';

class CameraScreen extends StatefulWidget {
  bool startWithRearCamera;
  bool isRecordingAvailable;

  CameraScreen(
      {Key? key,
      this.startWithRearCamera = false,
      this.isRecordingAvailable = true})
      : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? controller;
  VideoPlayerController? videoController;

  File? imageFile;
  File? videoFile;

  final resolutionPresets = ResolutionPreset.values;
  ResolutionPreset currentResolutionPreset = ResolutionPreset.max;

  //initial values
  bool _isCameraInitialized = false;
  double _minZoom = 1.0;
  double _maxZoom = 1.0;
  // double _minExposureOffset = 0.0;
  // double _maxExposureOffset = 0.0;
  bool _isRearCameraSelected = true;
  bool _isRecordingInProgress = false;
  bool _isCameraPermissionGranted = false;

  //current values

  // double _currentExposureOffset = 0.0;
  double _currentZoom = 1.0;
  FlashMode? _currentFlashMode;

  getPermissionStatus() async {
    await Permission.camera.request();
    var status = await Permission.camera.status;
    if (status.isGranted) {
      debugPrint('Camera Permission: Granted');
      setState(() {
        _isCameraPermissionGranted = true;
      });
      onNewCameraSelected(cameras[widget.startWithRearCamera ? 0 : 1]);
    } else {
      debugPrint('Camera Permission: Denied');
    }
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;
    final CameraController cameraController = CameraController(
      cameraDescription,
      currentResolutionPreset,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // Dispose previous controller
    await previousCameraController?.dispose();

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
      debugPrint('Error initializing camera: $err');
    }

    if (mounted) {
      setState(() {
        _isCameraInitialized = controller!.value.isInitialized;
      });
    }

    //Get zoom levels
    cameraController.getMaxZoomLevel().then((value) => _maxZoom = value);
    cameraController.getMinZoomLevel().then((value) => _minZoom = value);

    //Get exposure levels
    // cameraController
    //     .getMaxExposureOffset()
    //     .then((value) => _maxExposureOffset = value);
    // cameraController
    //     .getMinExposureOffset()
    //     .then((value) => _minExposureOffset = value);

    // _currentFlashMode = controller!.value.flashMode;
    _currentFlashMode = FlashMode.off;
  }

  Future<void> startVideoRecording() async {
    final CameraController? cameraController = controller;
    if (controller!.value.isRecordingVideo) {
      return;
    }
    try {
      await cameraController!.startVideoRecording();
      setState(() {
        _isRecordingInProgress = true;
        // showSnackBar('Recording', context);
      });
    } on CameraException catch (err) {
      // showSnackBar('Error starting to record video: $err', context);
    }
  }

  Future<XFile?> stopVideoRecording() async {
    if (!controller!.value.isRecordingVideo) {
      return null;
    }
    try {
      XFile file = await controller!.stopVideoRecording();
      setState(() {
        _isRecordingInProgress = false;
        debugPrint('Stopped recording');
      });
      return file;
    } on CameraException catch (err) {
      debugPrint('Error stopping video recording: $err');
      return null;
    }
  }

  Future<void> _startVideoPlayer() async {
    if (videoFile != null) {
      videoController = VideoPlayerController.file(videoFile!);
      await videoController!.initialize().then((_) {
        setState(() {});
      });
      await videoController!.setLooping(true);
      await videoController!.play();
    }
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController!.value.isTakingPicture) {
      return null;
    }
    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (err) {
      debugPrint('Error occurred while taking picture: $err');
      return null;
    }
  }

  Future<void> saveImage(BuildContext context, VoidCallback onSuccess) async {
    XFile? rawImage = await takePicture();
    imageFile = File(rawImage!.path);
    onSuccess.call();
  }

  Future<void> saveVideo(BuildContext context, VoidCallback onSuccess) async {
    if (widget.isRecordingAvailable) {
      XFile? rawVideo = await stopVideoRecording();
      videoFile = File(rawVideo!.path);
      _startVideoPlayer();
    }
    onSuccess.call();
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }
    final Offset offset = Offset(
        details.localPosition.dx / constraints.maxWidth,
        details.localPosition.dy / constraints.maxHeight);
    controller!.setExposurePoint(offset);
    controller!.setFocusPoint(offset);
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    _isRearCameraSelected = widget.startWithRearCamera;
    getPermissionStatus();
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    videoController?.dispose();
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
      body: _isCameraPermissionGranted
          ? _isCameraInitialized
              ? Column(children: [
                  AspectRatio(
                    aspectRatio: 1 / controller!.value.aspectRatio,
                    child: Stack(
                      children: [
                        CameraPreview(
                          controller!,
                          child: LayoutBuilder(builder: (BuildContext context,
                              BoxConstraints constraints) {
                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTapDown: (details) =>
                                  onViewFinderTap(details, constraints),
                            );
                          }),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            16.0,
                            8.0,
                            16.0,
                            8.0,
                          ),
                          child: Column(
                            verticalDirection: VerticalDirection.up,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Quality selector
                              // Align(
                              //   alignment: Alignment.topRight,
                              //   child: Padding(
                              //     padding:
                              //         const EdgeInsets.only(right: 8, left: 8),
                              //     child: DropdownButton(
                              //       dropdownColor: Colors.black12,
                              //       underline: Container(),
                              //       value: currentResolutionPreset,
                              //       items: [
                              //         for (ResolutionPreset preset
                              //             in resolutionPresets)
                              //           DropdownMenuItem(
                              //             value: preset,
                              //             child: Text(
                              //               preset
                              //                   .toString()
                              //                   .split('.')[1]
                              //                   .toUpperCase(),
                              //               style: const TextStyle(
                              //                   color: Colors.white),
                              //             ),
                              //           )
                              //       ],
                              //       onChanged: (value) {
                              //         setState(() {
                              //           currentResolutionPreset =
                              //               value! as ResolutionPreset;
                              //           _isCameraInitialized = false;
                              //         });
                              //         onNewCameraSelected(
                              //             controller!.description);
                              //       },
                              //       hint: const Text('Select item'),
                              //     ),
                              //   ),
                              // ),

                              //Exposure text
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: ValueToStringContainer(
                              //       value: _currentExposureOffset),
                              // ),

                              // Exposure slider
                              // Expanded(
                              //     child: RotatedBox(
                              //   quarterTurns: 3,
                              //   child: Container(
                              //     height: 30,
                              //     child: Slider(
                              //         value: _currentExposureOffset,
                              //         min: _minExposureOffset,
                              //         max: _maxExposureOffset,
                              //         activeColor: Colors.white,
                              //         inactiveColor: Colors.black12,
                              //         onChanged: (value) async {
                              //           setState(() {
                              //             _currentExposureOffset = value;
                              //           });
                              //           await controller!
                              //               .setExposureOffset(value);
                              //         }),
                              //   ),
                              // )),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(
                                    width: 60,
                                    height: 60,
                                  ),

                                  //TakePicture/Record
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          saveImage(context, () {
                                            // if(mounted) return;
                                            Navigator.pop(context, imageFile);
                                          });
                                        },
                                        onLongPress: () async {
                                          if (widget.isRecordingAvailable) {
                                            await startVideoRecording();
                                          }
                                        },
                                        onLongPressUp: () {
                                          saveVideo(context, () {
                                            // if(mounted) return;
                                            Navigator.pop(context, videoFile);
                                          });
                                        },
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            const Icon(
                                              Icons.circle,
                                              color: Colors.white38,
                                              // color: Colors.white38,
                                              size: 80,
                                            ),
                                            Icon(
                                              Icons.circle,
                                              color: _isRecordingInProgress
                                                  ? primaryColor
                                                  : Colors.white38,
                                              size: 65,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Text(
                                        'Tap for photo, hold for video',
                                        style: TextStyle(
                                            color: backgroundColor),
                                      )
                                    ],
                                  ),

                                  // Camera selector
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _isCameraInitialized = false;
                                      });
                                      onNewCameraSelected(
                                        cameras[_isRearCameraSelected ? 1 : 0],
                                      );
                                      setState(() {
                                        _isRearCameraSelected =
                                            !_isRearCameraSelected;
                                      });
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        const Icon(
                                          Icons.circle,
                                          color: Colors.black12,
                                          size: 60,
                                        ),
                                        Icon(
                                          _isRearCameraSelected
                                              ? Icons.photo_camera_back
                                              : Icons.camera_front,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ],
                                    ),
                                  ),

                                  //Preview files
                                  // Container(
                                  //   width: 60,
                                  //   height: 60,
                                  //   decoration: BoxDecoration(
                                  //     color: Colors.black,
                                  //     borderRadius: BorderRadius.circular(10.0),
                                  //     border: Border.all(
                                  //         color: Colors.white, width: 2),
                                  //     image: imageFile != null
                                  //         ? DecorationImage(
                                  //             image: FileImage(imageFile!),
                                  //             fit: BoxFit.cover,
                                  //           )
                                  //         : null,
                                  //   ),
                                  //   child: videoController != null &&
                                  //           videoController!.value.isInitialized
                                  //       ? ClipRRect(
                                  //           borderRadius:
                                  //               BorderRadius.circular(8.0),
                                  //           child: AspectRatio(
                                  //             aspectRatio: videoController!
                                  //                 .value.aspectRatio,
                                  //             child:
                                  //                 VideoPlayer(videoController!),
                                  //           ),
                                  //         )
                                  //       : Container(),
                                  // ),
                                ],
                              ),

                              //Zoom slider
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 8, left: 8),
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
                                            await controller!
                                                .setZoomLevel(value);
                                          }),
                                    ),
                                    ValueToStringContainer(value: _currentZoom)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Flash mode selector
                  Expanded(
                      child: Container(
                    color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              setState(() {
                                _currentFlashMode = FlashMode.off;
                              });
                              await controller!.setFlashMode(FlashMode.off);
                            },
                            child: Icon(
                              Icons.flash_off,
                              color: _currentFlashMode == FlashMode.off
                                  ? primaryColor
                                  : Colors.white,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              setState(() {
                                _currentFlashMode = FlashMode.auto;
                              });
                              await controller!.setFlashMode(FlashMode.auto);
                            },
                            child: Icon(
                              Icons.flash_auto,
                              color: _currentFlashMode == FlashMode.auto
                                  ? primaryColor
                                  : Colors.white,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              setState(() {
                                _currentFlashMode = FlashMode.always;
                              });
                              await controller!.setFlashMode(FlashMode.always);
                            },
                            child: Icon(
                              Icons.flash_on,
                              color: _currentFlashMode == FlashMode.always
                                  ? primaryColor
                                  : Colors.white,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              setState(() {
                                _currentFlashMode = FlashMode.torch;
                              });
                              await controller!.setFlashMode(FlashMode.torch);
                            },
                            child: Icon(
                              Icons.highlight,
                              color: _currentFlashMode == FlashMode.torch
                                  ? primaryColor
                                  : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
                ])
              : Container()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(),
                const Text(
                  'Permission denied',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                    onPressed: getPermissionStatus,
                    child: const Text('Give Permission')),
              ],
            ),
    );
  }
}

class ValueToStringContainer extends StatefulWidget {
  double value;

  ValueToStringContainer({Key? key, required this.value}) : super(key: key);

  @override
  State<ValueToStringContainer> createState() => _ValueToStringContainerState();
}

class _ValueToStringContainerState extends State<ValueToStringContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black12, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          '${widget.value.toStringAsFixed(1)}x',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
