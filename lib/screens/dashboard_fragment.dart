import 'package:flutter/material.dart';
import 'package:hoodie/Models/skin_management.dart';
import 'package:provider/provider.dart';
import '../app_utils.dart';
import '../Models/user_management.dart';
import '../widgets/skin_view.dart';

class DashboardFragment extends StatefulWidget {
  @override
  State<DashboardFragment> createState() => _DashboardFragmentState();
}

class _DashboardFragmentState extends State<DashboardFragment>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  late List<SkinModel> skins;
  late SkinsProvider provider;

  @override
  void initState() {
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        provider.getSkins();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool _isInit = true;
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<SkinsProvider>(context, listen: true);
    if (_isInit) {
      UserProvider.getUser().then((value) => provider.getUser());
      provider.getMySkins().then((value) => provider.getSkins());
      _isInit = false;
    }

    skins = provider.skins;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
            child: skins.isEmpty && !provider.isLoading
                ? const Center(
                    child: Text('You owned all the skins!'),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    controller: _scrollController,
                    itemCount: skins.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SkinView(
                        skin: skins[index],
                        hasBought: HasBought.no,
                      );
                    },
                  ),
          ),
          provider.isLoading
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(5),
                  color: Colors.yellowAccent,
                  child: const Text(
                    'Loading',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
