import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hoodie/Models/user_management.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SkinModel {
  final String id;
  final String name;
  final double price;
  String description;
  final String imageUrl;
  final String modelUrl;
  final int color;
  bool favorite = false;
  SkinModel(
      {this.favorite = false,
      required this.id,
      required this.price,
      required this.color,
      required this.name,
      required this.description,
      required this.imageUrl,
      required this.modelUrl});
}

class SkinsProvider with ChangeNotifier {
  List<SkinModel> skins = [];
  List<SkinModel> favoriteSkins = [];
  List<SkinModel> mySkins = [];

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isLoading = false;
  bool hasMore = true;
  final int _documentLimit = 10;
  DocumentSnapshot? lastDocument;

  late String currentSkin;
  late num points;

  List<String> favSkinsLocal = [];

  late SharedPreferences prefs;
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    favSkinsLocal = [];
    try {
      favSkinsLocal = prefs.getStringList('items')!.toList();
    } catch (_) {}
    notifyListeners();
  }

  Future<void> toggleFavorite(String skinId) async {
    if (favSkinsLocal.contains(skinId)) {
      favSkinsLocal.remove(skinId);
      skins[skins.indexWhere((skin) => skin.id == skinId)].favorite = false;
      favoriteSkins.removeWhere((skin) => skin.id == skinId);
    } else {
      favSkinsLocal.add(skinId);
      skins[skins.indexWhere((skin) => skin.id == skinId)].favorite = true;
      favoriteSkins.add(skins.firstWhere((skin) => skin.id == skinId));
    }
    await prefs.setStringList('items', favSkinsLocal);
    notifyListeners();
  }

  Future<void> getFavSkins() async {
    favoriteSkins = [];
    QuerySnapshot querySnapshot = await firestore
        .collection('skins')
        // .where("name", isEqualTo: "jacket")
        .where("id", whereIn: favSkinsLocal.isEmpty ? [" "] : favSkinsLocal)
        .get();

    favoriteSkins.addAll(
      querySnapshot.docs.map(
        (skin) => SkinModel(
          id: skin.id,
          price: skin["price"].toDouble(),
          color: skin["color"],
          name: skin["name"],
          description: "${skin["price"]}  \$",
          imageUrl: skin["imageUrl"],
          modelUrl: skin["modelUrl"],
          favorite: true,
        ),
      ),
    );
  }

  void getUser() {
    currentSkin = UserProvider.currentSkin;
    points = UserProvider.points;
    notifyListeners();
  }

  Future<void> getMySkins() async {
    QuerySnapshot querySnapshot = await firestore
        .collection("user_skins")
        .where("uid", isEqualTo: UserProvider.uid)
        .get();
    // var skin =
    //     querySnapshot.docs.firstWhere((skin) => currentSkin != skin["id"]);
    // mySkins.add(
    //   SkinModel(
    //       id: skin["id"],
    //       price: skin["price"]
    //       color: skin["color"],
    //       name: skin["name"],
    //       description: "${skin["price"]}  \$",
    //       imageUrl: skin["imageUrl"],
    //       modelUrl: skin["modelUrl"]),
    // );

    for (var skin in querySnapshot.docs) {
      mySkins.add(
        SkinModel(
          id: skin.id,
          price: skin["price"],
          color: skin["color"],
          name: skin["name"],
          description: "${skin["price"]}  \$",
          imageUrl: skin["imageUrl"],
          modelUrl: skin["modelUrl"],
          favorite: favSkinsLocal.contains(skin.id),
        ),
      );
    }
    notifyListeners();
  }

  Future<void> getSkins({
    String search = "",
  }) async {
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
      if (search.isEmpty) {
        querySnapshot = await firestore
            .collection('skins')
            // .where("name", isEqualTo: "jacket")
            // .where("id",
            //     whereNotIn: mySkins.isEmpty
            //         ? [" "]
            //         : mySkins.map((element) => element.id).toList())
            .limit(_documentLimit)
            .get();
      } else {
        querySnapshot = await firestore
            .collection('skins')
            // .where("id",
            //     whereNotIn: mySkins.isEmpty
            //         ? [" "]
            //         : mySkins.map((element) => element.id).toList())
            .where("name", isGreaterThanOrEqualTo: search)
            .limit(_documentLimit)
            .get();
      }
    } else {
      if (search.isEmpty) {
        querySnapshot = await firestore
            .collection('skins')
            // .where("id",
            //     whereNotIn: mySkins.isEmpty
            //         ? [" "]
            //         : mySkins.map((element) => element.id).toList())
            .startAfterDocument(lastDocument!)
            .limit(_documentLimit)
            .get();
      } else {
        querySnapshot = await firestore
            .collection('skins')
            // .where("id",
            //     whereNotIn: mySkins.isEmpty
            //         ? [" "]
            //         : mySkins.map((element) => element.id).toList())
            .where("name", isGreaterThanOrEqualTo: search)
            .startAfterDocument(lastDocument!)
            .limit(_documentLimit)
            .get();
      }
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
          id: skin.id,
          price: skin["price"].toDouble(),
          color: skin["color"],
          name: skin["name"],
          description: "${skin["price"]}  \$",
          imageUrl: skin["imageUrl"],
          modelUrl: skin["modelUrl"],
          favorite: favSkinsLocal.contains(skin.id),
        ),
      ),
    );
    isLoading = false;
    notifyListeners();
  }

  Future<void> equipSkin({
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
  }

  Future<void> buySkin({
    required SkinModel skin,
  }) async {
    var db = FirebaseFirestore.instance;
    await db.runTransaction((transaction) async {
      transaction.set(db.collection("user_skins").doc(skin.id), {
        "id": skin.id,
        "color": skin.color,
        "imageUrl": skin.imageUrl,
        "modelUrl": skin.modelUrl,
        "name": skin.name,
        "price": skin.price,
        "uid": UserProvider.uid,
      });

      transaction.update(db.collection("users").doc(UserProvider.uid), {
        "points": UserProvider.points + skin.price * (skin.color + 1),
        "currentSkin": skin.id,
      });
    });
    UserProvider.points =
        (UserProvider.points + skin.price * (skin.color + 1)).toInt();

    UserProvider.currentSkin = skin.id;

    points = UserProvider.points;
    currentSkin = UserProvider.currentSkin;

    // skins.removeWhere((product) => product.id == skin.id);
    mySkins.add(skin);
    favSkinsLocal.remove(skin.id);
    skins[skins.indexWhere((skin1) => skin1.id == skin.id)].favorite = false;
    favoriteSkins.removeWhere((skin1) => skin1.id == skin.id);
    await prefs.setStringList('items', favSkinsLocal);

    notifyListeners();
    // var razor = RazorpayHelper(context);
    // razor.openCheckout(
    //     name: "surya",
    //     amount: 100,
    //     description: "test1",
    //     contact: "7010450504");
  }

  void rhandlePaymentSuccess(Map<dynamic, dynamic> response) {
    log('Success Response: $response');
  }

  void rhandlePaymentError(Map<dynamic, dynamic> response) {
    log('Error Response: $response');
  }
}
