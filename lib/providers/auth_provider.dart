import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/auth/authentication.dart';
import 'client_provider.dart';

final authProvider = Provider<Authentication>((ref) {
  return Authentication(ref.watch(clientProvider));
});

final userProvider = FutureProvider<Account?>(
    (ref) async => await ref.watch(authProvider).getAccount());
