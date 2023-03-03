import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hoodie/Models/product_model.dart';

import '../widgets/product_view.dart';

class DashboardFragment extends StatefulWidget {
  @override
  State<DashboardFragment> createState() => _DashboardFragmentState();
}

class _DashboardFragmentState extends State<DashboardFragment> {
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
          .collection('products')
          .orderBy('date')
          .limit(documentLimit)
          .get();
    } else {
      querySnapshot = await firestore
          .collection('products')
          .orderBy('date')
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        getProducts();
      }
    });

    return Container(
      height: size.height,
      padding: const EdgeInsets.all(10),
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: skins.length,
        itemBuilder: (BuildContext context, int index) {
          var skin = skins[index];
          ProductModel product = ProductModel(
              id: skin["id"],
              color: skin["color"] == 0
                  ? Colors.green
                  : skin["color"] == 1
                      ? Colors.purple
                      : Colors.red,
              name: skin["name"],
              description: "${skin["price"]}  \$",
              imageUrl: skin["imageUrl"],
              modelUrl: skin["modelUrl"]);
          return ProductView(product: product);
        },
      ),
    );
  }
}
