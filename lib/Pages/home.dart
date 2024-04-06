import 'package:color_detector/Pages/BottomNav.dart';
import 'package:color_detector/Pages/redHome.dart';
import 'package:color_detector/Pages/settings.dart';
import 'package:color_detector/Pages/subscribe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:color_detector/util/listTile.dart';

import 'greenHome.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        bottomNavigationBar: BottomNav(
          currentIndex: 0, // Set current index according to the selected page
          onTap: (index) {
            if (index == 0) {
              return null;
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
                      position: Tween<Offset>(
                              begin: Offset(1.0, 0.0), end: Offset.zero)
                          .animate(animation),
                      child: child,
                    );
                  },
                ),
              );
            }
          },
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 85, bottom: 20),
              child: Text(
                "Choose your alarm",
                style: TextStyle(
                    fontSize: 25,
                    color: Theme.of(context).colorScheme.tertiary),
              ),
            ),
            SizedBox(height: 330, child: Image.asset("assets/browncolors.png")),
            const SizedBox(
              height: 40,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.shadow,
                        offset: Offset(0, -5),
                        blurRadius: 10,
                        spreadRadius: 0,
                      )
                    ],
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20, right: 12, left: 12, bottom: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Choose your alarm",
                                style: TextStyle(
                                    fontSize: 20,
                                    color:
                                        Theme.of(context).colorScheme.tertiary),
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
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: Duration(milliseconds: 300),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        RedHome(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return SlideTransition(
                                    position: Tween<Offset>(
                                            begin: Offset(1.0, 0.0),
                                            end: Offset.zero)
                                        .animate(animation),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: const listTile(
                            Imgpath: 'assets/red_dot.png',
                            Title: 'Red light alarm',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: Duration(milliseconds: 300),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        Subscribe(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return SlideTransition(
                                    position: Tween<Offset>(
                                            begin: Offset(1.0, 0.0),
                                            end: Offset.zero)
                                        .animate(animation),
                                    child: child,
                                  );
                                },
                              ),
                            );
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
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    // Show confirmation dialog
    final shouldExit = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Don't exit
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Exit
            child: Text(
              'Exit',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
    return shouldExit ?? false; // Return true to allow exit, false to cancel
  }
}
