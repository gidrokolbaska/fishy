import 'package:appwrite/models.dart';
import 'package:fishy/api/auth/authentication.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'client_provider.dart';

final authProvider = Provider.autoDispose<Authentication>((ref) {
  return Authentication(ref.watch(clientProvider));
});

final userProvider = FutureProvider.autoDispose<Account?>(
    (ref) async => await ref.watch(authProvider).getAccount());
