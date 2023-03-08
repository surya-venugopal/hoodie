import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hoodie/Models/skin_model.dart';
import '../app_utils.dart';
import '../widgets/skin_view.dart';

class DashboardFragment extends StatefulWidget {
  @override
  State<DashboardFragment> createState() => _DashboardFragmentState();
}

class _DashboardFragmentState extends State<DashboardFragment>
    with AutomaticKeepAliveClientMixin {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> skins = [];
  bool isLoading = false;
  bool hasMore = true;
  int documentLimit = 10;
  DocumentSnapshot? lastDocument;
  final ScrollController _scrollController = ScrollController();

  getProducts() async {
    if (!hasMore) {
      log('No More Products');
      return;
    }
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot;
    if (lastDocument == null) {
      querySnapshot = await firestore
          .collection('skins')
          .orderBy('id')
          .where("id", whereNotIn: hasBought)
          .limit(documentLimit)
          .get();
    } else {
      querySnapshot = await firestore
          .collection('skins')
          .orderBy('id')
          .where("id", whereNotIn: hasBought)
          .startAfterDocument(lastDocument!)
          .limit(documentLimit)
          .get();
    }
    if (querySnapshot.docs.length < documentLimit) {
      hasMore = false;
    }
    lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    skins.addAll(querySnapshot.docs);
    setState(() {
      isLoading = false;
    });
  }

  var hasBought = [];

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 10)).then((value) async {
      QuerySnapshot querySnapshot = await firestore
          .collection("users")
          .doc(AppUtils.uid)
          .collection("skins")
          // .orderBy('date')
          .get();

      for (var skin in querySnapshot.docs) {
        hasBought.add(skin.id);
      }
      getProducts();
      _scrollController.addListener(() {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.position.pixels;
        double delta = MediaQuery.of(context).size.height * 0.20;
        if (maxScroll - currentScroll <= delta) {
          getProducts();
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
            child: skins.isEmpty && !isLoading
                ? const Center(
                    child: Text('No Data...'),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    controller: _scrollController,
                    itemCount: skins.length,
                    itemBuilder: (BuildContext context, int index) {
                      var skin = skins[index];
                      SkinModel product = SkinModel(
                          id: skin["id"],
                          price: skin["price"],
                          color: skin["color"],
                          name: skin["name"],
                          description: "${skin["price"]}  \$",
                          imageUrl: skin["imageUrl"],
                          modelUrl: skin["modelUrl"]);

                      return SkinView(
                        skin: product,
                        hasBought: HasBought.no,
                      );
                    },
                  ),
          ),
          isLoading
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(5),
                  color: Colors.yellowAccent,
                  child: const Text(
                    'Loading',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
