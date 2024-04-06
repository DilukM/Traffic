import 'package:color_detector/Pages/signin_screen.dart';
import 'package:color_detector/Theme/theme_provider.dart';
import 'package:color_detector/util/settingsButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:color_detector/Pages/BottomNav.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNav(
        currentIndex: 1, // Set current index according to the selected page
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
            return null;
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
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                signOut();
              },
              child: SettingsButton(Title: "Signout"),
            ),
            // ElevatedButton(
            //   style: ButtonStyle(
            //       backgroundColor: WidgetStatePropertyAll(
            //     Theme.of(context).colorScheme.tertiary,
            //   )),
            //   onPressed: () {
            //     Provider.of<ThemeProvider>(context, listen: false)
            //         .toggleTheme();
            //   },
            //   child: const Text('Change Theme'),
            // ),
          ],
        ),
      ),
    );
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    if (await GoogleSignIn().isSignedIn()) {
      await GoogleSignIn().signOut();
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) =>
              SignInScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero)
                  .animate(animation),
              child: child,
            );
          },
        ),
      );
    }
  }
}
