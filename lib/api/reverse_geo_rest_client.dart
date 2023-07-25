import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'reverse_geo_rest_client.g.dart';

@RestApi(baseUrl: "http://api.openweathermap.org/geo/1.0/")
abstract class ReverseGeoRestClient {
  factory ReverseGeoRestClient(Dio dio, {String baseUrl}) =
      _ReverseGeoRestClient;

  @GET("/reverse")
  Future<List<LocationDataResponse>> getLocationName(
    @Query("lat") double lat,
    @Query("lon") double lon,
    @Query("appid") String apiKey,
    @Query("limit") int limit,
  );
}

@JsonSerializable()
class LocationDataResponse {
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "local_names")
  LocalNames? localNames;

  LocationDataResponse({
    this.name,
    this.localNames,
  });

  factory LocationDataResponse.fromJson(Map<String, dynamic> json) =>
      _$LocationDataResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LocationDataResponseToJson(this);
}

@JsonSerializable()
class LocalNames {
  LocalNames({
    this.ar,
    this.bg,
    this.ca,
    this.de,
    this.el,
    this.en,
    this.fa,
    this.fi,
    this.fr,
    this.gl,
    this.he,
    this.hi,
    this.id,
    this.it,
    this.ja,
    this.la,
    this.lt,
    this.pt,
    this.ru,
    this.sr,
    this.th,
    this.tr,
    this.vi,
    this.zu,
    this.af,
    this.az,
    this.da,
    this.eu,
    this.hr,
    this.hu,
    this.mk,
    this.nl,
    this.no,
    this.pl,
    this.ro,
    this.sk,
    this.sl,
  });
  @JsonKey(name: "ar")
  String? ar;
  @JsonKey(name: "ascii")
  String? ascii;
  @JsonKey(name: "bg")
  String? bg;
  @JsonKey(name: "ca")
  String? ca;
  @JsonKey(name: "de")
  String? de;
  @JsonKey(name: "el")
  String? el;
  @JsonKey(name: "en")
  String? en;
  @JsonKey(name: "fa")
  String? fa;
  @JsonKey(name: "featureName")
  String? featureName;
  @JsonKey(name: "fi")
  String? fi;
  @JsonKey(name: "fr")
  String? fr;
  @JsonKey(name: "gl")
  String? gl;
  @JsonKey(name: "he")
  String? he;
  @JsonKey(name: "hi")
  String? hi;
  @JsonKey(name: "id")
  String? id;
  @JsonKey(name: "it")
  String? it;
  @JsonKey(name: "ja")
  String? ja;
  @JsonKey(name: "la")
  String? la;
  @JsonKey(name: "lt")
  String? lt;
  @JsonKey(name: "pt")
  String? pt;
  @JsonKey(name: "ru")
  String? ru;
  @JsonKey(name: "sr")
  String? sr;
  @JsonKey(name: "th")
  String? th;
  @JsonKey(name: "tr")
  String? tr;
  @JsonKey(name: "vi")
  String? vi;
  @JsonKey(name: "zu")
  String? zu;
  @JsonKey(name: "af")
  String? af;
  @JsonKey(name: "az")
  String? az;
  @JsonKey(name: "da")
  String? da;
  @JsonKey(name: "eu")
  String? eu;
  @JsonKey(name: "hr")
  String? hr;
  @JsonKey(name: "hu")
  String? hu;
  @JsonKey(name: "mk")
  String? mk;
  @JsonKey(name: "nl")
  String? nl;
  @JsonKey(name: "no")
  String? no;
  @JsonKey(name: "pl")
  String? pl;
  @JsonKey(name: "ro")
  String? ro;
  @JsonKey(name: "sk")
  String? sk;
  @JsonKey(name: "sl")
  String? sl;
  factory LocalNames.fromJson(Map<String, dynamic> json) =>
      _$LocalNamesFromJson(json);
  Map<String, dynamic> toJson() => _$LocalNamesToJson(this);
}
