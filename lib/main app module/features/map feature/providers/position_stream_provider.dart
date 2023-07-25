import 'dart:async';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';

/// Create a position stream which is used as default value of
/// [CurrentLocationLayer.positionStream].
Stream<Position?> defaultPositionStreamSource() {
  final streamController = StreamController<Position?>();
  Future.microtask(() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        streamController.sink.add(null);
        permission = await Geolocator.requestPermission();
      }
      switch (permission) {
        case LocationPermission.denied:
        case LocationPermission.deniedForever:
          streamController.sink.add(null);
          break;
        case LocationPermission.whileInUse:
        case LocationPermission.always:
          final lastKnown = await Geolocator.getLastKnownPosition();
          if (lastKnown != null) {
            streamController.sink.add(lastKnown);
          }
          streamController.sink.addStream(Geolocator.getPositionStream());
          break;
        case LocationPermission.unableToDetermine:
          break;
      }
    } on PermissionDefinitionsNotFoundException {
      streamController.sink.add(null);
    }
  });
  return streamController.stream;
}
