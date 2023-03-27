import 'package:cloud_firestore/cloud_firestore.dart';

class AppUtils {
  static dump() async {
    await FirebaseFirestore.instance.collection("skins").add({
      "color": 2,
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/hoodie-bc4c2.appspot.com/o/Screenshot%202023-02-15%20150925.png?alt=media&token=e1d72238-7068-4168-a435-fa795fcaa0c3",
      "modelUrl":
          "https://firebasestorage.googleapis.com/v0/b/hoodie-bc4c2.appspot.com/o/jacket.glb?alt=media&token=144aa202-97c4-44f6-b04f-d6beaf180bb4",
      "name": "jacket",
      "price": 50,
    }).then((doc) {
      FirebaseFirestore.instance
          .collection("skins")
          .doc(doc.id)
          .update({"id": doc.id});
    });

    await FirebaseFirestore.instance.collection("skins").add({
      "color": 1,
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/hoodie-bc4c2.appspot.com/o/Screenshot%202023-02-15%20150925.png?alt=media&token=e1d72238-7068-4168-a435-fa795fcaa0c3",
      "modelUrl":
          "https://firebasestorage.googleapis.com/v0/b/hoodie-bc4c2.appspot.com/o/onesie.glb?alt=media&token=93f9c366-7107-418f-854f-b9efdd911153",
      "name": "onesie",
      "price": 20,
    }).then((doc) {
      FirebaseFirestore.instance
          .collection("skins")
          .doc(doc.id)
          .update({"id": doc.id});
    });
  }
}

enum HasBought { no, yes }
