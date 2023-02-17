import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:fishy/constants.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/providers/zoominout_provider.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/widgets/map_top_buttons_widget.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/widgets/map_right_buttons.dart';
import 'package:fishy/main%20app%20module/providers/current_position_provider.dart';

import 'package:fishy/reusable%20widgets/fishy_icons_icons.dart';
import 'package:fishy/routing/app_router.gr.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:latlong2/latlong.dart';
import 'package:sheet/sheet.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/point_creation_list_tile.dart';
import 'point_creation_bottom_sheet.dart';

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
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    const factory = LocationMarkerDataStreamFactory();
    _followCurrentLocationStreamController = StreamController<double?>();

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
            onLongPress: (tapPosition, point) async {
              await Navigator.of(context).push(
                CreatePointSheetRoute<void>(
                  fit: SheetFit.loose,
                  barrierColor: const Color(0xff000000).withOpacity(0.5),
                  elevation: 0,
                  topControl: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              context.router.pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: red500,
                              foregroundColor: grayscaleInput,
                              minimumSize: const Size.fromWidth(85),
                            ),
                            child: const Text(
                              'Отмена',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                          Flexible(
                            child: ElevatedButton(
                              onPressed: () async {
                                Clipboard.setData(ClipboardData(
                                        text:
                                            '${point.latitude.toStringAsFixed(6)},${point.longitude.toStringAsFixed(6)}'))
                                    .then((_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      content: Text("Координаты скопированы"),
                                    ),
                                  );
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: grayscaleInput,
                                foregroundColor: Colors.black,
                              ),
                              child: Text(
                                '${point.latitude.toStringAsFixed(6)},${point.longitude.toStringAsFixed(6)}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              context.router.pop();
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: grayscaleInput,
                              //maximumSize: const Size.fromWidth(85),

                              minimumSize: const Size.fromWidth(85),
                            ),
                            child: const Text(
                              'Создать',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  builder: (context) {
                    return ListView(
                      padding: const EdgeInsets.only(
                          left: 7.0, right: 7.0, top: 7.0),
                      children: [
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            autocorrect: false,
                            textAlignVertical: TextAlignVertical.center,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              errorMaxLines: 2,
                              isCollapsed: false,
                              isDense: false,
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              floatingLabelAlignment:
                                  FloatingLabelAlignment.start,
                              filled: true,
                              fillColor: grayscaleInput,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              prefixIconColor: grayscaleOffBlack,
                              prefixIcon: const Icon(
                                FishyIcons.scroll,
                              ),
                              hintText: 'Введите название позиции',
                            ),
                            validator: FormBuilderValidators.required(),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextField(
                          autocorrect: false,
                          expands: false,
                          minLines: 1,
                          maxLines: 5,
                          decoration: InputDecoration(
                            isCollapsed: false,
                            isDense: false,
                            filled: true,
                            fillColor: grayscaleInput,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            prefixIconColor: grayscaleOffBlack,
                            hintText: 'Описание позиции',
                          ),
                        ),
                        PointCreationListTile(
                          title: 'Фотографии',
                          onTap: () {},
                        ),
                        PointCreationListTile(
                          title: 'Тип локации',
                          onTap: () {},
                        ),
                        PointCreationListTile(
                          title: 'Дата рыбалки',
                          onTap: () {},
                        ),
                      ],
                    );
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
