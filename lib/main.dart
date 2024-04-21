import 'package:color_detector/Pages/green.dart';
import 'package:color_detector/Pages/greenHome.dart';
import 'package:color_detector/Pages/home.dart';
import 'package:color_detector/Pages/red.dart';
import 'package:color_detector/Pages/redHome.dart';
import 'package:color_detector/Pages/settings.dart';
import 'package:color_detector/Theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(camera: firstCamera),
    ),
  );
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp({Key? key, required this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Color Detector',
      theme: Provider.of<ThemeProvider>(context).themeData,
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomePage(),
        '/greenhome': (context) => GreenHome(),
        '/redhome': (context) => RedHome(),
        '/settings': (context) => SettingsPage(),
        '/green': (context) => Green(
              camera: camera,
            ),
        '/red': (context) => Red(
              camera: camera,
            ),
      },
    );
  }
}
