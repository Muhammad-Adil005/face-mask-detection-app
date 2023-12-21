import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'splash_screen.dart'; // Ensure this is the correct path

late List<CameraDescription>? cameras; // Declare cameras as nullable

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } catch (e) {
    print("Camera initialization error: $e");
  }
  runApp(const FaceMaskDetectionApp());
}

class FaceMaskDetectionApp extends StatelessWidget {
  const FaceMaskDetectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Face Mask Detection App',
      home: SplashScreen(), // Make sure to pass cameras
    );
  }
}
