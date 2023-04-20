import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hoodie/Models/skin_management.dart';
import 'package:provider/provider.dart';
import '../Models/user_management.dart';
import '../app_utils.dart';
import '../widgets/skin_view.dart';

class MarketplaceFragment extends StatefulWidget {
  @override
  State<MarketplaceFragment> createState() => _MarketplaceFragmentState();
}

class _MarketplaceFragmentState extends State<MarketplaceFragment>
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
                  : MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      itemCount: skins.length,
                      itemBuilder: (context, index) {
                        return SkinView(
                          height: index % 3 == 0 ? 300 : 400,
                          skin: skins[index],
                          hasBought: HasBought.no,
                        );
                      },
                    )),
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
