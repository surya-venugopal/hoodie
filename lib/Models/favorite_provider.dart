import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteProvider with ChangeNotifier {
  late SharedPreferences prefs;
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  List<String> skinIds = [];

  Future<void> toggleFavorite(String skinId) async {
    if (skinIds.contains(skinId)) {
      skinIds.remove(skinId);
    } else {
      skinIds.add(skinId);
    }
    await prefs.setStringList('items', skinIds);
    log(skinIds.toString());
    notifyListeners();
  }

  Future<void> fetchData() async {
    skinIds = [];
    try {
      skinIds = prefs.getStringList('items')!.toList();
    } catch (_) {}
    log(skinIds.toString());

    notifyListeners();
  }
}
