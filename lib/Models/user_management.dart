import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider {
  static String uid = "3NB8veB9qSPyvc1dguhEJBVn8S93";

  static String name = "";
  static String userId = "";
  static String avatar = "";
  static String currentSkin = "";
  static num points = 0;

  static Future<void> getUser() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(UserProvider.uid)
        .get();
    name = doc["name"];
    userId = doc["userId"];
    points = doc["points"];
    currentSkin = doc["currentSkin"];
    avatar = doc["avatar"];
  }

  static Future<void> setuser({
    required String avatar,
    required String name,
    required String userId,
    required String referrel,
  }) async {
    UserProvider.name = name;
    UserProvider.userId = userId;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(UserProvider.uid)
        .set({
      "name": name,
      "userId": userId,
      "referrel": referrel,
      "points": 0.0,
      "avatar": avatar,
      "currentSkin": "",
    });
  }
}
