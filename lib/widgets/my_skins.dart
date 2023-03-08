import 'package:flutter/material.dart';
import 'package:hoodie/Models/skin_model.dart';

import '../app_utils.dart';
import 'skin_view.dart';

class MySkins extends StatelessWidget {
  final List<SkinModel> skins;
  final String currentSkin;

  const MySkins({super.key, required this.skins, required this.currentSkin});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: skins.length,
      itemBuilder: (BuildContext context, int index) {
        var skin = skins[index];

        return SkinView(
          skin: skin,
          hasBought: HasBought.yes,
          currentSkin: currentSkin,
        );
      },
    );
  }
}
