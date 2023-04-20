import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hoodie/Models/spot_management.dart';
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
                          _videoPlayerController =
                              VideoPlayerController.network(spot.videoUrl)
                                ..initialize().then((_) {
                                  // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                                  // setState(() {});
                                  _videoPlayerController.setLooping(true);
                                  _videoPlayerController.play();
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Column(
                                          children: [
                                            Text(spot.time.toString()),
                                            Expanded(
                                              child: AspectRatio(
                                                aspectRatio:
                                                    _videoPlayerController
                                                        .value.aspectRatio,
                                                child: VideoPlayer(
                                                    _videoPlayerController),
                                              ),
                                            ),
                                          ],
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
