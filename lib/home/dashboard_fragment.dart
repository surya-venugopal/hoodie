import 'package:flutter/material.dart';

import '../widgets/product_view.dart';

class DashboardFragment extends StatelessWidget {
  const DashboardFragment({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 50),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Hoodie",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.camera_alt,
                    ),
                    color: Colors.black,
                    iconSize: 24,
                    splashRadius: 20,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            "Featured",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 350,
            width: size.width,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
              ),
              scrollDirection: Axis.horizontal,
              controller: ScrollController(),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      onTap: () {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            "assets/test.png",
                            fit: BoxFit.cover,
                            height: 100,
                            width: double.infinity,
                          ),
                          Text(
                            "wing $index",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            color: Colors.purple,
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: const Text(
                              "400 \$",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            "Recents",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...[1, 2, 3, 4, 5].map((element) {
            return Column(
              children: [
                productView(
                    size: Size(size.width * 2 / 3, size.width),
                    img: "assets/test.png",
                    name: "wing $element",
                    price: 40,
                    color: Colors.green),
                const SizedBox(height: 10),
              ],
            );
          }),
        ],
      ),
    );
  }
}
