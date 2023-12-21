import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite_v2/tflite_v2.dart';

import 'main.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CameraImage? imgCamera; // CameraImage might be null initially
  CameraController? cameraController; // Same for CameraController
  bool isWorking = false;
  String result = "";

  // This function is for to access the live camera of the device
  void initCamera() {
    cameraController = CameraController(cameras![0], ResolutionPreset.medium);

    cameraController!.initialize().then((value) {
      if (!mounted) {
        return;
      }

      setState(() {
        cameraController!.startImageStream((imageFromStream) {
          if (!isWorking) {
            isWorking = true;
            imgCamera = imageFromStream;
            runModelOnFrame();
          }
        });
      });
    });
  }

  runModelOnFrame() async {
    if (imgCamera != null) {
      var recognitions = await Tflite.runModelOnFrame(
        bytesList: imgCamera!.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: imgCamera!.height,
        imageWidth: imgCamera!.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 1,
        threshold: 0.1,
        asynch: true,
      );
      result = " ";

      recognitions!.forEach((response) {
        result += response["label"] + "\n";
      });
      setState(() {
        result;
      });
      isWorking = false;
    }
  }

  // This function is for to access the Models of the data set

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
    );
  }

  @override
  void initState() {
    super.initState();
    initCamera();
    loadModel();
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              result,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 30,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          body: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 100,
                child: Container(
                  height: MediaQuery.of(context).size.height - 100,
                  child: (!cameraController!.value.isInitialized)
                      ? Container()
                      : AspectRatio(
                          aspectRatio: cameraController!.value.aspectRatio,
                          child: CameraPreview(cameraController!),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
