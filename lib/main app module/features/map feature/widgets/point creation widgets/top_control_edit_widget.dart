import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fishy/api/database/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fishy/constants.dart';
import 'package:fishy/models/fishy_point_model.dart';

class TopControlEditWidget extends ConsumerStatefulWidget {
  const TopControlEditWidget({
    super.key,
    required this.controller,
    required this.point,
    required this.data,
  });

  final AnimationController controller;
  final PointModel point;
  final DocumentSnapshot<PointModel>? data;
  @override
  ConsumerState<TopControlEditWidget> createState() => _TopControlWidgetState();
}

class _TopControlWidgetState extends ConsumerState<TopControlEditWidget> {
  late final String? collectionId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            ElevatedButton(
              onPressed: () async {
                ref
                    .read(firestoreServiceProvider)
                    .editPoint(widget.data, widget.controller, context);
                // ref
                //     .read(firestoreServiceProvider)
                //     .createPoint(widget.point, widget.controller, context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: grayscaleInput,
                //maximumSize: const Size.fromWidth(85),

                minimumSize: const Size.fromWidth(85),
              ),
              child: const Text(
                'Обновить',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
