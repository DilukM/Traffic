import 'package:color_detector/Pages/home.dart';
import 'package:color_detector/Pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:color_detector/Pages/BottomNav.dart';

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
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 300),
                pageBuilder: (context, animation, secondaryAnimation) =>
                    HomePage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position:
                        Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero)
                            .animate(animation),
                    child: child,
                  );
                },
              ),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 300),
                pageBuilder: (context, animation, secondaryAnimation) =>
                    SettingsPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position:
                        Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero)
                            .animate(animation),
                    child: child,
                  );
                },
              ),
            );
          }
        },
      ),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
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
          Image.asset("assets/green2.png"),
          SizedBox(
            height: 70,
          ),
          SizedBox(
            height: 60,
            width: MediaQuery.of(context).size.width / 1.5,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/green');
              },
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment(0.8, 1),
                      colors: <Color>[
                        Color(0xff52b5b5),
                        Color(0xff20dcdc),
                        Color(0xff52b5b5),
                      ],
                      tileMode: TileMode.mirror,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Click to set camera",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
