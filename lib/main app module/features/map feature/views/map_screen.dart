import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:fishy/constants.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/providers/zoominout_provider.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/widgets/current_points_layer.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/widgets/map_top_buttons_widget.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/widgets/map_right_buttons.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/widgets/point%20creation%20widgets/point_creation_body.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/widgets/point%20creation%20widgets/top_control_widget.dart';
import 'package:fishy/reusable%20widgets/fishy_icons_icons.dart';
import 'package:fishy/routing/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/position_stream_provider.dart';

class FishyMapScreen extends ConsumerStatefulWidget {
  const FishyMapScreen({
    super.key,
  });

  @override
  ConsumerState<FishyMapScreen> createState() => _FishyMapScreenState();
}

class _FishyMapScreenState extends ConsumerState<FishyMapScreen> {
  late final MapController _mapController;
  late final StreamController<double?> _followCurrentLocationStreamController;

  late final Stream<LocationMarkerHeading?> _headingStream;
  final maxZoom = 18.0;
  final minZoom = 5.0;
  final ValueNotifier<bool> _mapEventNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    _mapController = MapController();
    const factory = LocationMarkerDataStreamFactory();
    _followCurrentLocationStreamController = StreamController<double?>();

    _headingStream = factory
        .fromCompassHeadingStream(minAccuracy: pi * 0.4, maxAccuracy: pi * .4)
        .asBroadcastStream();
    // bool isFirstTry = false;
    // _positionStream =
    //     factory.fromGeolocatorPositionStream().asBroadcastStream();
    // _positionStream.listen((event) {
    //   if (!isFirstTry) {
    //     setState(() {
    //       initialPosition = event;
    //     });

    //     isFirstTry = true;
    //   }
    // });
  }

  @override
  void dispose() {
    _followCurrentLocationStreamController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final position = ref.watch(positionStreamProvider);
    return position.when(
      skipError: true,
      data: (LocationMarkerPosition? data) {
        return FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: LatLng(
                data?.latitude ?? 59.930309, data?.longitude ?? 30.361094),
            zoom: maxZoom,
            maxZoom: maxZoom,
            minZoom: minZoom,
            onMapEvent: (event) {
              fadeZoomButtons(event);
              slideButtonsAway(event);
            },
            onLongPress: (tapPosition, point) async {
              context.pushRoute(
                PointCreationMainRoute(
                  child: (controller) {
                    return PointCreationBody(
                      controller: controller,
                    );
                  },
                  topControl: (controller) {
                    return TopControlWidget(
                      point: point,
                      controller: controller,
                    );
                  },
                ),
              );

              // context.pushRoute(const EmptyRouterPageRoute());
              // context.pushRoute(
              //   CreatePointBottomSheetRoute(
              //     child: (context, animationController) {
              //       return PointCreationBody(
              //         controller: animationController,
              //       );
              //     },
              //     control: (context, controller) {
              //       return TopControlWidget(
              //         point: point,
              //         controller: controller,
              //       );
              //     },
              //   ),
              // );
              // await Navigator.of(context).push(
              //   CreatePointSheetRoute<void>(
              //     fit: SheetFit.expand,
              //     barrierColor: const Color(0xff000000).withOpacity(0.5),
              //     elevation: 0,
              //     enableDrag: false,
              //     child: (controller) {
              //       return PointCreationBody(
              //         controller: controller,
              //       );
              //     },
              //     topControl: (controller) {
              //       return TopControlWidget(
              //         point: point,
              //         controller: controller,
              //       );
              //     },
              //   ),
              // );
            },
          ),
          nonRotatedChildren: [
            FishyMapTopButtons(notifier: _mapEventNotifier),
            FishyMapRightButtons(
              notifier: _mapEventNotifier,
              minZoom: minZoom,
              maxZoom: 18,
              padding: 18,
              zoomInIcon: FishyIcons.plus,
              zoomOutIcon: FishyIcons.minus,
              alignment: Alignment.centerRight,
              followCurrentLocationStreamController:
                  _followCurrentLocationStreamController,
              locationData: data,
            ),
            AttributionWidget(
              alignment: Alignment.bottomRight,
              attributionBuilder: (context) {
                return ColoredBox(
                  color: const Color(0xCCFFFFFF),
                  child: GestureDetector(
                    onTap: () {
                      final Uri url =
                          Uri.parse('https://www.openstreetmap.org/copyright');
                      launchUrl(url);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(3),
                      child: Text(
                        '© OpenStreetMap',
                        style: TextStyle(color: Color(0xFF0078a8)),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              tileProvider: FMTC.instance('fishyStore').getTileProvider(),
              userAgentPackageName: 'com.gidrokolbaska.fishy',
            ),
            CurrentLocationLayer(
              onErrorAlign: Alignment.bottomLeft,
              followOnLocationUpdate: FollowOnLocationUpdate.never,
              turnOnHeadingUpdate: TurnOnHeadingUpdate.never,
              headingStream: _headingStream,
              followCurrentLocationStream:
                  _followCurrentLocationStreamController.stream,
              followAnimationDuration: const Duration(
                seconds: 2,
              ),
              followAnimationCurve: Curves.fastOutSlowIn,
              style: const LocationMarkerStyle(
                headingSectorRadius: 40,
                marker: DefaultLocationMarker(
                  color: red500,
                ),
              ),
            ),
            const CurrentPointsLayer(),
          ],
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      },
      error: (error, StackTrace stackTrace) {
        return Center(child: Text('$error'));
      },
    );
  }

  ///Logic for fading zoom buttons if we reached max/min zoom

  void fadeZoomButtons(MapEvent event) {
    if (event is MapEventMoveEnd &&
        event.source == MapEventSource.multiFingerEnd) {
      if (_mapController.zoom >= maxZoom && !ref.read(zoomInStateProvider)) {
        ref.read(zoomInStateProvider.notifier).update((state) => true);
      }
      if (_mapController.zoom < maxZoom && ref.read(zoomInStateProvider)) {
        ref.read(zoomInStateProvider.notifier).update((state) => false);
      }
      if (_mapController.zoom <= minZoom && !ref.read(zoomOutStateProvider)) {
        ref.read(zoomOutStateProvider.notifier).update((state) => true);
      }
      if (_mapController.zoom > minZoom && ref.read(zoomOutStateProvider)) {
        ref.read(zoomOutStateProvider.notifier).update((state) => false);
      }
    }
  }

  ///Logic for sliding all overlay buttons away from the screen when [MapEvent] is [MapEventMoveStart]

  void slideButtonsAway(MapEvent event) {
    if (event is MapEventMoveStart || event is MapEventRotateStart) {
      _mapEventNotifier.value = true;
    } else if (event is MapEventMoveEnd || event is MapEventRotateEnd) {
      _mapEventNotifier.value = false;
    }
  }
}
