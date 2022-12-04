import 'package:firebase_auth/firebase_auth.dart';
import 'package:users_app/models/user_model.dart';

final FirebaseAuth fauth = FirebaseAuth.instance;
User? currentFirebaseUser = fauth.currentUser;
UserModel? userModelCurrentInfo = UserModel(
  email: currentFirebaseUser!.email,
  id: currentFirebaseUser!.uid,
  name: currentFirebaseUser!.displayName,
  phone: currentFirebaseUser!.phoneNumber,
);
