import 'dart:async';

import 'package:flutter/material.dart';
import 'package:users_app/mainscreens/search_places_screen.dart';

import '../assistants/assistant_methods.dart';
import '../authentication/login_screen.dart';
import '../global/globals.dart';
import '../mainscreens/main_screen.dart';

class MySplashScreen extends StatefulWidget {
  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() {
    AssistantMethods.readCurrentOnlineUserInfo();

    Timer(
      const Duration(seconds: 3),
      () async {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (c) => const MainScreen()));
        if (fauth.currentUser != null) {
          Navigator.push(context,
              MaterialPageRoute(builder: (c) => const SearchPagesScreen()));
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const LoginScreen()));
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/logo.png'),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Uber",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
