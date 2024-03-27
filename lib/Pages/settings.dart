import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:color_detector/Pages/BottomNav.dart';
import 'package:color_detector/Pages/home.dart';
import 'package:color_detector/Pages/signin_screen.dart';

class SettingsPage extends StatefulWidget {
  final CameraDescription camera;
  const SettingsPage({super.key, required this.camera});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            signOut();
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    if (await GoogleSignIn().isSignedIn()) {
      await GoogleSignIn().signOut();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => SignInScreen(
                    camera: widget.camera,
                  )));
    }
  }
}
