// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reverse_geocoding_repo.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reverseGeocodingRepositoryGetLocationHash() =>
    r'd843875dd9c58016b0d62681395513c9c773a42b';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

typedef ReverseGeocodingRepositoryGetLocationRef
    = AutoDisposeFutureProviderRef<List<LocationDataResponse>>;

/// See also [reverseGeocodingRepositoryGetLocation].
@ProviderFor(reverseGeocodingRepositoryGetLocation)
const reverseGeocodingRepositoryGetLocationProvider =
    ReverseGeocodingRepositoryGetLocationFamily();

/// See also [reverseGeocodingRepositoryGetLocation].
class ReverseGeocodingRepositoryGetLocationFamily
    extends Family<AsyncValue<List<LocationDataResponse>>> {
  /// See also [reverseGeocodingRepositoryGetLocation].
  const ReverseGeocodingRepositoryGetLocationFamily();

  /// See also [reverseGeocodingRepositoryGetLocation].
  ReverseGeocodingRepositoryGetLocationProvider call({
    required double lon,
    required double lat,
    required int limit,
  }) {
    return ReverseGeocodingRepositoryGetLocationProvider(
      lon: lon,
      lat: lat,
      limit: limit,
    );
  }

  @override
  ReverseGeocodingRepositoryGetLocationProvider getProviderOverride(
    covariant ReverseGeocodingRepositoryGetLocationProvider provider,
  ) {
    return call(
      lon: provider.lon,
      lat: provider.lat,
      limit: provider.limit,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'reverseGeocodingRepositoryGetLocationProvider';
}

/// See also [reverseGeocodingRepositoryGetLocation].
class ReverseGeocodingRepositoryGetLocationProvider
    extends AutoDisposeFutureProvider<List<LocationDataResponse>> {
  /// See also [reverseGeocodingRepositoryGetLocation].
  ReverseGeocodingRepositoryGetLocationProvider({
    required this.lon,
    required this.lat,
    required this.limit,
  }) : super.internal(
          (ref) => reverseGeocodingRepositoryGetLocation(
            ref,
            lon: lon,
            lat: lat,
            limit: limit,
          ),
          from: reverseGeocodingRepositoryGetLocationProvider,
          name: r'reverseGeocodingRepositoryGetLocationProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$reverseGeocodingRepositoryGetLocationHash,
          dependencies:
              ReverseGeocodingRepositoryGetLocationFamily._dependencies,
          allTransitiveDependencies: ReverseGeocodingRepositoryGetLocationFamily
              ._allTransitiveDependencies,
        );

  final double lon;
  final double lat;
  final int limit;

  @override
  bool operator ==(Object other) {
    return other is ReverseGeocodingRepositoryGetLocationProvider &&
        other.lon == lon &&
        other.lat == lat &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, lon.hashCode);
    hash = _SystemHash.combine(hash, lat.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
