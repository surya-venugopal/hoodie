import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hoodie/Models/spot_management.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class SpottedFragment extends StatefulWidget {
  const SpottedFragment({super.key});

  @override
  State<SpottedFragment> createState() => _SpottedFragmentState();
}

class _SpottedFragmentState extends State<SpottedFragment>
    with AutomaticKeepAliveClientMixin<SpottedFragment> {
  late SpotProvider provider;
  late VideoPlayerController _videoPlayerController;
  bool today = true;

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {});
    super.initState();
  }

  bool _isInit = true;
  @override
  Widget build(BuildContext context) {
    if (_isInit) {
      provider = Provider.of<SpotProvider>(context);
      provider.getAllSpots(MediaQuery.of(context).size.width);
      _isInit = false;
    }
    return provider.params.isEmpty
        ? const Center(child: Text("Loading..."))
        : Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  center: (provider.params["center"] as LatLng).latitude.isNaN
                      ? LatLng(12, 77)
                      : provider.params["center"] as LatLng,
                  zoom: max(provider.params["zoom"] as double, 3),
                  maxZoom: 15,
                  rotationThreshold: 0,
                ),
                // nonRotatedChildren: [
                //   AttributionWidget.defaultWidget(
                //     source: 'OpenStreetMap contributors',
                //     onSourceTapped: null,
                //   ),
                // ],
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.ivin.hoodie',
                  ),
                  PolylineLayer(
                    polylineCulling: false,
                    polylines: [
                      Polyline(
                        points: [
                          ...provider.spots.where((spot) {
                            var now = DateTime.now();
                            if (today) {
                              return spot.time.day == now.day &&
                                  spot.time.month == now.month &&
                                  spot.time.year == now.year;
                            } else {
                              return spot.time.isAfter(DateTime.now()
                                  .subtract(const Duration(days: 30)));
                            }
                          }).map((spot) {
                            return LatLng(spot.latitude, spot.longitude);
                          }).toList()
                        ],
                        color: Colors.red,
                        strokeWidth: 3,
                        isDotted: false,
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      ...provider.spots.where((spot) {
                        var now = DateTime.now();
                        if (today) {
                          return spot.time.day == now.day &&
                              spot.time.month == now.month &&
                              spot.time.year == now.year;
                        } else {
                          return spot.time.isAfter(DateTime.now()
                              .subtract(const Duration(days: 30)));
                        }
                      }).map(
                        (spot) => Marker(
                          point: LatLng(spot.latitude, spot.longitude),
                          builder: (context) => GestureDetector(
                            onTap: () async {
                              _videoPlayerController = VideoPlayerController
                                  .network(spot.videoUrl)
                                ..initialize().then((_) {
                                  // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                                  // setState(() {});
                                  _videoPlayerController.setLooping(true);
                                  _videoPlayerController.play();
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          contentPadding:
                                              const EdgeInsets.all(20),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30))),
                                          content: SizedBox(
                                            width: double.infinity,
                                            height: _videoPlayerController
                                                        .value.aspectRatio >
                                                    1
                                                ? 300
                                                : max(
                                                    700,
                                                    300 /
                                                        _videoPlayerController
                                                            .value.aspectRatio),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                AspectRatio(
                                                  aspectRatio:
                                                      _videoPlayerController
                                                          .value.aspectRatio,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    child: VideoPlayer(
                                                        _videoPlayerController),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Date : ${DateFormat("yMd").format(spot.time)}",
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Time : ${DateFormat.jm().format(spot.time)}",
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      color: Colors.black),
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                    "Share",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                });
                            },
                            child: Icon(
                              Icons.location_on,
                              color: Colors.indigo[900],
                              size: 35,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        left: 25, right: 25, top: 15, bottom: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    width: double.infinity,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          provider.spots.isEmpty ||
                                  provider.spots.where((spot) {
                                    var now = DateTime.now();
                                    if (today) {
                                      return spot.time.day == now.day &&
                                          spot.time.month == now.month &&
                                          spot.time.year == now.year;
                                    } else {
                                      return spot.time.isAfter(DateTime.now()
                                          .subtract(const Duration(days: 30)));
                                    }
                                  }).isEmpty
                              ? "You are not spotted!"
                              : "No of times spotted:",
                          style: const TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w100),
                        ),
                        const SizedBox(width: 30),
                        if (provider.spots.isEmpty ||
                            provider.spots.where((spot) {
                              var now = DateTime.now();
                              if (today) {
                                return spot.time.day == now.day &&
                                    spot.time.month == now.month &&
                                    spot.time.year == now.year;
                              } else {
                                return spot.time.isAfter(DateTime.now()
                                    .subtract(const Duration(days: 30)));
                              }
                            }).isNotEmpty)
                          Text(
                            provider.spots
                                .where((spot) {
                                  var now = DateTime.now();
                                  if (today) {
                                    return spot.time.day == now.day &&
                                        spot.time.month == now.month &&
                                        spot.time.year == now.year;
                                  } else {
                                    return spot.time.isAfter(DateTime.now()
                                        .subtract(const Duration(days: 30)));
                                  }
                                })
                                .length
                                .toString(),
                            style: TextStyle(
                                fontFamily: "Poppins",
                                color: Theme.of(context).primaryColor),
                          ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        today = !today;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                      width: 180,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            width: 80,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: !today
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(30)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Text(
                              "Today",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w100,
                                  color: !today
                                      ? Theme.of(context).primaryColor
                                      : Colors.white),
                            ),
                          ),
                          const SizedBox(width: 10),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            width: 80,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: today
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(30)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Text(
                              "30 days",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w100,
                                  color: today
                                      ? Theme.of(context).primaryColor
                                      : Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
  }

  @override
  bool get wantKeepAlive => true;
}
