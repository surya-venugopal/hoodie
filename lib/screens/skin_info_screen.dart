import 'package:flutter/material.dart';
import 'package:hoodie/Models/skin_management.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';

import '../app_utils.dart';
import '../Models/favorite_provider.dart';
import '../widgets/my_widgets.dart';

class SkinInfoScreen extends StatefulWidget {
  static const route = "SkinInfoScreen";
  const SkinInfoScreen({super.key});

  @override
  State<SkinInfoScreen> createState() => _SkinInfoScreenState();
}

class _SkinInfoScreenState extends State<SkinInfoScreen> {
  late FavoriteProvider favoriteProvider;
  bool isInit = true;
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as Map;
    var skin = args["skin"] as SkinModel;
    favoriteProvider = Provider.of<FavoriteProvider>(context, listen: true);
    if (isInit) {
      // favoriteProvider.init().then((value) {
      //   favoriteProvider.fetchData();
      // });
      isInit = false;
    }
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.width,
            backgroundColor: Theme.of(context).canvasColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  color: Color(0xffE2DEFF),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30)),
                ),
                child: ModelViewer(
                  src: skin.modelUrl,
                  // alt: "A 3D model of an astronaut",
                  ar: false,
                  autoRotate: true,
                  autoRotateDelay: 0,
                  rotationPerSecond: "30deg",
                  cameraControls: false,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: 2,
              (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    // width: double.infinity,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          width: 60,
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  skin.name,
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  "\$ ${skin.price}",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                            args["hasBought"] != HasBought.yes
                                ? IconButton(
                                    iconSize: 35,
                                    onPressed: () {
                                      favoriteProvider.toggleFavorite(skin.id);
                                    },
                                    icon: Icon(
                                      favoriteProvider.skinIds.contains(skin.id)
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Colors.red,
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                        const SizedBox(height: 20)
                      ],
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Description",
                        style: TextStyle(
                            fontSize: 22,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w100),
                      ),
                      const Text(
                        "To use this class, make sure you set uses-material-design: true in your project's pubspec.yaml file in the flutter section. This ensures that the Material Icons font is included in your application. This font is used to display the icons. ",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w100,
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (args["hasBought"] != HasBought.yes)
                        MyWidgets.slideButton(() async {
                          await Provider.of<SkinsProvider>(context,
                                  listen: false)
                              .buySkin(
                            skin: skin,
                          );
                        }, "Buy"),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
