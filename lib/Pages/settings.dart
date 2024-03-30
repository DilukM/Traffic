import 'package:color_detector/Theme/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:color_detector/Pages/BottomNav.dart';
import 'package:provider/provider.dart';

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
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/settings');
          }
        },
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.tertiary,
              )),
              onPressed: () {
                signOut();
              },
              child: const Text('Logout'),
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
      Navigator.pushReplacementNamed(context, '/signin');
    }
  }
}
