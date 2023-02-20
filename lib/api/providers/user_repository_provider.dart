import 'package:fishy/api/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'client_provider.dart';

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(
    ref.watch(clientProvider),
  ),
);
