import 'package:fishy/api/providers/server_side_client_provider.dart';
import 'package:fishy/api/repositories/server_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final serverRepositoryProvider = Provider<ServerRepository>(
  (ref) => ServerRepository(
    ref.watch(dartClientProvider),
  ),
);
