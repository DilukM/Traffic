import 'package:flutter/material.dart';
import 'package:color_detector/Pages/BottomNav.dart';
import 'package:gradient_slide_to_act/gradient_slide_to_act.dart';

class RedHome extends StatefulWidget {
  const RedHome({
    super.key,
  });

  @override
  State<RedHome> createState() => _RedHomeState();
}

class _RedHomeState extends State<RedHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              "You choose alarm for red light",
              style: TextStyle(
                fontSize: 23,
              ),
            ),
          ),
          Image.asset("assets/red1.png"),
          const SizedBox(
            height: 70,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GradientSlideToAct(
                onSubmit: () {
                  Navigator.pushReplacementNamed(context, '/red');
                },
                width: MediaQuery.of(context).size.width,
                height: 60,
                text: "Slide to set camera",
                textStyle:
                    TextStyle(color: Theme.of(context).colorScheme.tertiary),
                submittedIcon: Icons.camera_alt_outlined,
                backgroundColor: Theme.of(context).colorScheme.primary,
                gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 255, 165, 165),
                  Color.fromARGB(255, 201, 115, 115),
                ]),
                dragableIconBackgroundColor:
                    Color.fromARGB(255, 201, 115, 115)),
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 0, // Set current index according to the selected page
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/settings');
          }
        },
      ),
    );
  }
}
