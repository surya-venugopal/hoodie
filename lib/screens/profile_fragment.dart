import 'package:flutter/material.dart';
import 'package:hoodie/widgets/my_skins.dart';
import 'package:provider/provider.dart';

import '../Models/skin_management.dart';
import '../Models/user_management.dart';
import 'connect_hoodie_screen.dart';

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

  late SkinsProvider skinProvider;

  bool _isInit = true;
  @override
  Widget build(BuildContext context) {
    super.build(context);

    skinProvider = Provider.of<SkinsProvider>(context, listen: true);
    if (_isInit) {
      _isInit = false;
      tabController = TabController(length: 2, vsync: this);
    }

    return ListView(
      shrinkWrap: true,
      children: [
        Container(
          height: 40,
          width: double.infinity,
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(ConnectHoodieScreen.route);
            },
            child: const Text("Connect your Hoodie"),
          ),
        ),
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
                  Text(
                    UserProvider.name,
                    style: const TextStyle(color: Colors.white),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text(
                  "Points",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  skinProvider.points.toString(),
                  style: const TextStyle(
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
                skinProvider.mySkins.isEmpty
                    ? const Center(
                        child: Text("No skins found"),
                      )
                    : MySkins(
                        mySkins: skinProvider.mySkins,
                        currentSkin: skinProvider.currentSkin),
                const Text("sadsda"),
              ],
            )),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
