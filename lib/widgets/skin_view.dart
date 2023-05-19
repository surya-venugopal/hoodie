import 'package:flutter/material.dart';
import 'package:hoodie/Models/skin_management.dart';
import 'package:hoodie/app_utils.dart';

import '../Models/user_management.dart';
import '../screens/skin_info_screen.dart';
import '../Models/favorite_provider.dart';

class SkinView extends StatelessWidget {
  final SkinModel skin;
  final HasBought hasBought;
  final double height;
  final FavoriteProvider favoriteProvider;

  const SkinView({
    super.key,
    required this.height,
    required this.skin,
    required this.hasBought,
    required this.favoriteProvider,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(SkinInfoScreen.route, arguments: {
          "skin": skin,
          "hasBought": HasBought.no,
          "equipped": (skin.id == UserProvider.currentSkin),
          "favoriteProvider": favoriteProvider,
        });
      },
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  skin.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: height,
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(30)),
                  child: IconButton(
                    color: favoriteProvider.skinIds.contains(skin.id)
                        ? Colors.pink
                        : Colors.white,
                    onPressed: () {
                      favoriteProvider.toggleFavorite(skin.id);
                    },
                    icon: Icon(
                      favoriteProvider.skinIds.contains(skin.id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            skin.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "\$ ${skin.price}",
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
