import 'package:flutter/cupertino.dart';
import 'package:users_app/models/address.dart';

class AppInfo extends ChangeNotifier {
  Address? userPickupAddress;
  Address? userDropOffAddress;

  void updateUserPickupAddress(Address thisuserPickupAddress) {
    print("Updated user pickup address");
    userPickupAddress = thisuserPickupAddress;
    notifyListeners();
  }

  void updateDropOffAddress(Address thisuserDropOffAddress) {
    print("Updated user pickup address");
    userDropOffAddress = thisuserDropOffAddress;
    notifyListeners();
  }
}
