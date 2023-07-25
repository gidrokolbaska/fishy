// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reverse_geo_rest_client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationDataResponse _$LocationDataResponseFromJson(
        Map<String, dynamic> json) =>
    LocationDataResponse(
      name: json['name'] as String?,
      localNames: json['local_names'] == null
          ? null
          : LocalNames.fromJson(json['local_names'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LocationDataResponseToJson(
        LocationDataResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'local_names': instance.localNames,
    };

LocalNames _$LocalNamesFromJson(Map<String, dynamic> json) => LocalNames(
      ar: json['ar'] as String?,
      bg: json['bg'] as String?,
      ca: json['ca'] as String?,
      de: json['de'] as String?,
      el: json['el'] as String?,
      en: json['en'] as String?,
      fa: json['fa'] as String?,
      fi: json['fi'] as String?,
      fr: json['fr'] as String?,
      gl: json['gl'] as String?,
      he: json['he'] as String?,
      hi: json['hi'] as String?,
      id: json['id'] as String?,
      it: json['it'] as String?,
      ja: json['ja'] as String?,
      la: json['la'] as String?,
      lt: json['lt'] as String?,
      pt: json['pt'] as String?,
      ru: json['ru'] as String?,
      sr: json['sr'] as String?,
      th: json['th'] as String?,
      tr: json['tr'] as String?,
      vi: json['vi'] as String?,
      zu: json['zu'] as String?,
      af: json['af'] as String?,
      az: json['az'] as String?,
      da: json['da'] as String?,
      eu: json['eu'] as String?,
      hr: json['hr'] as String?,
      hu: json['hu'] as String?,
      mk: json['mk'] as String?,
      nl: json['nl'] as String?,
      no: json['no'] as String?,
      pl: json['pl'] as String?,
      ro: json['ro'] as String?,
      sk: json['sk'] as String?,
      sl: json['sl'] as String?,
    )
      ..ascii = json['ascii'] as String?
      ..featureName = json['featureName'] as String?;

Map<String, dynamic> _$LocalNamesToJson(LocalNames instance) =>
    <String, dynamic>{
      'ar': instance.ar,
      'ascii': instance.ascii,
      'bg': instance.bg,
      'ca': instance.ca,
      'de': instance.de,
      'el': instance.el,
      'en': instance.en,
      'fa': instance.fa,
      'featureName': instance.featureName,
      'fi': instance.fi,
      'fr': instance.fr,
      'gl': instance.gl,
      'he': instance.he,
      'hi': instance.hi,
      'id': instance.id,
      'it': instance.it,
      'ja': instance.ja,
      'la': instance.la,
      'lt': instance.lt,
      'pt': instance.pt,
      'ru': instance.ru,
      'sr': instance.sr,
      'th': instance.th,
      'tr': instance.tr,
      'vi': instance.vi,
      'zu': instance.zu,
      'af': instance.af,
      'az': instance.az,
      'da': instance.da,
      'eu': instance.eu,
      'hr': instance.hr,
      'hu': instance.hu,
      'mk': instance.mk,
      'nl': instance.nl,
      'no': instance.no,
      'pl': instance.pl,
      'ro': instance.ro,
      'sk': instance.sk,
      'sl': instance.sl,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _ReverseGeoRestClient implements ReverseGeoRestClient {
  _ReverseGeoRestClient(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'http://api.openweathermap.org/geo/1.0/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<List<LocationDataResponse>> getLocationName(
    double lat,
    double lon,
    String apiKey,
    int limit,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'lat': lat,
      r'lon': lon,
      r'appid': apiKey,
      r'limit': limit,
    };
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<LocationDataResponse>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/reverse',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) =>
            LocationDataResponse.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
