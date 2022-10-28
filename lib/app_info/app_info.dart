import 'package:flutter/cupertino.dart';
import 'package:users_app/models/address.dart';

class AppInfo extends ChangeNotifier {
  Address? userPickupAddress;

  void updateUserPickupAddress(Address thisuserPickupAddress) {
    print("Updated user pickup address");
    userPickupAddress = thisuserPickupAddress;
    notifyListeners();
  }
}
