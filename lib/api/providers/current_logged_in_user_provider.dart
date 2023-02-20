import 'package:fishy/models/fishy_user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentLoggedInProvider = StateProvider<FishyUser?>((ref) => null);
