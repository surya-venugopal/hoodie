import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../Models/skin_management.dart';
import '../Models/user_management.dart';
import '../widgets/my_skins.dart';

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

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200.0,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: Theme.of(context).primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(75),
                        child: SvgPicture.asset(
                          "assets/avatars/avatar${UserProvider.avatar}.svg",
                          height: 130,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        UserProvider.name,
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Skin Score",
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
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Reward Points",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "50",
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
          ),
        ),
        SliverFixedExtentList(
          itemExtent: MediaQuery.of(context).size.height - 50,
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return skinProvider.mySkins.isEmpty
                  ? const Center(
                      child: Text("No skins found"),
                    )
                  : MySkins(
                      mySkins: skinProvider.mySkins,
                      currentSkin: skinProvider.currentSkin);
            },
            childCount: 1,
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
