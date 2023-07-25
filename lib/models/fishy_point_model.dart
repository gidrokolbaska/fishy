// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class PointModel {
  final String positionName;
  final String? positionDescription;
  final double latitude;
  final double longitude;
  final Timestamp dateOfFishing;
  final bool isDay;
  final double? depth;
  final List<dynamic> typeOfLocation;
  final List<dynamic> typeOfDepth;
  final List<dynamic> typeOfFishing;
  final List<dynamic>? photoURLs;
  final bool isFavorite;
  final int markerIcon;
  final int markerColor;

  PointModel({
    required this.positionName,
    this.positionDescription,
    required this.latitude,
    required this.longitude,
    required this.dateOfFishing,
    required this.isDay,
    this.depth,
    required this.typeOfLocation,
    required this.typeOfDepth,
    required this.typeOfFishing,
    required this.photoURLs,
    required this.isFavorite,
    required this.markerIcon,
    required this.markerColor,
  });

  PointModel copyWith({
    String? positionName,
    String? positionDescription,
    double? latitude,
    double? longitude,
    Timestamp? dateOfFishing,
    bool? isDay,
    double? depth,
    List<dynamic>? typeOfLocation,
    List<dynamic>? typeOfDepth,
    List<dynamic>? typeOfFishing,
    List<dynamic>? photoURLs,
    bool? isFavorite,
    int? markerIcon,
    int? markerColor,
  }) {
    return PointModel(
      positionName: positionName ?? this.positionName,
      positionDescription: positionDescription ?? this.positionDescription,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      dateOfFishing: dateOfFishing ?? this.dateOfFishing,
      isDay: isDay ?? this.isDay,
      depth: depth ?? this.depth,
      typeOfLocation: typeOfLocation ?? this.typeOfLocation,
      typeOfDepth: typeOfDepth ?? this.typeOfDepth,
      typeOfFishing: typeOfFishing ?? this.typeOfFishing,
      photoURLs: photoURLs ?? this.photoURLs,
      isFavorite: isFavorite ?? this.isFavorite,
      markerIcon: markerIcon ?? this.markerIcon,
      markerColor: markerColor ?? this.markerColor,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'positionName': positionName,
      'positionDescription': positionDescription,
      'latitude': latitude,
      'longitude': longitude,
      'dateOfFishing': dateOfFishing,
      'isDay': isDay,
      'depth': depth,
      'typeOfLocation': typeOfLocation,
      'typeOfDepth': typeOfDepth,
      'typeOfFishing': typeOfFishing,
      'photoURLs': photoURLs,
      'isFavorite': isFavorite,
      'markerIcon': markerIcon,
      'markerColor': markerColor,
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
      dateOfFishing: map['dateOfFishing'] as Timestamp,
      isDay: map['isDay'] as bool,
      depth: map['depth'] != null ? map['depth'] as double : null,
      typeOfLocation: map['typeOfLocation'] as List<dynamic>,
      typeOfDepth: map['typeOfDepth'] as List<dynamic>,
      typeOfFishing: map['typeOfFishing'] as List<dynamic>,
      photoURLs:
          map['photoURLs'] != null ? map['photoURLs'] as List<dynamic> : null,
      isFavorite: map['isFavorite'] as bool,
      markerIcon: map['markerIcon'] as int,
      markerColor: map['markerColor'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PointModel.fromJson(String source) =>
      PointModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PointModel(positionName: $positionName, positionDescription: $positionDescription, latitude: $latitude, longitude: $longitude, dateOfFishing: $dateOfFishing, isDay: $isDay, depth: $depth, typeOfLocation: $typeOfLocation, typeOfDepth: $typeOfDepth, typeOfFishing: $typeOfFishing)';
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
        other.depth == depth &&
        other.hashCode == hashCode &&
        other.isFavorite == isFavorite &&
        other.markerIcon == markerIcon &&
        other.markerColor == markerColor &&
        listEquals(other.typeOfLocation, typeOfLocation) &&
        listEquals(other.typeOfDepth, typeOfDepth) &&
        listEquals(other.typeOfFishing, typeOfFishing) &&
        listEquals(other.photoURLs, photoURLs);
  }

  @override
  int get hashCode {
    return positionName.hashCode ^
        positionDescription.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        dateOfFishing.hashCode ^
        isDay.hashCode ^
        depth.hashCode ^
        typeOfLocation.hashCode ^
        typeOfDepth.hashCode ^
        photoURLs.hashCode ^
        isFavorite.hashCode ^
        markerIcon.hashCode ^
        markerColor.hashCode ^
        typeOfFishing.hashCode;
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
