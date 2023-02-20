import 'package:fishy/api/database/point_service_notifier.dart';
import 'package:fishy/api/providers/client_provider.dart';

import 'package:fishy/models/fishy_point_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pointsProvider = StateNotifierProvider.family<PointServiceNotifier,
    List<PointModel>, String>(
  (ref, collectionId) {
    return PointServiceNotifier(
      client: ref.watch(clientProvider),
      collectionId: collectionId,
    );
  },
);
