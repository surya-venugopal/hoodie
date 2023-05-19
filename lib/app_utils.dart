import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppUtils {
  static Color secondaryColor = const Color(0xff8A8BB3);
  static dump() async {
    await FirebaseFirestore.instance.collection("skins").add({
      "color": 2,
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/hoodie-bc4c2.appspot.com/o/skin.png?alt=media&token=0ad3e4b0-f5f8-4b9f-a452-f58ac00e4e91",
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

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: const Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
