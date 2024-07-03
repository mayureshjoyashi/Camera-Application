import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'dart:io'; // For File operations

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller;
  List<CameraDescription>? cameras;
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      controller = CameraController(cameras![0], ResolutionPreset.high);
      await controller?.initialize();
      setState(() {
        isCameraInitialized = true;
      });
    }
  }

  Future<String> getGalleryPath() async {
    Directory? directory;
    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/DCIM/Camera');
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    }
    return directory?.path ?? '';
  }

  Future<void> captureImage() async {
    if (!controller!.value.isInitialized) {
      return;
    }
    try {
      // Capture the picture and get the file
      final XFile picture = await controller!.takePicture();
      // Get the gallery path
      final String galleryPath = await getGalleryPath();
      // Generate a unique file name based on the current date and time
      final String fileName = '${DateTime.now()}.png';
      // Combine the gallery path and file name to get the full path
      final String fullPath = join(galleryPath, fileName);
      // Save the picture to the gallery path
      await picture.saveTo(fullPath);
      print('Picture saved to $fullPath');
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isCameraInitialized) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Camera Application'),
      ),
      body: Stack(

        children: [
          CameraPreview(controller!),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                onPressed: captureImage,
                child: Icon(Icons.camera),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
