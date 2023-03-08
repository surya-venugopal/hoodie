import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hoodie/Models/skin_model.dart';
import 'package:hoodie/app_utils.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

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
                              if (HasBought.yes == hasBought
                                  // && currentSkin != skin.id
                                  ) {
                                await FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(AppUtils.uid)
                                    .update({"currentSkin": skin.id});

                                // sample data

                                // await FirebaseFirestore.instance
                                //     .collection("skins")
                                //     .add({
                                //   "color": 0,
                                //   "imageUrl":
                                //       "https://firebasestorage.googleapis.com/v0/b/hoodie-bc4c2.appspot.com/o/Screenshot%202023-02-15%20150925.png?alt=media&token=e1d72238-7068-4168-a435-fa795fcaa0c3",
                                //   "modelUrl":
                                //       "https://modelviewer.dev/shared-assets/models/Astronaut.glb",
                                //   "name": "1",
                                //   "price": 23,
                                // }).then((doc) {
                                //   FirebaseFirestore.instance
                                //       .collection("skins")
                                //       .doc(doc.id)
                                //       .update({"id": doc.id});
                                // });
                              } else {
                                // Navigator.of(context).pushNamed();
                                await FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(AppUtils.uid)
                                    .collection("skins")
                                    .doc(skin.id)
                                    .set({
                                  "id": skin.id,
                                  "color": skin.color,
                                  "imageUrl": skin.imageUrl,
                                  "modelUrl": skin.modelUrl,
                                  "name": skin.name,
                                  "price": skin.price,
                                });
                              }
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
