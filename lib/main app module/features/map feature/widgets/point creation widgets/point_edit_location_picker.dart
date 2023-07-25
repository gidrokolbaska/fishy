// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_route/auto_route.dart';
import 'package:fishy/constants.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/providers/point_creation_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:fishy/main%20app%20module/features/map%20feature/widgets/attribution_widget.dart';
import 'package:fishy/models/fishy_point_model.dart';

class PointEditLocationPicker extends StatefulWidget {
  const PointEditLocationPicker({
    Key? key,
    required this.point,
    required this.ref,
  }) : super(key: key);
  final PointModel point;
  final WidgetRef ref;

  @override
  State<PointEditLocationPicker> createState() =>
      _PointEditLocationPickerState();
}

class _PointEditLocationPickerState extends State<PointEditLocationPicker> {
  final MapController _mapController = MapController();
  final ValueNotifier<bool> _mapEventNotifier = ValueNotifier<bool>(false);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 28,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.router.pop(widget.point);
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
                ElevatedButton(
                  onPressed: () async {
                    context.router.pop();
                    widget.ref
                        .read(fishyCoordinatesProvider.notifier)
                        .update(_mapController.center);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: grayscaleInput,
                    //maximumSize: const Size.fromWidth(85),

                    minimumSize: const Size.fromWidth(85),
                  ),
                  child: const Text(
                    'Подтвердить',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          child: Material(
            clipBehavior: Clip.hardEdge,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(
                15,
              ),
              topRight: Radius.circular(
                15,
              ),
            ),
            color: Colors.white,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                enableScrollWheel: false,
                //interactiveFlags: InteractiveFlag.none,
                center: LatLng(
                  widget.point.latitude,
                  widget.point.longitude,
                ),
                zoom: 18,
                onMapEvent: (event) {
                  slidePinUp(event);
                },
              ),
              nonRotatedChildren: [
                CenteredLocationPin(
                  mapController: _mapController,
                  notifier: _mapEventNotifier,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0, right: 20.0),
                  child: CustomSimpleAttributionWidget(
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
                ),
              ],
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  tileProvider: FMTC.instance('fishyStore').getTileProvider(),
                  userAgentPackageName: 'com.gidrokolbaska.fishy',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void slidePinUp(MapEvent event) {
    if (event is MapEventMoveStart || event is MapEventRotateStart) {
      _mapEventNotifier.value = true;
    } else if (event is MapEventMoveEnd || event is MapEventRotateEnd) {
      _mapEventNotifier.value = false;
    }
  }
}

class CenteredLocationPin extends StatefulWidget {
  const CenteredLocationPin({
    super.key,
    required MapController mapController,
    required ValueListenable notifier,
  })  : _mapController = mapController,
        _notifier = notifier;

  final MapController _mapController;
  final ValueListenable _notifier;

  @override
  State<CenteredLocationPin> createState() => _CenteredLocationPinState();
}

class _CenteredLocationPinState extends State<CenteredLocationPin> {
  late final double top;
  late final double left;

  @override
  void initState() {
    super.initState();
    final point =
        widget._mapController.latLngToScreenPoint(widget._mapController.center);
    setState(() {
      top = point!.y;
      left = point.x;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      builder: (BuildContext context, value, Widget? child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            ClipOval(
              child: AnimatedContainer(
                alignment: Alignment.center,
                width: value ? 10 : 20,
                height: value ? 10 : 15,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(value ? 0.15 : 0.2)),
                duration: const Duration(milliseconds: 300),
              ),
            ),
            AnimatedSlide(
              offset: value ? const Offset(0, -0.015) : Offset.zero,
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              child: child,
            ),
          ],
        );
      },
      valueListenable: widget._notifier,
      child: Stack(
        alignment: Alignment.center,
        //fit: StackFit.expand,
        fit: StackFit.expand,
        children: [
          // Stack(
          //   children: [
          //     Positioned(
          //       top: top - 20 / 2,
          //       left: left - 25 / 2,
          //       child: ClipOval(
          //         child: AnimatedContainer(
          //           alignment: Alignment.center,
          //           width: value ? 10 : 25,
          //           height: value ? 10 : 20,
          //           decoration: BoxDecoration(color: Colors.red),
          //           duration: const Duration(milliseconds: 300),
          //         ),
          //       ),
          //     ),
          //     child!,
          //   ],
          // ),
          Positioned(
            width: 50,
            height: 70,
            top: top - 140 / 2,
            left: left - 50 / 2,
            child: SvgPicture.asset(
              'assets/images/mapMarker.svg',
              alignment: Alignment.bottomCenter,
              colorFilter: const ColorFilter.mode(
                primaryColor,
                BlendMode.srcIn,
              ),
              //color: colorOptions[colorIndex],
            ),
          ),
        ],
      ),
    );
  }
}
