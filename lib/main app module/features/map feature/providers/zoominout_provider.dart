import 'package:flutter_riverpod/flutter_riverpod.dart';

final zoomInStateProvider = StateProvider.autoDispose<bool>((ref) => false);
final zoomOutStateProvider = StateProvider.autoDispose<bool>((ref) => false);
