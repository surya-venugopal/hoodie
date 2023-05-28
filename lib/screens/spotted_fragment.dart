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
  var _isinit = true;
  late VideoPlayerController _videoPlayerController;

  @override
  void didChangeDependencies() {
    if (_isinit) {
      provider = Provider.of<SpotProvider>(context);
      provider.getAllSpots(MediaQuery.of(context).size.width);
      _isinit = false;
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return provider.spots.isEmpty
        ? const Center(
            child: Text("You are not spotted!"),
          )
        : FlutterMap(
            options: MapOptions(
              center: provider.params["center"] as LatLng,
              zoom: provider.params["zoom"] as double,
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
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.ivin.hoodie',
              ),
              PolylineLayer(
                polylineCulling: false,
                polylines: [
                  Polyline(
                    points: [
                      ...provider.spots.map((spot) {
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
                  ...provider.spots.map(
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
                                      contentPadding: const EdgeInsets.all(20),
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            AspectRatio(
                                              aspectRatio:
                                                  _videoPlayerController
                                                      .value.aspectRatio,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(30),
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
                                                      BorderRadius.circular(30),
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
          );
  }

  @override
  bool get wantKeepAlive => true;
}
