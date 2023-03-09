import 'package:cloud_firestore/cloud_firestore.dart';

class AppUtils {
  static String uid = "5vZq8dI6RKVfDC9BNk6Ma6JCyFH3";

  static dump() async {
    for (int i = 0; i < 20; i++) {
      await FirebaseFirestore.instance.collection("skins").add({
        "color": i % 3,
        "imageUrl":
            "https://firebasestorage.googleapis.com/v0/b/hoodie-bc4c2.appspot.com/o/Screenshot%202023-02-15%20150925.png?alt=media&token=e1d72238-7068-4168-a435-fa795fcaa0c3",
        "modelUrl":
            "https://modelviewer.dev/shared-assets/models/Astronaut.glb",
        "name": "$i",
        "price": i,
      }).then((doc) {
        FirebaseFirestore.instance
            .collection("skins")
            .doc(doc.id)
            .update({"id": doc.id});
      });
    }
  }
}

enum HasBought { no, yes }
