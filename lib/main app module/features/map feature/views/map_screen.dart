import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:fishy/constants.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/providers/zoominout_provider.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/widgets/map_top_buttons_widget.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/widgets/map_right_buttons.dart';
import 'package:fishy/main%20app%20module/providers/current_position_provider.dart';

import 'package:fishy/reusable%20widgets/fishy_icons_icons.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class FishyMapScreen extends ConsumerStatefulWidget {
  const FishyMapScreen({
    super.key,
  });

  @override
  ConsumerState<FishyMapScreen> createState() => _TestMapScreenState();
}

class _TestMapScreenState extends ConsumerState<FishyMapScreen> {
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
    // _headingStreamController = StreamController()
    //   ..add(
    //     LocationMarkerHeading(
    //       heading: 0,
    //       accuracy: pi * 0.2,
    //     ),
    //   );
    _headingStream = factory
        .fromCompassHeadingStream(minAccuracy: pi * 0.4, maxAccuracy: pi * .4)
        .asBroadcastStream();
  }

  @override
  void dispose() {
    _followCurrentLocationStreamController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(currentPositionFutureProvider, (previous, next) {
      if (next.value == null) {
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
    final locationAsync = ref.watch(currentPositionFutureProvider);
    return locationAsync.when(
      data: (position) {
        return FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: LatLng(
                position?.latitude ?? 59.9311, position?.longitude ?? 30.3609),
            zoom: maxZoom,
            maxZoom: maxZoom,
            minZoom: minZoom,
            onMapEvent: (event) {
              fadeZoomButtons(event);
              slideButtonsAway(event);
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
            AttributionWidget.defaultWidget(
              source: '© OpenStreetMap',
              onSourceTapped: () async {
                final Uri url =
                    Uri.parse('https://www.openstreetmap.org/copyright');
                launchUrl(url);
              },
            ),
          ],
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.gidrokolbaska.fishy',
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
        );
      },
      error: (Object error, StackTrace stackTrace) {
        print('hello?');
        return Text('Error: $error');
      },
      loading: () {
        return const CircularProgressIndicator.adaptive();
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
