import 'dart:async';

import 'package:fishy/main%20app%20module/features/map%20feature/providers/zoominout_provider.dart';
import 'package:fishy/reusable%20widgets/fishy_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ZoomType {
  zoomIn,
  zoomOut,
}

class FishyMapRightButtons extends ConsumerStatefulWidget {
  final double minZoom;
  final double maxZoom;

  final double padding;
  final Alignment alignment;
  final Color? zoomInColor;
  final Color? zoomInColorIcon;
  final Color? zoomOutColor;
  final Color? zoomOutColorIcon;
  final IconData zoomInIcon;
  final IconData zoomOutIcon;
  final IconData locationIcon;
  final ValueNotifier<bool> notifier;
  final StreamController<double?> followCurrentLocationStreamController;
  final Stream<LocationMarkerPosition?> positionStream;
  final LocationMarkerPosition? locationData;

  const FishyMapRightButtons({
    super.key,
    this.minZoom = 1,
    this.maxZoom = 18,
    this.padding = 2.0,
    this.alignment = Alignment.topRight,
    this.zoomInColor,
    this.zoomInColorIcon,
    this.zoomInIcon = Icons.zoom_in,
    this.locationIcon = FishyIcons.current_geo,
    this.zoomOutColor,
    this.zoomOutColorIcon,
    this.zoomOutIcon = Icons.zoom_out,
    required this.notifier,
    required this.followCurrentLocationStreamController,
    required this.locationData,
    required this.positionStream,
  });

  @override
  ConsumerState<FishyMapRightButtons> createState() =>
      _FlutterMapZoomButtonsState();
}

class _FlutterMapZoomButtonsState extends ConsumerState<FishyMapRightButtons>
    with TickerProviderStateMixin {
  late final FitBoundsOptions options;

  @override
  void initState() {
    super.initState();

    options = FitBoundsOptions(maxZoom: widget.maxZoom);
  }

  void animateMapZoom(
      {required FlutterMapState map,
      required ZoomType zoomType,
      required bool isMaxZoom,
      required bool isMinZoom}) {
    final bounds = map.bounds;
    final centerZoom = map.getBoundsCenterZoom(bounds, options);

    final zoomTween = Tween<double>(begin: centerZoom.zoom);

    switch (zoomType) {
      case ZoomType.zoomIn:
        if (zoomTween.begin!.round() >= widget.maxZoom) {
          return;
        }
        if (isMinZoom) {
          ref.read(zoomOutStateProvider.notifier).update((state) => !state);
        }
        zoomTween.end = centerZoom.zoom + 1;

        break;
      case ZoomType.zoomOut:
        if (zoomTween.begin!.round() <= widget.minZoom) {
          return;
        }
        if (isMaxZoom) {
          ref.read(zoomInStateProvider.notifier).update((state) => !state);
        }
        zoomTween.end = centerZoom.zoom - 1;
    }

    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    controller.addListener(() {
      map.move(centerZoom.center, zoomTween.evaluate(animation),
          source: MapEventSource.custom);
    });
    // map.move(centerZoom.center, zoom, source: MapEventSource.custom);
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        switch (zoomType) {
          case ZoomType.zoomIn:
            if (zoomTween.end!.round() >= widget.maxZoom) {
              ref.read(zoomInStateProvider.notifier).update((state) => true);
            }
            break;
          case ZoomType.zoomOut:
            if (zoomTween.end!.round() <= widget.minZoom) {
              ref.read(zoomOutStateProvider.notifier).update((state) => true);
            }
            break;
          default:
        }
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final map = FlutterMapState.maybeOf(context)!;
    final isMaxZoom = ref.watch(zoomInStateProvider);
    final isMinZoom = ref.watch(zoomOutStateProvider);

    return ValueListenableBuilder(
      builder: (BuildContext context, value, Widget? child) {
        return AnimatedSlide(
          offset: value ? const Offset(0.2, 0) : Offset.zero,
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
          child: child,
        );
      },
      valueListenable: widget.notifier,
      child: Align(
        alignment: widget.alignment,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (widget.locationData != null) const Spacer(flex: 4),
            Padding(
              padding: EdgeInsets.only(
                  left: widget.padding,
                  top: widget.padding,
                  right: widget.padding),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  elevation: 0,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  shadowColor: Colors.black,
                  backgroundColor: widget.zoomInColor ??
                      Theme.of(context).primaryColor.withOpacity(0.6),
                  surfaceTintColor: Colors.white,
                  animationDuration: const Duration(milliseconds: 500),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  fixedSize: const Size(56, 56),
                ),
                onPressed: () {
                  animateMapZoom(
                    map: map,
                    zoomType: ZoomType.zoomIn,
                    isMaxZoom: isMaxZoom,
                    isMinZoom: isMinZoom,
                  );
                },
                onLongPress: () {},
                child: Icon(widget.zoomInIcon,
                    color: !isMaxZoom
                        ? widget.zoomInColorIcon ?? IconTheme.of(context).color
                        : widget.zoomInColorIcon?.withOpacity(0.5) ??
                            IconTheme.of(context).color?.withOpacity(0.5)),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(widget.padding),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  elevation: 0,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  shadowColor: Colors.black,
                  backgroundColor: widget.zoomInColor ??
                      Theme.of(context).primaryColor.withOpacity(0.6),
                  surfaceTintColor: Colors.white,
                  animationDuration: const Duration(milliseconds: 500),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  fixedSize: const Size(56, 56),
                ),
                onPressed: () {
                  animateMapZoom(
                    map: map,
                    zoomType: ZoomType.zoomOut,
                    isMaxZoom: isMaxZoom,
                    isMinZoom: isMinZoom,
                  );
                },
                onLongPress: () {},
                child: Icon(widget.zoomOutIcon,
                    color: !isMinZoom
                        ? widget.zoomOutColorIcon ?? IconTheme.of(context).color
                        : widget.zoomOutColorIcon?.withOpacity(0.5) ??
                            IconTheme.of(context).color?.withOpacity(0.5)),
              ),
            ),
            if (widget.locationData != null)
              const Spacer(
                flex: 2,
              ),
            CurrentLocationButton(
              widget: widget,
            ),
          ],
        ),
      ),
    );
  }
}

class CurrentLocationButton extends StatefulWidget {
  const CurrentLocationButton({
    super.key,
    required this.widget,
  });

  final FishyMapRightButtons widget;

  @override
  State<CurrentLocationButton> createState() => _CurrentLocationButtonState();
}

class _CurrentLocationButtonState extends State<CurrentLocationButton> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.widget.positionStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 45.0),
            child: FilledButton(
              style: FilledButton.styleFrom(
                visualDensity: VisualDensity.compact,
                elevation: 0,
                padding: EdgeInsets.zero,
                shadowColor: Colors.black,
                backgroundColor: widget.widget.zoomInColor ??
                    Theme.of(context).primaryColor.withOpacity(0.6),
                surfaceTintColor: Colors.white,
                animationDuration: const Duration(milliseconds: 500),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                fixedSize: const Size(56, 56),
              ),
              onLongPress: () {},
              onPressed: () {
                // Follow the location marker on the map and zoom the map to level 18.
                widget.widget.followCurrentLocationStreamController
                    .add(widget.widget.maxZoom - 2);
              },
              child: Icon(widget.widget.locationIcon,
                  color: widget.widget.zoomInColorIcon ??
                      IconTheme.of(context).color),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
