import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';

import 'user_management.dart';

class SpotModel {
  final double latitude;
  final double longitude;
  final String videoUrl;
  final DateTime time;

  SpotModel(
      {required this.time,
      required this.latitude,
      required this.longitude,
      required this.videoUrl});
}

class SpotProvider with ChangeNotifier {
  List<SpotModel> spots = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Map params = {};
  Future<void> getAllSpots(double width) async {
    spots = [];
    QuerySnapshot querySnapshot = await firestore
        .collection("spotted")
        .where("uid", isEqualTo: UserProvider.uid)
        // .orderBy('time')
        .get();
    var sumLa = 0.0;
    var sumLo = 0.0;
    var minmax = [
      double.infinity,
      double.infinity,
      double.negativeInfinity,
      double.negativeInfinity
    ];

    for (var doc in querySnapshot.docs) {
      var loc = (doc["location"] as GeoPoint);
      minmax = [
        min(minmax[0], loc.latitude),
        min(minmax[1], loc.longitude),
        max(minmax[2], loc.latitude),
        max(minmax[3], loc.longitude)
      ];
      sumLa += loc.latitude;
      sumLo += loc.longitude;
      spots.add(
        SpotModel(
            latitude: loc.latitude,
            longitude: loc.longitude,
            videoUrl: doc["videoUrl"],
            time: (doc["time"] as Timestamp).toDate()),
      );
    }

    var horizontalDistance = (minmax[3] - minmax[1]).abs();
    var verticalDistance = (minmax[2] - minmax[0]).abs();

    var zoomHorizontal = log(360 * width / 256 / horizontalDistance);
    var zoomVertical = log(180 * width / 256 / verticalDistance);
    var zoom = min(zoomHorizontal, zoomVertical);

    params = {
      "center": LatLng(sumLa / spots.length, sumLo / spots.length),
      "zoom": zoom
    };

    notifyListeners();
  }
}
