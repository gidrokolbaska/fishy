import 'package:auto_route/auto_route.dart';
import 'package:fishy/api/database/firestore_service.dart';
import 'package:fishy/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

class TopControlWidget extends ConsumerStatefulWidget {
  const TopControlWidget({
    super.key,
    required this.controller,
    required this.point,
  });
  final LatLng point;
  final AnimationController controller;
  @override
  ConsumerState<TopControlWidget> createState() => _TopControlWidgetState();
}

class _TopControlWidgetState extends ConsumerState<TopControlWidget> {
  late final String? collectionId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: ElevatedButton(
                onPressed: () async {
                  Clipboard.setData(ClipboardData(
                          text:
                              '${widget.point.latitude.toStringAsFixed(6)},${widget.point.longitude.toStringAsFixed(6)}'))
                      .then(
                    (_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text("Координаты скопированы"),
                        ),
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: grayscaleInput,
                  foregroundColor: Colors.black,
                ),
                child: FittedBox(
                  child: Text(
                    '${widget.point.latitude.toStringAsFixed(6)},${widget.point.longitude.toStringAsFixed(6)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                ref
                    .read(firestoreServiceProvider)
                    .createPoint(widget.point, widget.controller, context);
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
