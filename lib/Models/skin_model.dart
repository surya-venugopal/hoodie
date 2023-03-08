import 'package:flutter/material.dart';

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
