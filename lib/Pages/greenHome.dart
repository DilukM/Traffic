import 'package:flutter/material.dart';
import 'package:color_detector/Pages/BottomNav.dart';
import 'package:gradient_slide_to_act/gradient_slide_to_act.dart';

class GreenHome extends StatefulWidget {
  const GreenHome({
    super.key,
  });

  @override
  State<GreenHome> createState() => _GreenHomeState();
}

class _GreenHomeState extends State<GreenHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
              "You choose alarm for green light",
              style: TextStyle(
                fontSize: 23,
              ),
            ),
          ),
          Image.asset("assets/green1.png"),
          SizedBox(
            height: 70,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GradientSlideToAct(
                onSubmit: () {
                  Navigator.pushReplacementNamed(context, '/green');
                },
                width: MediaQuery.of(context).size.width,
                height: 60,
                text: "Slide to set camera",
                textStyle:
                    TextStyle(color: Theme.of(context).colorScheme.tertiary),
                submittedIcon: Icons.camera_alt_outlined,
                backgroundColor: Colors.grey.withOpacity(0.3),
                gradient: LinearGradient(colors: [
                  const Color.fromARGB(255, 165, 255, 171),
                  Color.fromARGB(255, 115, 201, 119),
                ]),
                dragableIconBackgroundColor:
                    Color.fromARGB(255, 115, 201, 119)),
          ),
        ],
      ),
    );
  }
}
