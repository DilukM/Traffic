import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:color_detector/Pages/greenHome.dart';
import 'package:color_detector/Pages/redHome.dart';
import 'package:color_detector/util/listTile.dart';

class HomePage extends StatefulWidget {
  final CameraDescription camera;

  const HomePage({
    Key? key,
    required this.camera,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 85, bottom: 20),
            child: Text(
              "Choose your alarm",
              style: TextStyle(
                  fontSize: 25, color: Color.fromARGB(255, 85, 84, 84)),
            ),
          ),
          Image.asset("assets/2colors.png"),
          const SizedBox(
            height: 40,
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 189, 189, 189),
                      blurRadius: 20,
                      spreadRadius: 0,
                    )
                  ],
                  color: Color.fromARGB(255, 233, 233, 233),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                          top: 8, right: 12, left: 12, bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Choose your alarm",
                            style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 111, 111, 111)),
                          ),
                          Icon(
                            Icons.more_horiz,
                            color: Color.fromARGB(255, 111, 111, 111),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RedHome(
                                      camera: widget.camera,
                                    )));
                      },
                      child: const listTile(
                        Imgpath: 'assets/red_dot.png',
                        Title: 'Red light alarm',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GreenHome(
                                      camera: widget.camera,
                                    )));
                      },
                      child: const listTile(
                        Imgpath: 'assets/green_dot.png',
                        Title: 'Green light alarm',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
