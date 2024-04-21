import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:color_detector/util/shape.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:color_detector/Pages/BottomNav.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class Red extends StatefulWidget {
  final CameraDescription camera;
  const Red({Key? key, required this.camera}) : super(key: key);

  @override
  State<Red> createState() => _RedState();
}

class _RedState extends State<Red> {
  late CameraController _controller;
  Future<void>? _initializeControllerFuture;
  double _zoomLevel = 1.0;
  double _maxZoomLevel = 5.0;

  String label = '';
  double confidence = 0.0;
  final player = AudioPlayer();
  bool _isAlarmPlaying = false;
  bool _isProcessingPaused = false;
  late SharedPreferences _prefs;
  late String _customAlarmPath;
  late String selectedOption;

  @override
  void initState() {
    super.initState();

    // Initialize SharedPreferences
    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
      // Retrieve custom alarm path from SharedPreferences
      _customAlarmPath = _prefs.getString('customAlarmPath') ?? '';
      selectedOption = _prefs.getString('selectedOption') ?? '';
      // Initialize camera controller
      _controller = CameraController(widget.camera, ResolutionPreset.high);
      _initializeControllerFuture = _controller.initialize().then((_) async {
        await _tfLiteInit();
        if (!_isProcessingPaused) {
          await _startStreaming();
        }
      });
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
        imageHeight: MediaQuery.of(context).size.height.toInt(),
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

          if (_isAlarmPlaying) {
            player.pause(); // Pause the alarm sound
            _isAlarmPlaying = false;
          }
        });
      } else {
        setState(() {
          confidence = recognitions[0]['confidence'] * 100;
          label = recognitions[0]['label'].toString();
          // Set detected color
        });
        //Logic to check detected color and confidence level
        if (recognitions[0]['label'].toString() == 'red' &&
            recognitions[0]['confidence'] == 1) {
          // Play alarm sound when red color is detected
          if (!_isAlarmPlaying) {
            if (_customAlarmPath.isEmpty) {
              player.play(AssetSource(selectedOption));
              player.onPlayerComplete.listen((event) {
                player.play(
                  AssetSource(selectedOption),
                );
              });
            } else {
              player.play(DeviceFileSource(_customAlarmPath));
              player.onPlayerComplete.listen((event) {
                player.play(
                  DeviceFileSource(_customAlarmPath),
                );
              });
            }
            _isAlarmPlaying = true;
          }
        } else {
          setState(() {
            confidence = recognitions[0]['confidence'] * 100;
            label = recognitions[0]['label'].toString();
          });
        }
      }
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

      // Pause the alarm sound
      player.pause();
      _isAlarmPlaying = false;
    });

    // Navigate after processing has been paused
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/settings');
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
                Expanded(
                  child: Stack(
                    children: [
                      CameraPreview(_controller),
                      ClipPath(
                        clipper: RectangularHoleClipper(
                            holeWidth: MediaQuery.of(context).size.width * 0.65,
                            holeHeight:
                                MediaQuery.of(context).size.width * 0.85,
                            borderRadius: 25), // Adjust hole size as needed
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width * 1.77,
                          color: Colors.black45,
                        ),
                      ),
                      // Positioned(
                      //   bottom: 150,
                      //   left: 150,
                      //   child: Text(
                      //     label + ' ' + confidence.toString(),
                      //     style: TextStyle(fontSize: 16, color: Colors.white),
                      //   ),
                      // ),
                      Positioned(
                        bottom: 120,
                        left: 16,
                        right: 16,
                        child: Slider(
                          inactiveColor: Colors.white30,
                          activeColor: Colors.white,
                          value: _zoomLevel,
                          min: 1.0,
                          max: _maxZoomLevel,
                          onChanged: (value) {
                            _setZoom(value);
                          },
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 100,
                            color: Colors.white,
                          )),
                      Positioned(
                        bottom: 16,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: GestureDetector(
                            onTap: () {
                              if (_isAlarmPlaying) {
                                player.pause(); // Pause the alarm sound
                                _isAlarmPlaying = false;
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment(0.8, 1),
                                  colors: <Color>[
                                    Color(0xff52b5b5),
                                    Color(0xff20dcdc),
                                    Color(0xff52b5b5),
                                  ], // Gradient from https://learnui.design/tools/gradient-generator.html
                                  tileMode: TileMode.mirror,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Stop Alarm",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
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
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
