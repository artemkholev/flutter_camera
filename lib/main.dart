import 'dart:html' as html;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Камера',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const CameraScreen(),
    );
  }
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  String? _imagePath;

  Future<void> _takePhoto() async {
    final videoElement = html.VideoElement();
    final mediaStream = await html.window.navigator.mediaDevices?.getUserMedia({'video': true});

    if (mediaStream != null) {
      videoElement.srcObject = mediaStream;
      videoElement.play();

      final canvas = html.CanvasElement(width: 640, height: 480);
      final context = canvas.context2D;

      videoElement.onCanPlay.listen((event) {
        context.drawImage(videoElement, 0, 0);
        _imagePath = canvas.toDataUrl();
        setState(() {});
        mediaStream.getTracks().forEach((track) => track.stop());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Камера'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_imagePath != null)
              Image.network(
                _imagePath!,
                width: 1000,
                height: 1000,
                fit: BoxFit.cover,
              )
            else
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _takePhoto,
              child: const Text('Сделать фото'),
            ),
          ],
        ),
      ),
    );
  }
}