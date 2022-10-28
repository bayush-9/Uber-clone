import 'package:flutter/material.dart';
import 'package:users_app/global/globals.dart';
import 'package:users_app/splash_screen/splash_screen.dart';

class MyDrawer extends StatefulWidget {
  String? name;
  String? email;

  MyDrawer({this.name, this.email});
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        children: [
          Container(
            color: Colors.black,
            height: 147,
            child: DrawerHeader(
                child: Row(
              children: [
                const Icon(
                  Icons.person,
                  color: Colors.grey,
                  size: 46,
                ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.name!,
                      style: const TextStyle(color: Colors.grey, fontSize: 25),
                    ),
                    Text(widget.email!,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 15)),
                  ],
                ),
              ],
            )),
          ),
          Container(
            color: Colors.grey,
            height: 12,
          ),
          ListTile(
            leading: const Icon(
              Icons.history,
              color: Colors.grey,
            ),
            title: const Text(
              "History",
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => MySplashScreen())));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.person,
              color: Colors.grey,
            ),
            title: const Text(
              "Visit Profile",
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => MySplashScreen())));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.info,
              color: Colors.grey,
            ),
            title: const Text(
              "About",
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => MySplashScreen())));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.grey,
            ),
            title: const Text(
              "Sign out",
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              fauth.signOut();
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => MySplashScreen())));
            },
          )
        ],
      ),
    );
  }
}
