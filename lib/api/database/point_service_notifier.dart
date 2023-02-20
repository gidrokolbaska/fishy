import 'package:appwrite/appwrite.dart';
import 'package:fishy/models/fishy_point_model.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/models.dart' as models;

class PointServiceNotifier extends StateNotifier<List<PointModel>> {
  final Client client;
  final String collectionId;
  late final Databases databases;

  late final Realtime realtime;
  late RealtimeSubscription subscription;

  final List<PointModel> _points = [];

  PointServiceNotifier({
    required this.client,
    required this.collectionId,
  }) : super([]) {
    databases = Databases(client);
    realtime = Realtime(client);
    subscription = realtime.subscribe(
      ['databases.fishydatabase.collections.$collectionId.documents'],
    );
    _getExistingPoints();
    _getRealtimePoints();
  }

  void _getExistingPoints() async {
    try {
      final models.DocumentList temp = await databases.listDocuments(
          databaseId: 'fishydatabase', collectionId: collectionId);
      final response = temp.documents;

      ///Adding all the elements from database to [_points]
      for (var point in response) {
        _points.add(
          PointModel.fromMap(point.data),
        );
      }

      if (!mounted) {
        return;
      }

      ///Updating the state
      state = _points;
    } on AppwriteException catch (e) {
      rethrow;
    }
  }

  void _getRealtimePoints() {
    subscription.stream.listen((point) {
      if (point.events.contains(
          'databases.fishydatabase.collections.$collectionId.documents.*.create')) {
        PointModel pointModel = PointModel.fromMap(point.payload);
        _points.add(pointModel);
        state = [...state, pointModel];
      } else if (point.events.contains(
          'databases.fishydatabase.collections.$collectionId.documents.*.delete')) {
        PointModel pointModel = PointModel.fromMap(point.payload);
        //TODO: here is the bug. Appwrite doesn't support doubles with precision higher than 4.... Switching to firebase from now on
        _points.remove(pointModel);
        state = _points;
      }
    });
  }

  Future<void> createPointDocument(PointModel pointModel) async {
    try {
      await databases.createDocument(
          databaseId: 'fishydatabase',
          collectionId: collectionId,
          documentId: ID.unique(),
          data: pointModel.toMap());
    } on AppwriteException catch (e) {
      rethrow;
    }
  }

  @override
  void dispose() {
    print('disposed....');
    subscription.close();
    super.dispose();
  }
}
