import 'dart:developer';

import 'package:flutter/material.dart';

class productView extends StatelessWidget {
  const productView({
    Key? key,
    required this.img,
    required this.name,
    required this.price,
    required this.color,
    required this.size,
  }) : super(key: key);

  final String img;
  final String name;
  final int price;
  final Color color;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            onTap: () {
              log("sa");
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  img,
                  fit: BoxFit.cover,
                  height: size.height * 2 / 3,
                  width: double.infinity,
                ),
                Text(
                  name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(
                  color: color,
                  width: double.infinity,
                  alignment: Alignment.center,
                  height: size.height / 10,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "$price \$",
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
