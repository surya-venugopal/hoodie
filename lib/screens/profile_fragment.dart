import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hoodie/widgets/my_skins.dart';
import 'package:provider/provider.dart';

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
  late TabController tabController;

  late SkinsProvider provider;

  bool _isInit = true;
  @override
  Widget build(BuildContext context) {
    super.build(context);

    provider = Provider.of<SkinsProvider>(context, listen: true);
    if (_isInit) {
    
      _isInit = false;
      tabController = TabController(length: 2, vsync: this);
    }

    return ListView(
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
                MySkins(skins: provider.mySkins, currentSkin: provider.currentSkin),
                const Text("sadsda"),
              ],
            )),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
