import 'package:appwrite/appwrite.dart';
import 'package:auto_route/auto_route.dart';

import 'package:fishy/constants.dart';
import 'package:fishy/models/fishy_point_model.dart';

import 'package:fishy/providers/current_collection_id_provider.dart';
import 'package:fishy/providers/points_state_notifier_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

class TopControlWidget extends ConsumerStatefulWidget {
  const TopControlWidget({
    super.key,
    required this.point,
  });
  final LatLng point;

  @override
  ConsumerState<TopControlWidget> createState() => _TopControlWidgetState();
}

class _TopControlWidgetState extends ConsumerState<TopControlWidget> {
  late final String? collectionId;
  void onTap() async {
    collectionId = ref.read(collectionIdProvider);

    await createPoint(
      positionName: 'Озеро в лесу 3',
      positionDescription: 'Замечательное глубокое озеро 3',
      lat: 59.930670,
      lon: 30.360583,
    );
    if (mounted) {
      context.router.pop();
    }
  }

  Future<void> createPoint({
    required String positionName,
    String? positionDescription,
    required double lat,
    required double lon,
  }) async {
    PointModel pointModel = PointModel(
      positionName: positionName,
      positionDescription: positionDescription,
      lat: lat,
      lon: lon,
    );
    try {
      await ref
          .read(pointsProvider(collectionId!).notifier)
          .createPointDocument(
            pointModel,
          );
    } on AppwriteException catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                              '${widget.point.latitude.toStringAsFixed(6)},${widget.point.longitude.toStringAsFixed(6)}'))
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
                  '${widget.point.latitude.toStringAsFixed(6)},${widget.point.longitude.toStringAsFixed(6)}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                onTap();
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
    );
  }
}
