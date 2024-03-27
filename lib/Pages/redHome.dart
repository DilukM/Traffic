import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:color_detector/Pages/BottomNav.dart';
import 'package:color_detector/Pages/home.dart';
import 'package:color_detector/Pages/red.dart';
import 'package:color_detector/Pages/settings.dart';

class RedHome extends StatefulWidget {
  final CameraDescription camera;
  const RedHome({super.key, required this.camera});

  @override
  State<RedHome> createState() => _RedHomeState();
}

class _RedHomeState extends State<RedHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 85, bottom: 20),
            child: Text(
              "You choose alarm for red light",
              style: TextStyle(
                  fontSize: 23, color: Color.fromARGB(255, 85, 84, 84)),
            ),
          ),
          Image.asset("assets/red.png"),
          const SizedBox(
            height: 12,
          ),
          SizedBox(
            height: 50,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 3, // Remove elevation
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                        color: Color.fromARGB(221, 45, 45, 45),
                        width: 2), // Border color and width
                    borderRadius: BorderRadius.circular(50), // Border radius
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(
                                camera: widget.camera,
                              )));
                },
                child: const Text("Cancel")),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 50,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 3, // Remove elevation
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                        color: Color.fromARGB(221, 45, 45, 45),
                        width: 2), // Border color and width
                    borderRadius: BorderRadius.circular(50), // Border radius
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Red(
                                camera: widget.camera,
                              )));
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text("Set Camera"),
                )),
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 0, // Set current index according to the selected page
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(
                          camera: widget.camera,
                        )));
          } else if (index == 1) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => SettingsPage(camera: widget.camera)));
          }
        },
      ),
    );
  }
}
