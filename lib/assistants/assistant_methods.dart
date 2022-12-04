import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:users_app/app_info/app_info.dart';
import 'package:users_app/assistants/request_assistant.dart';
import 'package:users_app/global/api_key.dart';
import 'package:users_app/global/globals.dart';
import 'package:users_app/models/address.dart';
import '../models/user_model.dart';

class AssistantMethods {
  static Future<String> searchAddressForGeographicCoordinates(
      Position position, BuildContext context) async {
    String apiUrl =
        "https://us1.locationiq.com/v1/reverse?key=$mapRequestKey&lat=${position.latitude.toString()}&lon=${position.longitude.toString()}&format=json";
    String humanReadableAddress;
    var requestResponse = await RequestAssistant.recieveRequest(apiUrl);
    if (requestResponse != "Failed") {
      humanReadableAddress = requestResponse['display_name'];
      Address userPickupAddress = Address(
        humanReadableAddress: humanReadableAddress,
        locationLatitude: position.latitude.toString(),
        locationLongitude: position.longitude.toString(),
        locationName: humanReadableAddress,
      );
      Provider.of<AppInfo>(context, listen: false)
          .updateUserPickupAddress(userPickupAddress);
      return humanReadableAddress;
    } else {
      return "Failed";
    }
  }

  static void readCurrentOnlineUserInfo() async {
    currentFirebaseUser = fauth.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(currentFirebaseUser!.uid);

    userRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
        print(userModelCurrentInfo!.name);
      } else {}
    });
  }
}
