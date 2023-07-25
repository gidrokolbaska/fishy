import 'package:fishy/constants.dart';
import 'package:fishy/reusable%20widgets/fishy_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:latlong2/latlong.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'point_creation_providers.g.dart';

const List<IconData> iconOptions = [
  FishyIcons.fish,
  FishyIcons.no_fish,
  FishyIcons.tree,
];
const List<Color> colorOptions = [
  primaryColor,
  red500,
  secondaryDefault,
  orange500,
];
final positionNameProvider = Provider.autoDispose<TextEditingController>((ref) {
  return TextEditingController();
});
final positionDescriptionProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  return TextEditingController();
});

class FishyDepth extends AutoDisposeNotifier<double?> {
  @override
  double? build() {
    return null;
  }

  update(double? depth) {
    state = depth;
  }
}

final depthProvider = NotifierProvider.autoDispose<FishyDepth, double?>(() {
  return FishyDepth();
});

class FishyDate extends AutoDisposeNotifier<DateTime?> {
  @override
  DateTime? build() {
    return null;
  }

  update(DateTime dateTime) {
    state = dateTime;
  }
}

@riverpod
class FishyCoordinates extends _$FishyCoordinates {
  @override
  LatLng? build() {
    return null;
  }

  void update(LatLng coordinates) {
    state = coordinates;
  }
}
// class FishyCoordinates
//     extends AutoDisposeFamilyNotifier<FishyCoordinates, LatLng> {
//   @override
//   LatLng build() {
//     return
//   }

//   update(DateTime dateTime) {
//     state = dateTime;
//   }
// }

// final positionCoordinatesProvider =
//     NotifierProvider.autoDispose.family<FishyCoordinates, LatLng>((latLng) {
//   return FishyCoordinates();
// });
final dateProvider = NotifierProvider.autoDispose<FishyDate, DateTime?>(() {
  return FishyDate();
});

final dayNightProvider = StateProvider.autoDispose<bool>((ref) {
  return true;
});
final markerIconProvider = StateProvider.autoDispose<int>((ref) => 0);
final markerColorProvider = StateProvider.autoDispose<int>((ref) => 0);
final typeOfFishingChoicesProvider = Provider<List<String>>(
  (ref) {
    return [
      'Поплавок',
      'Фидер',
      'Зимняя удочка с мормышкой',
      'Зимняя удочка с балансиром',
      'Спиннинг',
      'Сеть',
      'Донка',
      'Жерлица',
    ];
  },
);
final typeOfLocationChoicesProvider = Provider<List<String>>(
  (ref) {
    return [
      'Пирс/Причал',
      'Пристань',
      'Мост',
      'На открытой воде',
      'Пляж',
      'Берег'
    ];
  },
);
final typeOfBottomChoicesProvider = Provider<List<String>>(
  (ref) {
    return [
      'Галька',
      'Надводная растительность',
      'Трава',
      'Твердое дно',
      'Илистое дно',
      'Камни',
      'Бревна/Коряги',
      'Песок'
    ];
  },
);
final removedPhotosStateProvider = StateProvider<List<String>>((ref) => []);

class FishyTypeOfBottomSelectedChoices
    extends AutoDisposeNotifier<List<String>> {
  @override
  List<String> build() {
    return [];
  }

  update(List<String> typeOfBottom) {
    state = typeOfBottom;
  }
}

final typeOfBottomSelectedChoicesProvider = NotifierProvider.autoDispose<
    FishyTypeOfBottomSelectedChoices, List<String>>(() {
  return FishyTypeOfBottomSelectedChoices();
});

class FishyTypeOfLocationSelectedChoices
    extends AutoDisposeNotifier<List<dynamic>> {
  @override
  List<dynamic> build() {
    return [];
  }

  void update(List<dynamic> tags) {
    state = tags;
  }
}

class FishyPhotosListNotifier
    extends AutoDisposeNotifier<Iterable<ImageFile>?> {
  @override
  Iterable<ImageFile>? build() {
    return null;
  }

  void update(Iterable<ImageFile>? imageList) {
    state = imageList;
  }
}

final selectedPhotosListProvider =
    NotifierProvider.autoDispose<FishyPhotosListNotifier, Iterable<ImageFile>?>(
        () {
  return FishyPhotosListNotifier();
});

class FishyOnlinePhotosListNotifier extends AutoDisposeNotifier<List<String>?> {
  @override
  List<String>? build() {
    return null;
  }

  void update(List<String>? imageList) {
    state = imageList;
  }
}

final selectedOnlinePhotosListProvider =
    NotifierProvider.autoDispose<FishyOnlinePhotosListNotifier, List<String>?>(
        () {
  return FishyOnlinePhotosListNotifier();
});

final typeOfLocationSelectedChoicesProvider = NotifierProvider.autoDispose<
    FishyTypeOfLocationSelectedChoices, List<dynamic>>(() {
  return FishyTypeOfLocationSelectedChoices();
});

class FishyTypeOfFishingSelectedChoices
    extends AutoDisposeNotifier<List<String>> {
  @override
  List<String> build() {
    return [];
  }

  void update(List<String> tags) {
    state = tags;
  }
}

final typeOfFishingSelectedChoicesProvider = NotifierProvider.autoDispose<
    FishyTypeOfFishingSelectedChoices, List<String>>(() {
  return FishyTypeOfFishingSelectedChoices();
});
