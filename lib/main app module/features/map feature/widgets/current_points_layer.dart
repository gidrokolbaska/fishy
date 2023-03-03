import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fishy/constants.dart';

import 'package:fishy/models/fishy_point_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';

final pointsStreamProvider = StreamProvider.autoDispose((ref) {
  return pointsRef.snapshots().map((event) => event);
});

class CurrentPointsLayer extends ConsumerWidget {
  const CurrentPointsLayer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            markers: data.docs.map(
              (e) {
                PointModel point = e.data();
                return Marker(
                  height: 52,
                  width: 26.69,
                  point: LatLng(point.latitude, point.longitude),
                  anchorPos: AnchorPos.align(AnchorAlign.top),
                  builder: (ctx) {
                    return const FishyMarker();
                  },
                );
              },
            ).toList(),
            builder: (context, markers) {
              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                ),
                child: Text(
                  markers.length.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
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
}

class FishyMarker extends StatelessWidget {
  const FishyMarker({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('assets/images/fishy_marker.svg');
  }
}
