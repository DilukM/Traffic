import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:color_detector/Pages/BottomNav.dart';
import 'package:color_detector/Pages/green.dart';
import 'package:color_detector/Pages/home.dart';
import 'package:color_detector/Pages/settings.dart';

class GreenHome extends StatefulWidget {
  final CameraDescription camera;
  const GreenHome({super.key, required this.camera});

  @override
  State<GreenHome> createState() => _GreenHomeState();
}

class _GreenHomeState extends State<GreenHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 85, bottom: 20),
            child: Text(
              "You choose alarm for green light",
              style: TextStyle(
                  fontSize: 23, color: Color.fromARGB(255, 85, 84, 84)),
            ),
          ),
          Image.asset("assets/green.png"),
          SizedBox(
            height: 12,
          ),
          SizedBox(
            height: 45,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 3, // Remove elevation
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: const Color.fromARGB(221, 45, 45, 45),
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
                child: Text(
                  "Cancel",
                  style:
                      TextStyle(color: const Color.fromARGB(221, 45, 45, 45)),
                )),
          ),
          SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 45,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 3, // Remove elevation
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: const Color.fromARGB(221, 45, 45, 45),
                        width: 2), // Border color and width
                    borderRadius: BorderRadius.circular(50), // Border radius
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Green(
                                camera: widget.camera,
                              )));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Set Camera",
                    style:
                        TextStyle(color: const Color.fromARGB(221, 45, 45, 45)),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
