import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/authentication_repository.dart';

final authProvider = Provider.autoDispose<AuthenticationRepository>((ref) {
  return AuthenticationRepository();
});
