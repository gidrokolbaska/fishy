import 'package:fishy/api/providers/map_repository_provider.dart';
import 'package:fishy/api/providers/server_repository_provider.dart';
import 'package:fishy/api/providers/user_repository_provider.dart';
import 'package:fishy/api/repositories/map_repository.dart';
import 'package:fishy/api/repositories/server_repository.dart';
import 'package:fishy/api/repositories/user_repository.dart';
import 'package:fishy/providers/current_collection_id_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MapScreenController extends StateNotifier<AsyncValue<void>> {
  MapScreenController({
    required this.ref,
    required this.mapRepository,
    required this.serverRepository,
    required this.userRepository,
  }) : super(
          const AsyncData<void>(null),
        ) {
    fetchAndCreateAllRequiredData();
  }
  final MapRepository mapRepository;
  final ServerRepository serverRepository;
  final UserRepository userRepository;
  final Ref ref;
  void fetchAndCreateAllRequiredData() async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard(() async {
      await mapRepository.fetchPosition();

      final user = await userRepository.getCurrentUser();

      String? collectionId =
          await serverRepository.createPointsCollection(user!.id);
      ref.read(collectionIdProvider.notifier).update(((state) => collectionId));
    });
  }
}

final mapScreenControllerProvider =
    StateNotifierProvider<MapScreenController, AsyncValue<void>>(
  (ref) => MapScreenController(
    ref: ref,
    mapRepository: ref.watch(mapRepositoryProvider),
    serverRepository: ref.watch(serverRepositoryProvider),
    userRepository: ref.watch(userRepositoryProvider),
  ),
);
