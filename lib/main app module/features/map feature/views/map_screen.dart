import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:fishy/api/providers/map_repository_provider.dart';
import 'package:fishy/constants.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/controllers/map_controller.dart';

import 'package:fishy/main%20app%20module/features/map%20feature/providers/zoominout_provider.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/widgets/map_top_buttons_widget.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/widgets/map_right_buttons.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/widgets/point%20creation%20widgets/point_creation_body.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/widgets/point%20creation%20widgets/top_control_widget.dart';

import 'package:fishy/providers/current_collection_id_provider.dart';
import 'package:fishy/providers/points_state_notifier_provider.dart';
import 'package:fishy/reusable%20widgets/fishy_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:sheet/sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'point_creation_bottom_sheet_view.dart';

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
    //createData();
    _mapController = MapController();
    const factory = LocationMarkerDataStreamFactory();
    _followCurrentLocationStreamController = StreamController<double?>();

    _headingStream = factory
        .fromCompassHeadingStream(minAccuracy: pi * 0.4, maxAccuracy: pi * .4)
        .asBroadcastStream();
  }

  // Future<void> createData() async {
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
  //     await ref
  //         .read(mapScreenControllerProvider.notifier)
  //         .fetchAndCreateAllRequiredData();
  //   });
  // }

  @override
  void dispose() {
    _followCurrentLocationStreamController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('test rebuild');
    final mapLoadingState = ref.watch(mapScreenControllerProvider);
    final mapRepo = ref.watch(mapRepositoryProvider);

    ref.listen(mapRepositoryProvider, (previous, next) {
      if (next.position == null) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Предупреждение'),
            content: const Text(
                'Сервисы геолокации отключены, либо Вы не дали разрешение на их использование. Текущее местоположение будет недоступно, пока Вы не активируете сервисы вручную'),
            actions: [
              TextButton(
                onPressed: () {
                  context.router.pop();
                },
                child: const Text("ОК"),
              )
            ],
          ),
        );
      }
    });
    return Center(
      child: mapLoadingState.isLoading
          ? const CircularProgressIndicator.adaptive()
          : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: LatLng(mapRepo.position?.latitude ?? 59.9311,
                    mapRepo.position?.longitude ?? 30.3609),
                zoom: maxZoom,
                maxZoom: maxZoom,
                minZoom: minZoom,
                onMapEvent: (event) {
                  fadeZoomButtons(event);
                  slideButtonsAway(event);
                },
                onLongPress: (tapPosition, point) async {
                  await Navigator.of(context).push(
                    CreatePointSheetRoute<void>(
                      fit: SheetFit.loose,
                      barrierColor: const Color(0xff000000).withOpacity(0.5),
                      elevation: 0,
                      enableDrag: false,
                      topControl: TopControlWidget(point: point),
                      builder: (context) {
                        return PointCreationBody();
                      },
                    ),
                  );
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
                ),
                AttributionWidget(
                  alignment: Alignment.bottomRight,
                  attributionBuilder: (context) {
                    return ColoredBox(
                      color: const Color(0xCCFFFFFF),
                      child: GestureDetector(
                        onTap: () {
                          final Uri url = Uri.parse(
                              'https://www.openstreetmap.org/copyright');
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
                Consumer(
                  builder:
                      (BuildContext context, WidgetRef ref, Widget? child) {
                    final collectionId = ref.watch(collectionIdProvider);
                    final currentPointsData =
                        ref.watch(pointsProvider(collectionId!));

                    return MarkerLayer(
                        markers: currentPointsData
                            .map(
                              (point) => Marker(
                                point: LatLng(point.lat, point.lon),
                                builder: (context) => Container(
                                  width: 10,
                                  height: 10,
                                  color: Colors.red,
                                ),
                              ),
                            )
                            .toList());
                  },
                ),
                CurrentLocationLayer(
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
              ],
            ),
    );

    // final mapData = ref.watch(mapProvider);

    // return mapData.when(
    //   data: (fetchedmapData) {
    //     return FlutterMap(
    //       mapController: _mapController,
    //       options: MapOptions(
    //         center: LatLng(fetchedmapData.currentPosition?.latitude ?? 59.9311,
    //             fetchedmapData.currentPosition?.longitude ?? 30.3609),
    //         zoom: maxZoom,
    //         maxZoom: maxZoom,
    //         minZoom: minZoom,
    //         onMapEvent: (event) {
    //           fadeZoomButtons(event);
    //           slideButtonsAway(event);
    //         },
    //         onLongPress: (tapPosition, point) async {
    //           await Navigator.of(context).push(
    //             CreatePointSheetRoute<void>(
    //               fit: SheetFit.loose,
    //               barrierColor: const Color(0xff000000).withOpacity(0.5),
    //               elevation: 0,
    //               enableDrag: false,
    //               topControl: TopControlWidget(point: point),
    //               builder: (context) {
    //                 return PointCreationBody();
    //               },
    //             ),
    //           );
    //         },
    //       ),
    //       nonRotatedChildren: [
    //         FishyMapTopButtons(notifier: _mapEventNotifier),
    //         FishyMapRightButtons(
    //           notifier: _mapEventNotifier,
    //           minZoom: minZoom,
    //           maxZoom: 18,
    //           padding: 18,
    //           zoomInIcon: FishyIcons.plus,
    //           zoomOutIcon: FishyIcons.minus,
    //           alignment: Alignment.centerRight,
    //           followCurrentLocationStreamController:
    //               _followCurrentLocationStreamController,
    //         ),
    //         AttributionWidget(
    //           alignment: Alignment.bottomRight,
    //           attributionBuilder: (context) {
    //             return ColoredBox(
    //               color: const Color(0xCCFFFFFF),
    //               child: GestureDetector(
    //                 onTap: () {
    //                   final Uri url =
    //                       Uri.parse('https://www.openstreetmap.org/copyright');
    //                   launchUrl(url);
    //                 },
    //                 child: const Padding(
    //                   padding: EdgeInsets.all(3),
    //                   child: Text(
    //                     '© OpenStreetMap',
    //                     style: TextStyle(color: Color(0xFF0078a8)),
    //                   ),
    //                 ),
    //               ),
    //             );
    //           },
    //         ),
    //       ],
    //       children: [
    //         TileLayer(
    //           urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    //           tileProvider: FMTC.instance('fishyStore').getTileProvider(),
    //           userAgentPackageName: 'com.gidrokolbaska.fishy',
    //         ),
    //         Consumer(
    //           builder: (BuildContext context, WidgetRef ref, Widget? child) {
    //             final collectionId = ref.watch(collectionIdProvider);
    //             final currentPointsData =
    //                 ref.watch(pointsProvider(collectionId!));
    //             return MarkerLayer(
    //                 markers: currentPointsData
    //                     .map(
    //                       (point) => Marker(
    //                         point: LatLng(point.lat, point.lon),
    //                         builder: (context) => Container(
    //                           width: 10,
    //                           height: 10,
    //                           color: Colors.red,
    //                         ),
    //                       ),
    //                     )
    //                     .toList());
    //           },
    //         ),
    //         CurrentLocationLayer(
    //           followOnLocationUpdate: FollowOnLocationUpdate.never,
    //           turnOnHeadingUpdate: TurnOnHeadingUpdate.never,
    //           headingStream: _headingStream,
    //           followCurrentLocationStream:
    //               _followCurrentLocationStreamController.stream,
    //           followAnimationDuration: const Duration(
    //             seconds: 2,
    //           ),
    //           followAnimationCurve: Curves.fastOutSlowIn,
    //           style: const LocationMarkerStyle(
    //             headingSectorRadius: 40,
    //             marker: DefaultLocationMarker(
    //               color: red500,
    //             ),
    //           ),
    //         ),
    //       ],
    //     );
    //   },
    //   error: (Object error, StackTrace stackTrace) {
    //     return Center(child: Text('Error: $error,StackTrace:$stackTrace'));
    //   },
    //   loading: () {
    //     return const CircularProgressIndicator.adaptive();
    //   },
    // );
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
