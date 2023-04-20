import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider {
  static String uid = "3NB8veB9qSPyvc1dguhEJBVn8S93";

  static String name = "";
  static String avatar = "";
  static String currentSkin = "";
  static int points = 0;

  static Future<void> getUser() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(UserProvider.uid)
        .get();
    name = doc["name"];
    points = (doc["points"] as double).toInt();
    currentSkin = doc["currentSkin"];
    avatar = doc["avatar"];
  }
}
