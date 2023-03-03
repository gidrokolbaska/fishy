// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PointModel {
  final String positionName;
  final String? positionDescription;
  final double latitude;
  final double longitude;
  final DateTime? dateOfFishing;
  final bool isDay;
  final double? depth;
  PointModel({
    required this.positionName,
    this.positionDescription,
    required this.latitude,
    required this.longitude,
    this.dateOfFishing,
    this.isDay = true,
    this.depth,
  });

  PointModel copyWith({
    String? positionName,
    String? positionDescription,
    double? latitude,
    double? longitude,
    DateTime? dateOfFishing,
    bool? isDay,
    double? depth,
  }) {
    return PointModel(
      positionName: positionName ?? this.positionName,
      positionDescription: positionDescription ?? this.positionDescription,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      dateOfFishing: dateOfFishing ?? this.dateOfFishing,
      isDay: isDay ?? this.isDay,
      depth: depth ?? this.depth,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'positionName': positionName,
      'positionDescription': positionDescription,
      'latitude': latitude,
      'longitude': longitude,
      'dateOfFishing': dateOfFishing?.millisecondsSinceEpoch,
      'isDay': isDay,
      'depth': depth,
    };
  }

  factory PointModel.fromMap(Map<String, dynamic> map) {
    return PointModel(
      positionName: map['positionName'] as String,
      positionDescription: map['positionDescription'] != null
          ? map['positionDescription'] as String
          : null,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      dateOfFishing: map['dateOfFishing'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dateOfFishing'] as int)
          : null,
      isDay: map['isDay'] as bool,
      depth: map['depth'] != null ? map['depth'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PointModel.fromJson(String source) =>
      PointModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PointModel(positionName: $positionName, positionDescription: $positionDescription, latitude: $latitude, longitude: $longitude, dateOfFishing: $dateOfFishing, isDay: $isDay, depth: $depth)';
  }

  @override
  bool operator ==(covariant PointModel other) {
    if (identical(this, other)) return true;

    return other.positionName == positionName &&
        other.positionDescription == positionDescription &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.dateOfFishing == dateOfFishing &&
        other.isDay == isDay &&
        other.depth == depth;
  }

  @override
  int get hashCode {
    return positionName.hashCode ^
        positionDescription.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        dateOfFishing.hashCode ^
        isDay.hashCode ^
        depth.hashCode;
  }
}

final pointsRef = FirebaseFirestore.instance
    .collection('users')
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .collection('points')
    .withConverter(
      fromFirestore: (snapshot, _) => PointModel.fromMap(snapshot.data()!),
      toFirestore: (point, options) => point.toMap(),
    );
