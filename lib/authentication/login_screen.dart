import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../global/globals.dart';
import '../splash_screen/splash_screen.dart';
import '../widgets/progress_dialog.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  Widget textField(
    String inputfield,
    TextEditingController fieldEditingController,
    TextInputType inputType,
  ) {
    return TextField(
      controller: fieldEditingController,
      keyboardType: inputType,
      style: const TextStyle(color: Colors.grey),
      obscureText: inputfield == "Password" ? true : false,
      decoration: InputDecoration(
        hintText: inputfield,
        labelText: inputfield,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 10),
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 20),
      ),
    );
  }

  validateForm() {
    // add validations
    submitLogin();
  }

  submitLogin() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProgressDialog(message: "Loading.."),
    );
    final User firebaseUser = (await fauth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text.trim(),
                password: passwordTextEditingController.text.trim())
            .catchError(
      (errorMsg) {
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "Something went wrong: ${errorMsg.toString()} ");
        debugPrint(errorMsg.toString());
      },
    ))
        .user!;

    if (firebaseUser != null) {
      DatabaseReference driverRef =
          FirebaseDatabase.instance.ref().child('users');
      driverRef.child(firebaseUser.uid).once().then((driver) {
        final snap = driver.snapshot;
        if (snap.value != null) {
          currentFirebaseUser = firebaseUser;
          Fluttertoast.showToast(msg: "Login Successful!");
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => MySplashScreen()));
        } else {
          fauth.signOut();
          Fluttertoast.showToast(msg: "User Not found in database");
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => MySplashScreen()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset('assets/images/logo.png'),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Login",
              style: TextStyle(
                  fontSize: 26,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            ),
            textField("Email", emailTextEditingController,
                TextInputType.emailAddress),
            textField("Password", passwordTextEditingController,
                TextInputType.visiblePassword),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                validateForm();
              },
              style: ElevatedButton.styleFrom(primary: Colors.lightGreenAccent),
              child: const Text(
                "Login",
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: ((context) => const SignupScreen())),
              ),
              child: const Text("Signup Insted"),
            ),
          ],
        ),
      )),
    );
  }
}
