import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../app_utils.dart';

class SkinModel {
  final String id;
  final String name;
  final double price;
  final String description;
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

  late String currentSkin;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isLoading = false;
  bool hasMore = true;
  final int _documentLimit = 10;
  DocumentSnapshot? lastDocument;

  Future<void> getCurrentSkin() async {
    DocumentSnapshot user = await FirebaseFirestore.instance
        .collection("users")
        .doc(AppUtils.uid)
        .get();

    currentSkin = user["currentSkin"];
    notifyListeners();
  }

  Future<void> getMySkins() async {
    QuerySnapshot querySnapshot = await firestore
        .collection("users")
        .doc(AppUtils.uid)
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

  buySkin(
      {required SkinModel skin,
      required HasBought hasBought,
      required String currentSkin}) async {
    if (HasBought.yes == hasBought && currentSkin != skin.id) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(AppUtils.uid)
          .update({"currentSkin": skin.id});
    } else {
      // Navigator.of(context).pushNamed();
      await FirebaseFirestore.instance
          .collection("users")
          .doc(AppUtils.uid)
          .collection("skins")
          .doc(skin.id)
          .set({
        "id": skin.id,
        "color": skin.color,
        "imageUrl": skin.imageUrl,
        "modelUrl": skin.modelUrl,
        "name": skin.name,
        "price": skin.price,
      });
      skins.removeWhere((product) => product.id == skin.id);
      mySkins.add(skin);
      notifyListeners();
    }
  }
}
