import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hoodie/widgets/my_skins.dart';

import '../Models/skin_model.dart';
import '../app_utils.dart';

class ProfileFragment extends StatefulWidget {
  const ProfileFragment({super.key});

  @override
  State<ProfileFragment> createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<ProfileFragment> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<SkinModel> skins = [];
  bool _loading = true;
  late TabController tabController;
  late String currentSkin;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 10)).then((value) async {
      QuerySnapshot querySnapshot = await firestore
          .collection("users")
          .doc(AppUtils.uid)
          .collection("skins")
          // .orderBy('date')
          .get();

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(AppUtils.uid)
          .get();

      currentSkin = doc["currentSkin"];

      for (var skin in querySnapshot.docs) {
        skins.add(SkinModel(
            id: skin["id"],
            price: skin["price"],
            color: skin["color"],
            name: skin["name"],
            description:
                currentSkin == skin.id ? "Equipped" : "${skin["price"]}  \$",
            imageUrl: skin["imageUrl"],
            modelUrl: skin["modelUrl"]));
      }

      setState(() {
        _loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!_loading) {
      tabController = TabController(length: 2, vsync: this);
    }
    return _loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView(
            shrinkWrap: true,
            children: [
              Container(
                color: Theme.of(context).primaryColor,
                height: 200,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(75),
                          child: Image.network(
                            "https://firebasestorage.googleapis.com/v0/b/hoodie-bc4c2.appspot.com/o/Screenshot%202023-02-15%20150925.png?alt=media&token=e1d72238-7068-4168-a435-fa795fcaa0c3",
                            height: 150,
                          ),
                        ),
                        const Text(
                          "Surya",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Points",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            "2450",
                            style: TextStyle(
                              color: Colors.yellowAccent,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                  ],
                ),
              ),
              TabBar(
                controller: tabController,
                tabs: const [
                  Tab(
                    child: Text(
                      "Skins",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Spotted",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      MySkins(skins: skins, currentSkin: currentSkin),
                      const Text("sadsda"),
                    ],
                  )),
            ],
          );
  }

  @override
  bool get wantKeepAlive => true;
}
