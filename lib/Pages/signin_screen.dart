import 'dart:async';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:color_detector/Pages/home.dart';
import 'package:color_detector/Pages/signup_screen.dart';
import '../reusable_widgets/reusablewidgets.dart';

class SignInScreen extends StatefulWidget {
  final CameraDescription camera;
  const SignInScreen({Key? key, required this.camera}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
      if (_user != null) {
        // User is already signed in, navigate to home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              camera: widget.camera,
            ),
          ),
        );
      }
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).size.height * 0.2,
              20,
              0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const Text(
                    "Sign in",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Color.fromARGB(255, 67, 67, 67),
                      fontFamily: 'Pacifico',
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Use TextFormField for email with validation
                  TextFormField(
                    controller: _emailTextController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon:
                          Icon(Icons.person_outline, color: Colors.grey),
                      labelStyle: TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 30),
                  // Use TextFormField for password with validation
                  TextFormField(
                    controller: _passwordTextController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outlined, color: Colors.grey),
                      labelStyle: TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                    ),
                    style: const TextStyle(color: Colors.black),
                    obscureText: true,
                    validator: _validatePassword,
                  ),

                  forgetPassword(context),
                  const SizedBox(height: 20),
                  signInSignUpButton(context, true, () {
                    // Validate the form before submitting
                    if (_formKey.currentState?.validate() ?? false) {
                      // Form is valid, proceed with sign-in logic
                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text,
                      )
                          .then((value) async {
                        User? user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          Fluttertoast.showToast(
                            msg: "Signin Successful",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(
                                        camera: widget.camera,
                                      )));
                        }
                      }).onError((error, stackTrace) {
                        print(error);
                        Fluttertoast.showToast(
                          msg: "Failed to signin: $error",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      });
                    }
                  }),
                  Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 50,
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: const Color.fromARGB(255, 185, 185, 185))),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          backgroundColor:
                              const WidgetStatePropertyAll(Colors.white),
                        ),
                        onPressed: () {
                          _handleGoogleSignin();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Sign in with Google",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                                width: 40,
                                child: Image.asset("assets/Google.png")),
                          ],
                        ),
                      )),
                  const Text(
                    "or",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  signUpOption(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Need an account?  ",
            style: TextStyle(color: Colors.blueGrey)),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => SignUpScreen(
                          camera: widget.camera,
                        )));
          },
          child: const Text("Create one",
              style:
                  TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Forgot Password? ",
          style: TextStyle(color: Color.fromARGB(179, 97, 97, 97)),
          textAlign: TextAlign.right,
        ),
        onPressed: () {},
      ),
    );
  }

  void _handleGoogleSignin() async {
    try {
      print("Starting Google sign-in process...");
      // Sign in with Google authentication
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn().signIn();

      if (googleSignInAccount != null) {
        print("Google sign-in successful.");
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final OAuthCredential googleAuthCredential =
            GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(googleAuthCredential);

        // Access the user's information
        final User? user = userCredential.user;
        if (user != null) {
          print("User is signed in: $user");
          // Navigate to the home page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                camera: widget.camera,
              ),
            ),
          );
          Fluttertoast.showToast(
            msg: "Signin Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      }
    } catch (error) {
      print("This is the fuccing error $error");
      Fluttertoast.showToast(
        msg: "Failed to signin: $error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
