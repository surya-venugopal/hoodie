import 'package:flutter/material.dart';
import 'package:hoodie/Models/product_model.dart';

import '../widgets/product_view.dart';

class DashboardFragment extends StatelessWidget {
  DashboardFragment({super.key});

  List<ProductModel> products = [
    ProductModel(
        color: Colors.red,
        id: "id",
        name: "sura",
        description: "30 \$",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/hoodie-bc4c2.appspot.com/o/Screenshot%202023-02-15%20150925.png?alt=media&token=e1d72238-7068-4168-a435-fa795fcaa0c3"),
    ProductModel(
        color: Colors.red,
        id: "id",
        name: "sura",
        description: "30 \$",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/hoodie-bc4c2.appspot.com/o/Screenshot%202023-02-15%20150925.png?alt=media&token=e1d72238-7068-4168-a435-fa795fcaa0c3"),
    ProductModel(
        color: Colors.red,
        id: "id",
        name: "sura",
        description: "30 \$",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/hoodie-bc4c2.appspot.com/o/Screenshot%202023-02-15%20150925.png?alt=media&token=e1d72238-7068-4168-a435-fa795fcaa0c3"),
    ProductModel(
        color: Colors.red,
        id: "id",
        name: "sura",
        description: "30 \$",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/hoodie-bc4c2.appspot.com/o/Screenshot%202023-02-15%20150925.png?alt=media&token=e1d72238-7068-4168-a435-fa795fcaa0c3"),
    ProductModel(
        color: Colors.red,
        id: "id",
        name: "sura",
        description: "30 \$",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/hoodie-bc4c2.appspot.com/o/Screenshot%202023-02-15%20150925.png?alt=media&token=e1d72238-7068-4168-a435-fa795fcaa0c3"),
    ProductModel(
        color: Colors.red,
        id: "id",
        name: "sura",
        description: "30 \$",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/hoodie-bc4c2.appspot.com/o/Screenshot%202023-02-15%20150925.png?alt=media&token=e1d72238-7068-4168-a435-fa795fcaa0c3"),
    ProductModel(
        color: Colors.red,
        id: "id",
        name: "sura",
        description: "30 \$",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/hoodie-bc4c2.appspot.com/o/Screenshot%202023-02-15%20150925.png?alt=media&token=e1d72238-7068-4168-a435-fa795fcaa0c3"),
    ProductModel(
        color: Colors.red,
        id: "id",
        name: "sura",
        description: "30 \$",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/hoodie-bc4c2.appspot.com/o/Screenshot%202023-02-15%20150925.png?alt=media&token=e1d72238-7068-4168-a435-fa795fcaa0c3"),
    ProductModel(
        color: Colors.red,
        id: "id",
        name: "sura",
        description: "30 \$",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/hoodie-bc4c2.appspot.com/o/Screenshot%202023-02-15%20150925.png?alt=media&token=e1d72238-7068-4168-a435-fa795fcaa0c3"),
    ProductModel(
        color: Colors.red,
        id: "id",
        name: "sura",
        description: "30 \$",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/hoodie-bc4c2.appspot.com/o/Screenshot%202023-02-15%20150925.png?alt=media&token=e1d72238-7068-4168-a435-fa795fcaa0c3"),
    ProductModel(
        color: Colors.red,
        id: "id",
        name: "sura",
        description: "30 \$",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/hoodie-bc4c2.appspot.com/o/Screenshot%202023-02-15%20150925.png?alt=media&token=e1d72238-7068-4168-a435-fa795fcaa0c3"),
    ProductModel(
        color: Colors.red,
        id: "id",
        name: "sura",
        description: "30 \$",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/hoodie-bc4c2.appspot.com/o/Screenshot%202023-02-15%20150925.png?alt=media&token=e1d72238-7068-4168-a435-fa795fcaa0c3"),
    ProductModel(
        color: Colors.red,
        id: "id",
        name: "sura",
        description: "30 \$",
        imageUrl:
            "https://firebasestorage.googleapis.com/v0/b/hoodie-bc4c2.appspot.com/o/Screenshot%202023-02-15%20150925.png?alt=media&token=e1d72238-7068-4168-a435-fa795fcaa0c3"),
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          ProductModel product = products[index];
          return ProductView(product: product);
        },
      ),
    );
  }
}
