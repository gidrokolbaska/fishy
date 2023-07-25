import 'package:dio/dio.dart';
import 'package:fishy/api/reverse_geo_rest_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>(
  (ref) => Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 40),
      receiveTimeout: const Duration(seconds: 40),
      sendTimeout: const Duration(seconds: 40),
    ),
  ),
);

final retrofitClientProvider = Provider<ReverseGeoRestClient>(
  (ref) => ReverseGeoRestClient(
    ref.watch(dioProvider),
  ),
);
