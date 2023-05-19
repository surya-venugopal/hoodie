import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hoodie/Models/skin_management.dart';
import 'package:hoodie/Models/favorite_provider.dart';
import 'package:provider/provider.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';
import '../app_utils.dart';
import '../widgets/skin_view.dart';

class MarketplaceFragment extends StatefulWidget {
  @override
  State<MarketplaceFragment> createState() => _MarketplaceFragmentState();
}

class _MarketplaceFragmentState extends State<MarketplaceFragment>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  late List<SkinModel> skins;
  late SkinsProvider skinProvider;
  late FavoriteProvider favoriteProvider;
  @override
  void initState() {
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;

      if (maxScroll - currentScroll <= delta) {
        skinProvider.getSkins(search: searchController.text);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  bool isInit = true;

  @override
  Widget build(BuildContext context) {
    skinProvider = Provider.of<SkinsProvider>(context, listen: true);
    favoriteProvider = Provider.of<FavoriteProvider>(context, listen: true);
    if (isInit) {
      favoriteProvider.init().then((value) {
        favoriteProvider.fetchData();
      });
      isInit = false;
    }
    skins = skinProvider.skins;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          ScrollAppBar(
            controller: _scrollController,
            flexibleSpace: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10, top: 20),
                  child: Text(
                    "Discover Skins",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      if (value.length > 2) {
                        skinProvider.skins = [];
                        skinProvider.getSkins(search: value);
                      } else if (value.isEmpty) {
                        skinProvider.skins = [];
                        skinProvider.getSkins();
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: "Search",
                      fillColor: Color(0xffE2DEFF),
                      filled: true,
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: Colors.black38,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.favorite_border,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ...["Premium", "Trending", "Offer zone"].map((item) {
                        return Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                // color: Colors.black87,
                                border:
                                    Border.all(width: 1, color: Colors.black87),
                              ),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: Text(
                                item,
                                style: const TextStyle(
                                  // color: Colors.white,
                                  fontFamily: "poppins",
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        );
                      }).toList()
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          Expanded(
            child: skins.isEmpty && !skinProvider.isLoading
                ? const Center(
                    child: Text('You owned all the skins!'),
                  )
                : MasonryGridView.count(
                    controller: _scrollController,
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 10,
                    itemCount: skins.length,
                    itemBuilder: (context, index) {
                      return SkinView(
                        height: [
                          200.0,
                          300.0,
                          250.0,
                          280.0,
                          220.0,
                          250.0,
                          290.0
                        ][index % 7],
                        skin: skins[index],
                        hasBought: HasBought.no,
                        favoriteProvider: favoriteProvider,
                      );
                    },
                  ),
          ),
          skinProvider.isLoading
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(5),
                  color: Colors.yellowAccent,
                  child: const CupertinoActivityIndicator(
                    color: Colors.black,
                  ))
              : Container()
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
