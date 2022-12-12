import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:users_app/app_info/app_info.dart';
import 'package:users_app/assistants/assistant_methods.dart';
import 'package:users_app/global/globals.dart';
import 'package:users_app/mainscreens/search_places_screen.dart';
import 'package:users_app/widgets/my_drawer.dart';

import '../models/address.dart';

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

  var result;

  List<LatLng> pLineCoordinateList = [];
  Set<Polyline> polylineSet = {};

  LocationPermission? _locationPermission;

  bool showNavigationDrawer = true;

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
    print("this is your address$humanReadableAddress");
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
            polylines: polylineSet,
            onMapCreated: (controller) {
              _controller.complete(controller);
              newGooglemapController = controller;
            },
          ),
          Positioned(
            top: 80,
            left: 20,
            child: showNavigationDrawer
                ? CircleAvatar(
                    child: IconButton(
                      icon: const Icon(
                        Icons.menu,
                      ),
                      onPressed: () {
                        skey.currentState!.openDrawer();
                      },
                    ),
                  )
                : IconButton(
                    onPressed: () => SystemNavigator.pop(),
                    icon: Icon(Icons.close)),
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
                            const Text("Not getting address"),
                          if (Provider.of<AppInfo>(context, listen: false)
                                  .userPickupAddress !=
                              null)
                            Text(
                              // TO DO

                              "${(Provider.of<AppInfo>(context, listen: false).userPickupAddress!.locationName.toString()).substring(0, 50)}...",
                              style: const TextStyle(color: Colors.grey),
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
                    onTap: () async {
                      result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SearchPagesScreen();
                          },
                        ),
                      );
                      if (result == "locationSelected") {
                        print(result);
                        setState(() {
                          showNavigationDrawer = false;
                        });
                      }
                      await drawPolylineFromSourceToDestination();
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.place,
                          color: Colors.grey,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "To",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                            if (Provider.of<AppInfo>(context, listen: false)
                                    .userDropOffAddress ==
                                null)
                              const Text(
                                "Dropoff location",
                                style: TextStyle(color: Colors.grey),
                              ),
                            if (Provider.of<AppInfo>(context, listen: false)
                                    .userDropOffAddress !=
                                null)
                              Text(
                                "${Provider.of<AppInfo>(context, listen: false).userDropOffAddress!.locationName.toString().substring(0, 50)}...",
                                style: const TextStyle(color: Colors.grey),
                              ),
                          ],
                        ),
                      ],
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
                    child: const Text(
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

  Future<void> drawPolylineFromSourceToDestination() async {
    var sourcePosition =
        Provider.of<AppInfo>(context, listen: false).userPickupAddress;
    var destinationPosition =
        Provider.of<AppInfo>(context, listen: false).userDropOffAddress;
    var sourceLatLng = LatLng(double.parse(sourcePosition!.locationLatitude!),
        double.parse(sourcePosition.locationLongitude!));
    var destinationLatLng = LatLng(
        double.parse(destinationPosition!.locationLatitude!),
        double.parse(destinationPosition.locationLongitude!));

    var directionDetailsInfo =
        await AssistantMethods.obtainOriginToDestinationDirectionDetails(
            sourceLatLng, destinationLatLng);

    // print(directionDetailsInfo?.e_points);
    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPointsResult = pPoints.decodePolyline(
        '''knjmEnjunUbKCfEA?_@]@kMBeE@qIIoF@wH@eFFk@WOUI_@?u@j@k@`@EXLTZHh@Y`AgApAaCrCUd@cDpDuAtAoApA{YlZiBdBaIhGkFrDeCtBuFxFmIdJmOjPaChDeBlDiAdD}ApGcDxU}@hEmAxD}[tt@yNb\\yBdEqFnJqB~DeFxMgK~VsMr[uKzVoCxEsEtG}BzCkHhKWh@]t@{AxEcClLkCjLi@`CwBfHaEzJuBdEyEhIaBnCiF|K_Oz\\
                {MdZwAbDaKbUiB|CgCnDkDbEiE|FqBlDsLdXqQra@kX|m@aF|KcHtLm@pAaE~JcTxh@w\\`v@gQv`@}F`MqK`PeGzIyGfJiG~GeLhLgIpIcE~FsDrHcFfLqDzH{CxEwAbBgC|B}F|DiQzKsbBdeA{k@~\\oc@bWoKjGaEzCoEzEwDxFsUh^wJfOySx[uBnCgCbCoFlDmDvAiCr@eRzDuNxC_EvAiFpCaC|AqGpEwHzFoQnQoTrTqBlCyDnGmCfEmDpDyGzGsIzHuZzYwBpBsC`CqBlAsBbAqCxAoBrAqDdDcNfMgHbHiPtReBtCkD|GqAhBwBzBsG~FoAhAaCbDeBvD_BlEyM``@uBvKiA~DmAlCkA|B}@lBcChHoJnXcB`GoAnIS~CIjFDd]A|QMlD{@jH[vAk@`CoGxRgPzf@aBbHoB~HeMx^eDtJ}BnG{DhJU`@mBzCoCjDaAx@mAnAgCnBmAp@uAj@{Cr@wBPkB@kBSsEW{GV}BEeCWyAWwHs@qH?
                cIHkDXuDn@mCt@mE`BsH|CyAp@}AdAaAtAy@lBg@pCa@jE]fEcBhRq@pJKlCk@hLFrB@lD_@xCeA`DoBxDaHvM_FzImDzFeCpDeC|CkExDiJrHcBtAkDpDwObVuCpFeCdHoIl\\uBjIuClJsEvMyDbMqAhEoDlJ{C|J}FlZuBfLyDlXwB~QkArG_AnDiAxC{G|OgEdLaE`LkBbEwG~KgHnLoEjGgDxCaC`BuJdFkFtCgCnBuClD_HdMqEzHcBpB_C|BuEzCmPlIuE|B_EtDeBhCgAdCw@rCi@|DSfECrCAdCS~Di@jDYhA_AlC{AxCcL`U{GvM_DjFkBzBsB`BqDhBaEfAsTvEmEr@iCr@qDrAiFnCcEzCaE~D_@JmFdGQDwBvCeErEoD|BcFjC}DbEuD~D`@Zr@h@?d@Wr@}@vAgCbEaHfMqA`Cy@dAg@bAO`@gCi@w@W''');
    pLineCoordinateList.clear();
    if (decodedPointsResult.isNotEmpty) {
      decodedPointsResult.forEach((element) {
        pLineCoordinateList.add(LatLng(element.latitude, element.longitude));
      });
    }
    polylineSet.clear();
    setState(() {
      Polyline polyline = Polyline(
        color: Colors.blue,
        points: pLineCoordinateList,
        polylineId: const PolylineId("PolylineId"),
        jointType: JointType.round,
        geodesic: true,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      );
      polylineSet.add(polyline);
      print(polylineSet);
    });
  }
}
