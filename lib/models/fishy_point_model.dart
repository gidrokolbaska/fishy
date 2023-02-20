// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PointModel {
  final String positionName;
  final String? positionDescription;
  final double lat;
  final double lon;
  PointModel({
    required this.positionName,
    this.positionDescription,
    required this.lat,
    required this.lon,
  });

  PointModel copyWith({
    String? positionName,
    String? positionDescription,
    double? lat,
    double? lon,
  }) {
    return PointModel(
      positionName: positionName ?? this.positionName,
      positionDescription: positionDescription ?? this.positionDescription,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'positionName': positionName,
      'positionDescription': positionDescription,
      'lat': lat,
      'lon': lon,
    };
  }

  factory PointModel.fromMap(Map<String, dynamic> map) {
    return PointModel(
      positionName: map['positionName'] as String,
      positionDescription: map['positionDescription'] != null
          ? map['positionDescription'] as String
          : null,
      lat: map['lat'] as double,
      lon: map['lon'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory PointModel.fromJson(String source) =>
      PointModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PointModel(positionName: $positionName, positionDescription: $positionDescription, lat: $lat, lon: $lon)';
  }

  @override
  bool operator ==(covariant PointModel other) {
    if (identical(this, other)) return true;

    return other.positionName == positionName &&
        other.positionDescription == positionDescription &&
        other.lat == lat &&
        other.lon == lon;
  }

  @override
  int get hashCode {
    return positionName.hashCode ^
        positionDescription.hashCode ^
        lat.hashCode ^
        lon.hashCode;
  }
}
