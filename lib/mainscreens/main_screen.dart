import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:users_app/app_info/app_info.dart';
import 'package:users_app/assistants/assistant_methods.dart';
import 'package:users_app/global/globals.dart';
import 'package:users_app/mainscreens/search_places_screen.dart';
import 'package:users_app/widgets/my_drawer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? newGooglemapController;
  static final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    checkIfPermissionAllowed();
  }

  GlobalKey<ScaffoldState> skey = GlobalKey<ScaffoldState>();

  Position? userCurrentPosition;
  var geolocator = Geolocator();

  LocationPermission? _locationPermission;

  checkIfPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    } else {
      locateUserPosition();
    }
  }

  locateUserPosition() async {
    userCurrentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng latLngPosition =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);
    newGooglemapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    print("locate user position");
    String humanReadableAddress =
        await AssistantMethods.searchAddressForGeographicCoordinates(
            userCurrentPosition!, context);
    print("this is your address" + humanReadableAddress);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Scaffold(
      key: skey,
      drawer: MyDrawer(
        email: userModelCurrentInfo!.email,
        name: userModelCurrentInfo!.name,
      ),
      body: Stack(
        children: [
          GoogleMap(
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (controller) {
              _controller.complete(controller);
              newGooglemapController = controller;
              // locateUserPosition();
            },
          ),
          Positioned(
            top: 80,
            left: 20,
            child: CircleAvatar(
              child: IconButton(
                icon: const Icon(
                  Icons.menu,
                ),
                onPressed: () {
                  skey.currentState!.openDrawer();
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16),
                  topLeft: Radius.circular(16),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.place,
                        color: Colors.grey,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "From",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                          if (Provider.of<AppInfo>(context, listen: false)
                                  .userPickupAddress ==
                              null)
                            Text("Not getting address"),
                          if (Provider.of<AppInfo>(context, listen: false)
                                  .userPickupAddress !=
                              null)
                            Text(
                              // TO DO

                              (Provider.of<AppInfo>(context, listen: false)
                                          .userPickupAddress!
                                          .locationName
                                          .toString())
                                      .substring(0, 50) +
                                  "...",
                              style: TextStyle(color: Colors.grey),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchPagesScreen(),
                        ),
                      );
                    },
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => SearchPagesScreen())),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.place,
                            color: Colors.grey,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "To",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                              if (Provider.of<AppInfo>(context, listen: false)
                                      .userDropOffAddress ==
                                  null)
                                Text(
                                  "Dropoff location",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              if (Provider.of<AppInfo>(context, listen: false)
                                      .userDropOffAddress !=
                                  null)
                                Text(
                                  Provider.of<AppInfo>(context, listen: false)
                                      .userDropOffAddress!
                                      .locationName
                                      .toString(),
                                  style: TextStyle(color: Colors.grey),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "Request ride",
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
