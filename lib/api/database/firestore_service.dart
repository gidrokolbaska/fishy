import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/providers/point_creation_providers.dart';
import 'package:fishy/main%20app%20module/features/map%20feature/widgets/point%20creation%20widgets/upload_dialog.dart';

import 'package:fishy/models/fishy_point_model.dart';
import 'package:fishy/reusable%20widgets/fishy_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:latlong2/latlong.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:path_provider/path_provider.dart';

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
    final double? depth = ref.read(depthProvider);
    final List<String> typeOfLocation =
        ref.read(typeOfLocationSelectedChoicesProvider).cast<String>();
    final List<String> typeOfDepth =
        ref.read(typeOfBottomSelectedChoicesProvider);
    final List<String> typeOfFishing =
        ref.read(typeOfFishingSelectedChoicesProvider);
    final Timestamp dateOfFishing =
        Timestamp.fromDate(ref.read(dateProvider) ?? DateTime.now());
    final int markerIconIndex = ref.read(markerIconProvider);
    final int markerColorIndex = ref.read(markerColorProvider);
    final Iterable<ImageFile>? selectedPhotos =
        ref.read(selectedPhotosListProvider);
    List<String>? photoURLs;
    if (name.isEmpty) {
      controller.forward();
      Vibrate.feedback(FeedbackType.warning);
      return;
    }

    final connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      if (selectedPhotos != null) {
        if (context.mounted) {
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => UploadDialog(
              function: () async {
                photoURLs = await uploadFiles(selectedPhotos, context);
              },
            ),
          );
        }
      }
    } else {
      if (context.mounted) {
        if (selectedPhotos != null) {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              icon: const Icon(Icons.file_upload_off),
              title: Text(
                'Отсутствует подключение к интернету',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              content: const Text(
                  'Фотографии не будут загружены, так как отсутствует подключение к интернету'),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('ОК'),
                  onPressed: () {
                    context.popRoute();
                  },
                ),
              ],
            ),
          );
        }
      }
    }
    PointModel pointModel = PointModel(
      positionName: name,
      positionDescription: description.isNotEmpty ? description : null,
      latitude: point.latitude,
      longitude: point.longitude,
      isDay: isDay,
      depth: depth,
      dateOfFishing: dateOfFishing,
      typeOfLocation: typeOfLocation,
      typeOfDepth: typeOfDepth,
      typeOfFishing: typeOfFishing,
      photoURLs: photoURLs,
      isFavorite: false,
      markerIcon: markerIconIndex,
      markerColor: markerColorIndex,
    );
    pointsRef.add(pointModel);
    if (context.mounted) {
      context.router.pop();
    }
  }

  Future<void> deletePhotos(List<dynamic> photos) async {
    for (var photo in photos) {
      final storageRef = FirebaseStorage.instance.refFromURL(photo);
      await storageRef.delete();
    }
  }

  Future<void> deletePoint(
      QueryDocumentSnapshot<PointModel> queryData, BuildContext context) async {
    final point = queryData.data();
    if (point.photoURLs != null && point.photoURLs!.isNotEmpty) {
      bool result = await InternetConnectionChecker().hasConnection;

      if (result) {
        if (context.mounted) {
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => UploadDialog(
              description: 'Идет удаление существующих фотографий',
              function: () async {
                await deletePhotos(point.photoURLs!);
                if (context.mounted) {
                  context.popRoute();
                }
              },
            ),
          );
        }

        if (context.mounted) {
          context.popRoute();
        }
        await queryData.reference.delete();
      } else {
        if (context.mounted) {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              icon: const Icon(
                FishyIcons.delete,
              ),
              title: Text(
                'Отсутствует подключение к интернету',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              content: const Text(
                'Текущая позиция содержит фотографии. Удаление такой позиции требует подключение к интернету. Повторите попытку позднее.',
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('ОК'),
                  onPressed: () {
                    context.popRoute();
                  },
                ),
              ],
            ),
          );
        }
      }
    } else {
      queryData.reference.delete();
      if (context.mounted) {
        context.popRoute();
      }
    }
  }

  Future<void> editPoint(DocumentSnapshot<PointModel>? data,
      AnimationController controller, BuildContext context) async {
    final String name = ref.read(positionNameProvider).text;
    final String description = ref.read(positionDescriptionProvider).text;
    final LatLng? coordinates = ref.read(fishyCoordinatesProvider);
    final bool isDay = ref.read(dayNightProvider);
    final double? depth = ref.read(depthProvider);
    final List<String> typeOfLocation =
        ref.read(typeOfLocationSelectedChoicesProvider).cast<String>();
    final List<String> typeOfDepth =
        ref.read(typeOfBottomSelectedChoicesProvider);
    final List<String> typeOfFishing =
        ref.read(typeOfFishingSelectedChoicesProvider);
    final Timestamp dateOfFishing =
        Timestamp.fromDate(ref.read(dateProvider) ?? DateTime.now());
    final int markerIconIndex = ref.read(markerIconProvider);
    final int markerColorIndex = ref.read(markerColorProvider);
    final Iterable<ImageFile>? selectedPhotos =
        ref.read(selectedPhotosListProvider);
    final List<String> deletedOnlinePoints =
        ref.read(removedPhotosStateProvider);
    final List<String>? remainingOnlinePhotos =
        ref.read(selectedOnlinePhotosListProvider);
    List<String>? photoURLs;
    if (name.isEmpty) {
      controller.forward();
      Vibrate.feedback(FeedbackType.warning);
      return;
    }

    final connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      if (selectedPhotos != null) {
        if (context.mounted) {
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => UploadDialog(
              function: () async {
                photoURLs = await uploadFiles(selectedPhotos, context);
              },
            ),
          );
        }
      }
      if (deletedOnlinePoints.isNotEmpty) {
        if (context.mounted) {
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => UploadDialog(
              description: 'Идет удаление существующих фотографий',
              function: () async {
                await deleteFiles(deletedOnlinePoints, context);
                ref.read(removedPhotosStateProvider.notifier).state = [];
              },
            ),
          );
        }
      }
    } else {
      if (context.mounted) {
        if (selectedPhotos != null || deletedOnlinePoints.isNotEmpty) {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              icon: const Icon(Icons.file_upload_off),
              title: Text(
                'Отсутствует подключение к интернету',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              content: const Text(
                  'Фотографии не будут загружены/удалены, так как отсутствует подключение к интернету'),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('ОК'),
                  onPressed: () {
                    context.popRoute();
                  },
                ),
              ],
            ),
          );
        }
      }
    }
    remainingOnlinePhotos?.addAll(photoURLs ?? []);
    PointModel currentPointModel = data!.data()!;
    PointModel pointModel = currentPointModel.copyWith(
      positionName: name,
      positionDescription: description.isNotEmpty ? description : null,
      latitude: coordinates?.latitude ?? currentPointModel.latitude,
      longitude: coordinates?.longitude ?? currentPointModel.longitude,
      isDay: isDay,
      depth: depth,
      dateOfFishing: dateOfFishing,
      typeOfLocation: typeOfLocation,
      typeOfDepth: typeOfDepth,
      typeOfFishing: typeOfFishing,
      photoURLs: remainingOnlinePhotos,
      isFavorite: false,
      markerIcon: markerIconIndex,
      markerColor: markerColorIndex,
    );

    data.reference.update(pointModel.toMap());
    if (context.mounted) {
      context.router.pop();
    }
  }

  Future<void> markAsFavorite(
      DocumentReference<PointModel> queryData, bool isFavorite) async {
    queryData.update(
      {"isFavorite": isFavorite},
    );
  }

  Future<List<String>> uploadFiles(
      Iterable<ImageFile>? images, BuildContext context) async {
    var imageUrls =
        await Future.wait(images!.map((image) => uploadFile(image)));

    if (context.mounted) {
      context.popRoute();
    }
    return imageUrls;
  }

  Future deleteFiles(List<String> filesToDelete, BuildContext context) async {
    await Future.wait(filesToDelete.map((file) => deleteFile(file)));
    if (context.mounted) {
      context.popRoute();
    }
  }

  Future deleteFile(String file) async {
    Reference ref = FirebaseStorage.instance.refFromURL(file);
    return await ref.delete();
  }

  Future<String> uploadFile(ImageFile image) async {
    var currentUser = FirebaseAuth.instance.currentUser!.uid;
    final dir = await getTemporaryDirectory();
    if (!await dir.exists()) {
      await dir.create();
    }
    String resultingTempPath =
        '${dir.absolute.path}/fishPhoto${image.hashCode}$currentUser' '.jpeg';
    var result = await FlutterImageCompress.compressAndGetFile(
      image.path!,
      resultingTempPath,
      quality: 70,
    );

    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('photos/$currentUser/${image.hashCode}');
    UploadTask uploadTask = storageReference.putFile(result!);
    await uploadTask.whenComplete(() => null);

    await result.delete();
    return await storageReference.getDownloadURL();
  }
}

final firestoreServiceProvider = Provider<FirestoreService>(
  (ref) => FirestoreService(ref: ref),
);
