import 'package:flutter/material.dart';
import 'package:hoodie/Models/skin_model.dart';
import 'package:hoodie/app_utils.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';

class SkinView extends StatelessWidget {
  final SkinModel skin;
  final HasBought hasBought;
  final String currentSkin;

  const SkinView(
      {super.key,
      required this.skin,
      required this.hasBought,
      this.currentSkin = ""});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (c1) {
                  return ListView(children: [
                    SizedBox(
                      height: 250,
                      width: double.infinity,
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
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            skin.name,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await Provider.of<SkinsProvider>(context,
                                      listen: false)
                                  .buySkin(
                                skin: skin,
                                hasBought: hasBought,
                                currentSkin: currentSkin,
                              );
                            },
                            child: Text(skin.description),
                          ),
                        ],
                      ),
                    )
                  ]);
                });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.network(
                skin.imageUrl,
                fit: BoxFit.fitWidth,
                width: double.infinity,
              ),
              Text(
                skin.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Container(
                color: skin.color == 0
                    ? Colors.green
                    : skin.color == 1
                        ? Colors.purple
                        : Colors.red,
                width: double.infinity,
                height: 40,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  skin.description,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
