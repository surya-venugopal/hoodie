import 'package:flutter/material.dart';

import '../Models/product_model.dart';
import '../widgets/product_view.dart';

class ProfileFragment extends StatefulWidget {
  const ProfileFragment({super.key});

  @override
  State<ProfileFragment> createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  final ScrollController _parentScrollController = ScrollController();
  final ScrollController _childScrollController = ScrollController();

  List<ProductModel> products = [];
  @override
  void initState() {
    _parentScrollController.addListener(() {
      if (_parentScrollController.offset ==
              _parentScrollController.position.maxScrollExtent &&
          _childScrollController.position.maxScrollExtent != 0) {
        setState(() {
          _scroll = true;
        });
      }
    });

    _childScrollController.addListener(() {
      if (_childScrollController.offset == 0) {
        setState(() {
          _scroll = false;
        });
      }
    });
    super.initState();
  }

  bool _scroll = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return ListView(
      shrinkWrap: true,
      controller: _parentScrollController,
      children: [
        Container(
          color: Theme.of(context).primaryColor,
          height: 260,
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(75),
                child: Image.network(
                  "https://firebasestorage.googleapis.com/v0/b/hoodie-bc4c2.appspot.com/o/Screenshot%202023-02-15%20150925.png?alt=media&token=e1d72238-7068-4168-a435-fa795fcaa0c3",
                  height: 150,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Points",
                style: TextStyle(color: Colors.white),
              ),
              const Text(
                "2450",
                style: TextStyle(
                  color: Colors.yellowAccent,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "My skins",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: products.length < 3 ? 300 : size.height,
          child: GridView.builder(
            controller: _childScrollController,
            physics: _scroll
                ? const AlwaysScrollableScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              ProductModel product = products[index];
              return ProductView(product: product);
            },
          ),
        ),
      ],
    );
  }
}
