import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/database/user_data.dart';
import 'client_provider.dart';

/// Provider for the [UserData] class.
/// This provider is used to access all the [UserData] methods.
///
///
final userDataClassProvider = Provider<UserData>((ref) {
  return UserData(ref.watch(clientProvider));
});
