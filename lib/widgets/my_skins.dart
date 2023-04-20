import 'package:flutter/material.dart';
import 'package:hoodie/Models/skin_management.dart';

import '../app_utils.dart';
import 'skin_view.dart';

class MySkins extends StatelessWidget {
  final List<SkinModel> mySkins;
  final String currentSkin;

  const MySkins({super.key, required this.mySkins, required this.currentSkin});

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
      itemCount: mySkins.length,
      itemBuilder: (BuildContext context, int index) {
        var skin = mySkins.elementAt(index);

        if (currentSkin == skin.id) {
          skin.description = "Equipped";
        } else {
          skin.description = "${skin.price} \$";
        }

        return SkinView(
          height: 200,
          skin: skin,
          hasBought: HasBought.yes,
        );
      },
    );
  }
}
