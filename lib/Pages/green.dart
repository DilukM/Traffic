import 'package:flutter/cupertino.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'dart:async';

import 'package:color_detector/Pages/BottomNav.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class Green extends StatefulWidget {
  final CameraDescription camera;
  const Green({Key? key, required this.camera}) : super(key: key);

  @override
  State<Green> createState() => _GreenState();
}

class _GreenState extends State<Green> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  Color detectedColor = Colors.transparent;
  double _zoomLevel = 1.0;
  double _maxZoomLevel = 5.0;

  String label = '';
  double confidence = 0.0;
  final player = AudioPlayer();
  bool _isAlarmPlaying = false;
  bool _isProcessingPaused = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize().then((_) async {
      await _tfLiteInit();
      if (!_isProcessingPaused) {
        await _startStreaming();
      }
    });
  }

  Future<void> _setZoom(double zoom) async {
    if (zoom >= 1.0 && zoom <= _maxZoomLevel) {
      await _controller.setZoomLevel(zoom);
      setState(() {
        _zoomLevel = zoom;
      });
    }
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
        // Convert recognized label to color
        Color detectedColor =
            _getColorFromLabel(recognitions[0]['label'].toString());

        //Logic to check detected color and confidence level
        if (recognitions[0]['label'].toString() == "green" &&
            recognitions[0]['confidence'] == 1) {
          setState(() {
            confidence = (recognitions[0]['confidence'] * 100);
            label = recognitions[0]['label'].toString();
            this.detectedColor = detectedColor; // Set detected color
          });
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
      case 'green':
        return Colors.green;
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
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    WakelockPlus.enable();
    return Scaffold(
      bottomNavigationBar: BottomNav(
        currentIndex: 0,
        onTap: _toggleProcessingAndNavigate,
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      CameraPreview(_controller),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Slider(
                          inactiveColor:
                              Theme.of(context).colorScheme.secondary,
                          activeColor: Theme.of(context).colorScheme.error,
                          value: _zoomLevel,
                          min: 1.0,
                          max: _maxZoomLevel,
                          onChanged: (value) {
                            _setZoom(value);
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 120,
                        right: 16,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: detectedColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey, width: 2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
