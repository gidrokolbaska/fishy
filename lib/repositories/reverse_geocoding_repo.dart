import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fishy/api/providers/dio_provider.dart';
import 'package:fishy/api/reverse_geo_rest_client.dart';
part 'reverse_geocoding_repo.g.dart';

class ReverseGeocodingRepository {
  final ReverseGeoRestClient client;
  final String apiKey;
  ReverseGeocodingRepository({
    required this.client,
    required this.apiKey,
  });

  Future<List<LocationDataResponse>> getLocationData(
      double lat, double lon, int limit) async {
    try {
      final locationResponse =
          await client.getLocationName(lat, lon, apiKey, limit);
      return locationResponse;
    } on DioError catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}

final reverseGeocodingRepositoryProvider = Provider<ReverseGeocodingRepository>(
  (ref) => ReverseGeocodingRepository(
    client: ref.watch(retrofitClientProvider),
    apiKey: 'bb08dbd0ffad123efc0acfc50c8a7e54',
  ),
);

@riverpod
Future<List<LocationDataResponse>> reverseGeocodingRepositoryGetLocation(
  ReverseGeocodingRepositoryGetLocationRef ref, {
  required double lon,
  required double lat,
  required int limit,
}) {
  return ref
      .watch(reverseGeocodingRepositoryProvider)
      .getLocationData(lat, lon, limit);
}
