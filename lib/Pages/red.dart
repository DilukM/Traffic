import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:color_detector/Pages/BottomNav.dart';
import 'package:color_detector/Pages/home.dart';
import 'package:color_detector/Pages/settings.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class Red extends StatefulWidget {
  final CameraDescription camera;
  const Red({Key? key, required this.camera}) : super(key: key);

  @override
  State<Red> createState() => _RedState();
}

class _RedState extends State<Red> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  Color detectedColor = Colors.transparent;
  String label = '';
  double confidence = 0.0;
  final player = AudioPlayer();
  bool _isAlarmPlaying = false;
  bool _isProcessingPaused = false;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize().then((_) async {
      await _tfLiteInit();
      if (!_isProcessingPaused) {
        await _startStreaming();
      }
    });
  }

  Future<void> _tfLiteInit() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );
  }

  Future<void> _startStreaming() async {
    await _controller.startImageStream((CameraImage image) {
      _processImage(image);
    });
  }

  Future<void> _processImage(CameraImage image) async {
    if (mounted && !_isProcessingPaused) {
      var recognitions = await Tflite.runModelOnFrame(
        bytesList: image.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: image.height,
        imageWidth: image.width,
        imageMean: 0.0,
        imageStd: 255.0,
        numResults: 2,
        threshold: 0.2,
        rotation: -90,
      );

      if (recognitions == null || recognitions.isEmpty) {
        setState(() {
          label = '';
          confidence = 0.0;
          detectedColor =
              Colors.transparent; // No color detected, set as transparent
          if (_isAlarmPlaying) {
            player.pause(); // Pause the alarm sound
            _isAlarmPlaying = false;
          }
        });
      } else {
        Color detectedColor =
            _getColorFromLabel(recognitions[0]['label'].toString());

        //Logic to check detected color and confidence level
        if (detectedColor == Colors.red && recognitions[0]['confidence'] == 1) {
          setState(() {
            confidence = recognitions[0]['confidence'] * 100;
            label = recognitions[0]['label'].toString();
            this.detectedColor = detectedColor; // Set detected color
          });

          // Play alarm sound when red color is detected
          if (!_isAlarmPlaying) {
            player.play(AssetSource('alarm.mp3'));
            player.onPlayerComplete.listen((event) {
              player.play(
                AssetSource('alarm.mp3'),
              );
            });
            _isAlarmPlaying = true;
          }
        } else {
          setState(() {
            label = '';
            confidence = 0.0;
            this.detectedColor =
                Colors.transparent; // Set as transparent for other colors
            if (_isAlarmPlaying) {
              player.pause(); // Pause the alarm sound
              _isAlarmPlaying = false;
            }
          });
        }
      }
    }
  }

  Color _getColorFromLabel(String label) {
    switch (label) {
      case 'red':
        return Colors.red;
      default:
        return Colors.transparent;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    Tflite.close();
    player.dispose();
    super.dispose();
    WakelockPlus.disable();
  }

  void _toggleProcessingAndNavigate(int index) {
    setState(() {
      _isProcessingPaused = true; // Pause processing

      // Stop image stream
      _controller.stopImageStream();

      // Pause the alarm sound if playing
      if (_isAlarmPlaying) {
        player.pause();
        _isAlarmPlaying = false;
      }

      // Set detected color to transparent
      detectedColor = Colors.transparent;
    });

    // Navigate after processing has been paused
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(camera: widget.camera),
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SettingsPage(camera: widget.camera),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    WakelockPlus.enable();
    return Scaffold(
      bottomNavigationBar: BottomNav(
        currentIndex: 0, // Set current index according to the selected page
        onTap: _toggleProcessingAndNavigate,
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                ),
                CameraPreview(_controller),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      label == "red"
                          ? "Red color detected"
                          : "Color not detected",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: detectedColor,
                      shape: BoxShape.rectangle,
                      border: Border.all(color: Colors.grey, width: 2),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
