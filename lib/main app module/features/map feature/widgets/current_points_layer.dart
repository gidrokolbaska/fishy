import 'package:auto_route/auto_route.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fishy/api/reverse_geo_rest_client.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/providers/point_creation_providers.dart';
import 'package:fishy/models/fishy_point_model.dart';
import 'package:fishy/repositories/reverse_geocoding_repo.dart';
import 'package:fishy/routing/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

// final fishyPointsFilterProvider = StateProvider((_) => FishyPointsFilter.all);
final pointsStreamProvider =
    StreamProvider.autoDispose<QuerySnapshot<PointModel>>((
  ref,
) {
  return pointsRef.snapshots();
});

class CurrentPointsLayer extends ConsumerStatefulWidget {
  const CurrentPointsLayer({
    required this.mapController,
    super.key,
  });
  final MapController mapController;

  @override
  ConsumerState<CurrentPointsLayer> createState() => _CurrentPointsLayerState();
}

class _CurrentPointsLayerState extends ConsumerState<CurrentPointsLayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _centerMarkerController;
  String currentId = '';
  double width = 26.69;
  double height = 52;

  @override
  void initState() {
    super.initState();
    _centerMarkerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _centerMarkerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pointsStream = ref.watch(pointsStreamProvider);
    return pointsStream.when(
      data: (QuerySnapshot<PointModel> data) {
        return MarkerClusterLayerWidget(
          options: MarkerClusterLayerOptions(
            rotate: true,
            rotateAlignment: Alignment.bottomCenter,
            maxClusterRadius: 80,
            spiderfyCluster: false,
            showPolygon: false,
            anchor: AnchorPos.align(AnchorAlign.top),
            disableClusteringAtZoom: 17,
            size: const Size(40, 40),
            zoomToBoundsOnClick: true,
            centerMarkerOnClick: false,
            markers: data.docs.map(
              (e) {
                PointModel point = e.data();
                return Marker(
                  rotate: true,
                  width:
                      currentId.isNotEmpty && currentId == e.id ? 76.69 : 46.69,
                  height: currentId.isNotEmpty && currentId == e.id ? 92 : 62,
                  point: LatLng(point.latitude, point.longitude),
                  anchorPos: AnchorPos.align(AnchorAlign.top),
                  builder: (ctx) {
                    return GestureDetector(
                      child: FishyMarker(
                        colorIndex: point.markerColor,
                        iconIndex: point.markerIcon,
                      ),
                      onLongPress: () {},
                      onTap: () {
                        if (currentId.isNotEmpty && currentId == e.id) {
                          return;
                        } else {
                          setState(() {
                            currentId = e.id;
                          });

                          showFishingInfoToast(context, point, e);

                          _animateToCenter(point);
                        }
                      },
                    );
                  },
                );
              },
            ).toList(),
            builder: (context, markers) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    markers.length.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          ),
        );
      },
      error: (Object error, StackTrace stackTrace) {
        return Center(
          child: Text('$error'),
        );
      },
      loading: () {
        return const CircularProgressIndicator.adaptive();
      },
    );
  }

  void _animateToCenter(PointModel point) {
    final center = widget.mapController.center;
    final latTween = Tween<double>(begin: center.latitude, end: point.latitude);
    final lonTween =
        Tween<double>(begin: center.longitude, end: point.longitude);

    final Animation<double> animation = CurvedAnimation(
      parent: _centerMarkerController,
      curve: Curves.fastOutSlowIn,
    );

    final listener = _centerMarkerListener(animation, latTween, lonTween);
    _centerMarkerController.addListener(listener);
    _centerMarkerController.forward().then((_) {
      _centerMarkerController
        ..removeListener(listener)
        ..reset();
    });
  }

  VoidCallback _centerMarkerListener(
    Animation<double> animation,
    Tween<double> latTween,
    Tween<double> lonTween, {
    Tween<double>? zoomTween,
  }) {
    return () {
      widget.mapController.move(
        LatLng(latTween.evaluate(animation), lonTween.evaluate(animation)),
        zoomTween?.evaluate(animation) ?? widget.mapController.zoom,
      );
    };
  }

  String? getName(String locale, LocalNames locationName) {
    final shortLocale = Intl.shortLocale(locale);

    switch (shortLocale) {
      case 'ar':
        return locationName.ar ?? locationName.en;
      case 'bg':
        return locationName.bg ?? locationName.en;
      case 'ca':
        return locationName.ca ?? locationName.en;
      case 'de':
        return locationName.de ?? locationName.en;
      case 'el':
        return locationName.el ?? locationName.en;
      case 'fa':
        return locationName.fa ?? locationName.en;
      case 'fi':
        return locationName.fi ?? locationName.en;
      case 'fr':
        return locationName.fr ?? locationName.en;
      case 'gl':
        return locationName.gl ?? locationName.en;
      case 'he':
        return locationName.he ?? locationName.en;
      case 'ru':
        return locationName.ru ?? locationName.en;
      case 'en':
        return locationName.en;
      case 'hi':
        return locationName.hi ?? locationName.en;
      case 'id':
        return locationName.id ?? locationName.en;
      case 'it':
        return locationName.it ?? locationName.en;
      case 'ja':
        return locationName.ja ?? locationName.en;
      case 'la':
        return locationName.la ?? locationName.en;
      case 'lt':
        return locationName.lt ?? locationName.en;
      case 'pt':
        return locationName.pt ?? locationName.en;
      case 'sr':
        return locationName.sr ?? locationName.en;
      case 'th':
        return locationName.th ?? locationName.en;
      case 'tr':
        return locationName.tr ?? locationName.en;
      case 'vi':
        return locationName.vi ?? locationName.en;
      case 'az':
        return locationName.az ?? locationName.en;
      case 'nl':
        return locationName.nl ?? locationName.en;
      case 'pl':
        return locationName.pl ?? locationName.en;
      default:
        return locationName.en;
    }
  }

  void showFishingInfoToast(BuildContext context, PointModel point,
      QueryDocumentSnapshot<PointModel> e) {
    BotToast.showCustomNotification(
      align: Alignment.topCenter,
      enableSlideOff: true,
      crossPage: false,
      onClose: () {
        WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) {
            if (currentId.isNotEmpty && currentId == e.id) {
              setState(
                () {
                  currentId = '';
                },
              );
            }
          },
        );
      },
      duration: const Duration(seconds: 20),
      wrapToastAnimation: (controller, cancelFunc, widget) {
        final CurvedAnimation heightM3Animation = CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOutQuart,
          reverseCurve: const Threshold(0.0),
        );
        return FadeTransition(
          opacity: controller,
          child: AnimatedBuilder(
            animation: heightM3Animation,
            builder: (BuildContext context, Widget? child) {
              return Align(
                alignment: AlignmentDirectional.bottomStart,
                heightFactor: heightM3Animation.value,
                child: child,
              );
            },
            child: widget,
          ),
        );
      },
      toastBuilder: (void Function() cancelFunc) {
        bool canBePressed = true;
        return GestureDetector(
          onTap: () {
            if (canBePressed) {
              canBePressed = false;
              context.pushRoute(
                PointDetailsScreenRoute(pointSnapshot: e),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            height: 90,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 4),
                    blurRadius: 20,
                    spreadRadius: 2,
                    color:
                        Theme.of(context).colorScheme.shadow.withOpacity(0.2),
                    blurStyle: BlurStyle.inner,
                  ),
                ],
                borderRadius: BorderRadius.circular(
                  10,
                ),
                color: Theme.of(context).colorScheme.surface),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 70,
                  height: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                    color: colorOptions[point.markerColor],
                  ),
                  child: Icon(
                    iconOptions[point.markerIcon],
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        point.positionName,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          final locationData = ref.watch(
                            reverseGeocodingRepositoryGetLocationProvider(
                              lat: point.latitude,
                              lon: point.longitude,
                              limit: 3,
                            ),
                          );

                          return locationData.when(
                            data: (data) {
                              final name = getName(
                                  Intl.systemLocale, data.first.localNames!);

                              return Expanded(
                                child: Text(
                                  '${name ?? ''}${name == null ? '' : ', '}дата рыбалки: ${DateFormat.yMMMMd().format(
                                    point.dateOfFishing.toDate(),
                                  )}',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            },
                            error: (error, stackTrace) {
                              return Text(error.toString());
                            },
                            loading: () {
                              return const CircularProgressIndicator.adaptive();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FishyMarker extends StatelessWidget {
  const FishyMarker(
      {super.key, required this.colorIndex, required this.iconIndex});
  final int colorIndex;
  final int iconIndex;
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      alignment: Alignment.bottomCenter,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          SvgPicture.asset(
            'assets/images/mapMarker.svg',
            alignment: Alignment.bottomCenter,
            color: colorOptions[colorIndex],
            width: 93,
          ),
          Positioned(
            top: 7,
            child: Icon(
              iconOptions[iconIndex],
              size: 35,
              color: Colors.white,
              //size: MediaQuery.of(context).size.width,
            ),
          ),
        ],
      ),
    );
  }
}
