import 'package:firebase_database/firebase_database.dart';

class UserModel {
  String? name;
  String? id;
  String? email;
  String? phone;

  UserModel({this.email, this.id, this.name, this.phone});

  UserModel.fromSnapshot(DataSnapshot snap) {
    phone = (snap.value as dynamic)['phone'];
    id = snap.key;
    name = (snap.value as dynamic)['name'];
    email = (snap.value as dynamic)['email'];
  }
}
