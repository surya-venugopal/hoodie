import 'package:flutter/material.dart';
import 'package:hoodie/Models/skin_management.dart';
import 'package:hoodie/app_utils.dart';
import 'package:provider/provider.dart';

import '../Models/user_management.dart';
import '../screens/skin_info_screen.dart';

class SkinView extends StatefulWidget {
  final SkinModel skin;
  final HasBought hasBought;
  final double height;

  const SkinView({
    super.key,
    required this.height,
    required this.skin,
    required this.hasBought,
  });

  @override
  State<SkinView> createState() => _SkinViewState();
}

class _SkinViewState extends State<SkinView> {
  @override
  Widget build(BuildContext context) {
    SkinsProvider skinProvider = Provider.of<SkinsProvider>(context);

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(SkinInfoScreen.route, arguments: {
          "skin": widget.skin,
          "hasBought": widget.hasBought,
          "equipped": (widget.skin.id == UserProvider.currentSkin),
        });
      },
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  widget.skin.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: widget.height,
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: widget.hasBought == HasBought.yes
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.black38),
                        child: const Text(
                          "Owned",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Poppins",
                            fontSize: 14,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      )
                    : Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(30)),
                        child: IconButton(
                          color:
                              widget.skin.favorite ? Colors.pink : Colors.white,
                          onPressed: () {
                            skinProvider.toggleFavorite(widget.skin.id);
                          },
                          icon: Icon(
                            widget.skin.favorite
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
            widget.skin.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "\$ ${widget.skin.price}",
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
