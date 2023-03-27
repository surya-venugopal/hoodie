import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hoodie/Models/user_management.dart';

class SkinModel {
  final String id;
  final String name;
  final double price;
  String description;
  final String imageUrl;
  final String modelUrl;
  final int color;

  SkinModel(
      {required this.id,
      required this.price,
      required this.color,
      required this.name,
      required this.description,
      required this.imageUrl,
      required this.modelUrl});
}

class SkinsProvider with ChangeNotifier {
  List<SkinModel> skins = [];
  List<SkinModel> mySkins = [];

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isLoading = false;
  bool hasMore = true;
  final int _documentLimit = 10;
  DocumentSnapshot? lastDocument;

  late String currentSkin;
  late int points;

  getUser() {
    currentSkin = UserProvider.currentSkin;
    points = UserProvider.points;
    notifyListeners();
  }

  Future<void> getMySkins() async {
    QuerySnapshot querySnapshot = await firestore
        .collection("users")
        .doc(UserProvider.uid)
        .collection("skins")
        // .orderBy('date')
        .get();

    for (var skin in querySnapshot.docs) {
      mySkins.add(
        SkinModel(
            id: skin["id"],
            price: skin["price"],
            color: skin["color"],
            name: skin["name"],
            description: "${skin["price"]}  \$",
            imageUrl: skin["imageUrl"],
            modelUrl: skin["modelUrl"]),
      );
    }
    notifyListeners();
  }

  Future<void> getSkins() async {
    if (!hasMore) {
      log('No More Products');
      return;
    }
    if (isLoading) {
      return;
    }
    isLoading = true;
    notifyListeners();

    QuerySnapshot querySnapshot;
    if (lastDocument == null) {
      querySnapshot = await firestore
          .collection('skins')
          .orderBy('id')
          .where("id",
              whereNotIn: mySkins.isEmpty
                  ? [" "]
                  : mySkins.map((element) => element.id).toList())
          .limit(_documentLimit)
          .get();
    } else {
      querySnapshot = await firestore
          .collection('skins')
          .orderBy('id')
          .where("id",
              whereNotIn: mySkins.isEmpty
                  ? [" "]
                  : mySkins.map((element) => element.id).toList())
          .startAfterDocument(lastDocument!)
          .limit(_documentLimit)
          .get();
    }
    if (querySnapshot.docs.length < _documentLimit) {
      hasMore = false;
    }
    if (querySnapshot.docs.isNotEmpty) {
      lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    }

    skins.addAll(
      querySnapshot.docs.map(
        (skin) => SkinModel(
            id: skin["id"],
            price: skin["price"],
            color: skin["color"],
            name: skin["name"],
            description: "${skin["price"]}  \$",
            imageUrl: skin["imageUrl"],
            modelUrl: skin["modelUrl"]),
      ),
    );

    isLoading = false;
    notifyListeners();
  }

  changeSkin(
    BuildContext context, {
    required SkinModel skin,
  }) async {
    if (UserProvider.currentSkin != skin.id) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(UserProvider.uid)
          .update({"currentSkin": skin.id});

      UserProvider.currentSkin = skin.id;
      currentSkin = UserProvider.currentSkin;
      notifyListeners();
    }
    Navigator.of(context).pop();
  }

  buySkin(
    BuildContext context, {
    required SkinModel skin,
  }) async {
    // Navigator.of(context).pushNamed();

    var db = FirebaseFirestore.instance;

    db.runTransaction((transaction) async {
      transaction.set(
          db
              .collection("users")
              .doc(UserProvider.uid)
              .collection("skins")
              .doc(skin.id),
          {
            "id": skin.id,
            "color": skin.color,
            "imageUrl": skin.imageUrl,
            "modelUrl": skin.modelUrl,
            "name": skin.name,
            "price": skin.price,
          });

      transaction.update(db.collection("users").doc(UserProvider.uid), {
        "points": UserProvider.points + skin.price * (skin.color + 1),
        "currentSkin": skin.id,
      });
    }).then((value) {
      UserProvider.points =
          (UserProvider.points + skin.price * (skin.color + 1)).toInt();

      UserProvider.currentSkin = skin.id;

      points = UserProvider.points;
      currentSkin = UserProvider.currentSkin;

      skins.removeWhere((product) => product.id == skin.id);
      mySkins.add(skin);
      notifyListeners();
      Navigator.of(context).pop();
    });
  }
}
