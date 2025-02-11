import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../app_helper/route.dart';
import '../main.dart';
import '../widget/camera_button_widget.dart';
import 'home_page.dart';

class CameraServicePage extends StatefulWidget {
  const CameraServicePage({Key? key, required this.type}) : super(key: key);

  final CameraMediaType type;

  @override
  State<CameraServicePage> createState() => _CameraServicePageState();
}

class _CameraServicePageState extends State<CameraServicePage> with WidgetsBindingObserver {
  CameraController? cameraController;
  int lensDirectionValue = 0;
  IconData cameraLensIcon = (Platform.isAndroid) ? Icons.flip_camera_android_outlined : Icons.flip_camera_ios;

  XFile? imageFile;
  XFile? videoFile;
  bool isVideoRecording = false;
  bool isPaused = false;
  late Timer timer;
  int tickValue = 0;
  int inMinute = 0;
  int inMilliSecond = 0;
  bool hasOpacity = true;
  String mediaFilesDir = '';

  void initializeAvailableCamera() async {
    camera = await availableCameras();
    if (camera.isEmpty) {
      // print("camera empty");
      camera = await availableCameras();
    } else {
      // print("camera list: $camera ");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initializeAvailableCamera();
    // print("list of cameras : $camera");
    initializeCameraController(switchCameraLensValue: lensDirectionValue);
  }

  void initializeCameraController({required int switchCameraLensValue}) async {
    if (cameraController != null) {
      await cameraController!.dispose();
    }
    cameraController = CameraController(
      camera[switchCameraLensValue],
      ResolutionPreset.medium,
      imageFormatGroup: (Platform.isAndroid) ? ImageFormatGroup.jpeg : ImageFormatGroup.bgra8888,
    );

    // print("cameraController : ${cameraController!.description}");
    // print("cameraController : ${cameraController!.cameraId}");
    // print("cameraController : ${cameraController!.value}");
    await cameraController!.initialize().then(
      (value) {
        // print("then init : ${cameraController!.cameraId}");
        if (!mounted) {
          return;
        }
        setState(() {});
      },
    ).catchError((Object e) {
      if (e is CameraException) {
        // print("camera exception : ${e.description}");
        // print("camera exception : ${e.code}");
      } else {
        // print('@ error occurred : ${e.toString()}');
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      cameraController!.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initializeCameraController(switchCameraLensValue: lensDirectionValue);
    }
  }

  @override
  void dispose() {
    cameraController!.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.only(top: 50),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: (camera.isEmpty)
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              )
            : Stack(
                fit: StackFit.expand,
                children: [
                  (cameraController != null || cameraController!.value.isInitialized)
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CameraPreview(cameraController!),
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      color: Colors.black,
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          recordingTimerWidget(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              CameraCapturingButtonWidget(
                                onPressed: switchCameraLensOnPressed,
                                icon: cameraLensIcon,
                                size: 30,
                              ),
                              (widget.type == CameraMediaType.video)
                                  ? CameraCapturingButtonWidget(
                                      onPressed: (isVideoRecording)
                                          ? stopRecordingVideoOnPressed
                                          : startRecordingVideoOnPressed,
                                      icon: (isVideoRecording) ? Icons.stop_circle : CupertinoIcons.videocam_circle,
                                      size: 50,
                                    )
                                  : CameraCapturingButtonWidget(
                                      onPressed: captureImageOnPressed,
                                      icon: Icons.camera,
                                      size: 50,
                                    ),
                              (isVideoRecording)
                                  ? CameraCapturingButtonWidget(
                                      onPressed:
                                          isPaused ? resumeRecordingVideoOnPressed : pauseRecordingVideoOnPressed,
                                      icon: isPaused ? Icons.play_circle_outline : Icons.pause_circle_outline,
                                      size: 30,
                                    )
                                  : CameraCapturingButtonWidget(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icons.exit_to_app_outlined,
                                      size: 30,
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<String> retrievingPathForStorage(String extension) async {
    Directory? data;
    if (Platform.isAndroid) {
      data = await getExternalStorageDirectory();
    } else {
      data = await getDownloadsDirectory();
    }
    // print("getApplication path : ${data!.path}");
    var time = DateTime.now().millisecondsSinceEpoch.toString();
    mediaFilesDir = "${data?.path}/Media Files/";
    await Directory(mediaFilesDir).create(recursive: true);

    var path = (extension == 'mp4') ? "${mediaFilesDir}video$time.$extension" : "${mediaFilesDir}image_$time.$extension";
    // print("dir path @@ : $path");
    return path;
  }

  void captureImageOnPressed() async {
    // print("camera capturing");
    try {
      imageFile = await cameraController!.takePicture();
      // print("imageFile path : ${imageFile!.path}");

      var path = await retrievingPathForStorage('jpeg');
      await imageFile!.saveTo(path);
      Future.delayed(const Duration(milliseconds: 300), () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image saved to $path'),
          ),
        );

        Navigator.pushNamed(
          context,
          Routes.imagePreview,
          arguments: {"path": path},
        );
      });
    } catch (e) {
      if (kDebugMode) {
        print("e : $e");
      }
    }
  }

  void switchCameraLensOnPressed() {
    if (lensDirectionValue == 0) {
      lensDirectionValue = 1;
    } else {
      lensDirectionValue = 0;
    }
    initializeCameraController(switchCameraLensValue: lensDirectionValue);
  }

  void startRecordingVideoOnPressed() async {
    // print("camera video capturing started .");
    isVideoRecording = !isVideoRecording;
    setTimerCountDown();
    if (cameraController!.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }
    try {
      //await cameraController!.prepareForVideoRecording();
      await cameraController!.startVideoRecording();
      setState(() {});
    } catch (e) {
      // print("stop video : $e");
    }
  }

  void stopRecordingVideoOnPressed() async {
    // print("camera video stopped .");
    if (!cameraController!.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }
    isVideoRecording = !isVideoRecording;
    setTimerCountDown();
    setState(() {});

    try {
      var file = await cameraController!.stopVideoRecording();
      // print("video stop file data : ${file.path}");

      var path = await retrievingPathForStorage('mp4');
      await file.saveTo(path);
      getThumbnailFileData(path);
      Future.delayed(const Duration(milliseconds: 300), () {
        Navigator.pushNamed(
          context,
          Routes.videoPreview,
          arguments: {"path": path},
        );
      });
    } catch (e) {
      if (kDebugMode) {
        print("stop video : $e");
      }
    }
  }

  void resumeRecordingVideoOnPressed() async {
    // print("camera video resume .");
    isPaused = false;
    setTimerCountDown();
    try {
      await cameraController!.resumeVideoRecording();
      // print("video resume");
    } catch (e) {
      // print("stop video : $e");
    }
  }

  void pauseRecordingVideoOnPressed() async {
    // print("camera video pause .");
    isPaused = true;
    try {
      await cameraController!.pauseVideoRecording();
      // print("video pause");
    } catch (e) {
      // print("stop video : $e");
    }
  }

  void setTimerCountDown() {
    if (isVideoRecording) {
      timer = Timer.periodic(
        const Duration(seconds: 1),
        (_) {
          try {
            if (isPaused) {
              tickValue = timer.tick + tickValue - 1;
              // print("tick value : $tickValue");
              timer.cancel();
            } else {
              if (timer.tick > 60) {
                //timer.cancel();
                inMinute = (timer.tick + tickValue) ~/ 60;
                inMilliSecond = ((timer.tick + tickValue) % 60).toInt();
                // print("time in tick : $inMinute : $inMilliSecond");
              } else {
                inMilliSecond = ((timer.tick + tickValue) % 60).toInt();
              }
            }
            hasOpacity = !hasOpacity;
            setState(() {});
          } catch (e) {
            // print("error occured : $e");
          }
        },
      );
    } else {
      tickValue = 0;
      inMilliSecond = 0;
      timer.cancel();
    }
  }

  void getThumbnailFileData(String path) async {
    try {
      var thumbnail = await VideoThumbnail.thumbnailFile(
        video: path,
      );
      // print("thumbnail data : ${thumbnail?.length}");
      // print("thumbnail data ! : $thumbnail");
    } catch (e) {
      // print('Thumbnail Error Occurred : $e');
    }
  }

  Widget recordingTimerWidget() {
    return (isVideoRecording)
        ? Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Opacity(
                  opacity: hasOpacity ? 1 : 0.5,
                  child: const CircleAvatar(
                    maxRadius: 5,
                    backgroundColor: Colors.red,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  (inMinute > 9)
                      ? '$inMinute:0$inMilliSecond'
                      : (inMilliSecond > 9)
                          ? '0$inMinute:$inMilliSecond'
                          : '0$inMinute:0$inMilliSecond',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          )
        : const Center();
  }
}
