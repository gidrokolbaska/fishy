import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:fishy/constants.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/providers/zoominout_provider.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/widgets/attribution_widget.dart';
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
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

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
  late final Stream<LocationMarkerPosition?> _positionStream;
  LocationMarkerPosition? initialPosition;
  bool isFirstTry = true;
  final maxZoom = 18.0;
  final minZoom = 5.0;
  final ValueNotifier<bool> _mapEventNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    _mapController = MapController();

    const factory = LocationMarkerDataStreamFactory();
    _followCurrentLocationStreamController = StreamController<double?>();
    _positionStream =
        factory.fromGeolocatorPositionStream().asBroadcastStream();
    _headingStream = factory
        .fromCompassHeadingStream(minAccuracy: pi * 0.4, maxAccuracy: pi * .4)
        .asBroadcastStream();
//TODO: возможно здесь баг. Надо проверить на реальном устройстве
// (выключить местоположение при свернутом приложении)
    _positionStream.listen((event) {
      if (isFirstTry) {
        setState(() {
          initialPosition = event;
        });

        isFirstTry = false;
      }
    }, onError: (error) {});
  }

  @override
  void dispose() {
    _followCurrentLocationStreamController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: LatLng(initialPosition?.latitude ?? 59.930309,
            initialPosition?.longitude ?? 30.361094),
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
        },
      ),
      nonRotatedChildren: [
        FishyMapTopButtons(
            notifier: _mapEventNotifier, mapController: _mapController),
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
          positionStream: _positionStream,
          locationData: initialPosition,
        ),
        CustomSimpleAttributionWidget(
          backgroundColor: const Color(0xCCFFFFFF),
          source: const Text(
            '© OpenStreetMap',
            style: TextStyle(
              color: Color(0xFF0078a8),
            ),
          ),
          onTap: () {
            final Uri url =
                Uri.parse('https://www.openstreetmap.org/copyright');
            launchUrl(url);
          },
        ),
        // AttributionWidget(
        //   alignment: Alignment.bottomRight,
        //   attributionBuilder: (context) {
        //     return ColoredBox(
        //       color: const Color(0xCCFFFFFF),
        //       child: GestureDetector(
        //         onTap: () {
        //           final Uri url =
        //               Uri.parse('https://www.openstreetmap.org/copyright');
        //           launchUrl(url);
        //         },
        //         child: const Padding(
        //           padding: EdgeInsets.all(3),
        //           child: Text(
        //             '© OpenStreetMap',
        //             style: TextStyle(color: Color(0xFF0078a8)),
        //           ),
        //         ),
        //       ),
        //     );
        //   },
        // ),
      ],
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          tileProvider: FMTC.instance('fishyStore').getTileProvider(),
          userAgentPackageName: 'com.gidrokolbaska.fishy',
        ),
        CurrentLocationLayer(
          indicators: const LocationMarkerIndicators(
            permissionDenied: Text('Доступ к местоположению запрещен'),
            permissionRequesting:
                Text('Ожидается разрешение на доступ к местоположению'),
            serviceDisabled: Text('Сервис определения геолокации отключен'),
          ),
          followOnLocationUpdate: FollowOnLocationUpdate.never,
          turnOnHeadingUpdate: TurnOnHeadingUpdate.never,
          positionStream: _positionStream,
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
        CurrentPointsLayer(
          mapController: _mapController,
        ),
      ],
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

  /// Create a position stream which is used as default value of
  /// [CurrentLocationLayer.positionStream].
  Stream<Position?> defaultPositionStreamSource() {
    final streamController = StreamController<Position?>();
    Future.microtask(() async {
      try {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          streamController.sink.addError(const PermissionRequestingException());
          permission = await Geolocator.requestPermission();
        }
        switch (permission) {
          case LocationPermission.denied:
          case LocationPermission.deniedForever:
            streamController.sink.addError(const PermissionDeniedException());
            break;
          case LocationPermission.whileInUse:
          case LocationPermission.always:
            try {
              final lastKnown = await Geolocator.getLastKnownPosition();
              if (lastKnown != null) {
                streamController.sink.add(lastKnown);
              }
            } catch (_) {}
            streamController.sink.addStream(Geolocator.getPositionStream());
            break;
          case LocationPermission.unableToDetermine:
            break;
        }
      } on PermissionDefinitionsNotFoundException {
        streamController.sink.addError(const IncorrectSetupException());
      }
    });

    return streamController.stream;
  }
}

class PermissionRequestingException implements Exception {
  /// Create a PermissionRequestingException.
  const PermissionRequestingException();
}

class PermissionDeniedException implements Exception {
  /// Create a PermissionDeniedException.
  const PermissionDeniedException();
}

class IncorrectSetupException implements Exception {
  /// Create an IncorrectSetupException.
  const IncorrectSetupException();
}
