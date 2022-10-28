import 'package:firebase_auth/firebase_auth.dart';
import 'package:users_app/models/user_model.dart';

final FirebaseAuth fauth = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
