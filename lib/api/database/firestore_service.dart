import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/providers/point_creation_providers.dart';

import 'package:fishy/models/fishy_point_model.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:latlong2/latlong.dart';

class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Ref ref;

  FirestoreService({required this.ref});
  Future<void> createPoint(
    LatLng point,
    AnimationController controller,
    BuildContext context,
  ) async {
    final String name = ref.read(positionNameProvider).text;
    final String description = ref.read(positionDescriptionProvider).text;
    final bool isDay = ref.read(dayNightProvider);
    if (name.isEmpty) {
      controller.forward();
      Vibrate.feedback(FeedbackType.warning);
      return;
    }
    PointModel pointModel = PointModel(
      positionName: name,
      positionDescription: description,
      latitude: point.latitude,
      longitude: point.longitude,
      isDay: isDay,
    );
    await pointsRef.add(pointModel);
    if (context.mounted) {
      context.router.pop();
    }
  }

  Future<void> deletePoint(PointModel point) async {}
  Future<void> editPoint(PointModel point) async {}
}

final firestoreServiceProvider = Provider<FirestoreService>(
  (ref) => FirestoreService(ref: ref),
);
