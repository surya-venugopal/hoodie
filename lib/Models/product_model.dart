import 'package:flutter/material.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String modelUrl;
  final Color color;

  ProductModel(
      {required this.id,
      required this.color,
      required this.name,
      required this.description,
      required this.imageUrl,
      required this.modelUrl});
}
