import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
}

final depthProvider = NotifierProvider.autoDispose<FishyDepth, double?>(() {
  return FishyDepth();
});

class FishyDate extends AutoDisposeNotifier<DateTime?> {
  @override
  DateTime? build() {
    return null;
  }
}

final dateProvider = NotifierProvider.autoDispose<FishyDate, DateTime?>(() {
  return FishyDate();
});

final dayNightProvider = StateProvider.autoDispose<bool>((ref) {
  return true;
});
