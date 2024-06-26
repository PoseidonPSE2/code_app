import 'package:flutter/cupertino.dart';
import 'package:refill/restApi/waterEnums.dart';

class RefillStation {
  final int id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final String address;
  final int? likeCounter;
  final String waterSource;
  final String openingTimes;
  final bool active;
  final WaterStationType type;
  final OfferedWatertype offeredWatertype;

  RefillStation({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.likeCounter,
    required this.waterSource,
    required this.openingTimes,
    required this.active,
    required this.type,
    required this.offeredWatertype,
  }) : super();

  factory RefillStation.fromJson(Map<String, dynamic> json) {
    return RefillStation(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      address: json['address'] as String,
      likeCounter: json['likes'] != null ? json['Likes'] as int : 0,
      waterSource: json['water_source'] as String,
      openingTimes: json['opening_times'] as String,
      active: (json['active'] as Map<String, dynamic>)['valid'] as bool,
      type: getWaterStationType(json['type'] as String),
      offeredWatertype:
          getOfferedWatertype(json['offered_water_types'] as String),
    );
  }

  static final Widget markerChild = Image.asset('assets/image/frontpage.png');

  Widget get child => markerChild;
}

class RefillStationMarker {
  final int id;
  final double longitude;
  final double latitude;
  final bool status;

  RefillStationMarker({
    required this.id,
    required this.longitude,
    required this.latitude,
    required this.status,
  }) : super();

  factory RefillStationMarker.fromJson(Map<String, dynamic> json) {
    return RefillStationMarker(
      id: json['id'] as int,
      longitude: json['longitude'] as double,
      latitude: json['latitude'] as double,
      status: (json['status'] as Map<String, dynamic>)['valid'] as bool,
    );
  }

  static final Widget markerChild = Image.asset('assets/image/frontpage.png');

  Widget get child => markerChild;
}

class RefillstationReviewAverage {
  final double accesibility;
  final double cleanness;
  final double waterQuality;

  RefillstationReviewAverage({
    required this.accesibility,
    required this.cleanness,
    required this.waterQuality,
  });

  factory RefillstationReviewAverage.fromJson(Map<dynamic, dynamic> json) {
    return RefillstationReviewAverage(
      accesibility: (json['accesibility'] as num).toDouble(),
      cleanness: (json['cleanness'] as num).toDouble(),
      waterQuality: (json['waterQuality'] as num).toDouble(),
    );
  }
}

class RefillstationReview {
  final int cleanness;
  final int accessibility;
  final int water_quality;
  final int? user_id;
  final int? station_id;

  RefillstationReview({
    required this.cleanness,
    required this.accessibility,
    required this.water_quality,
    this.station_id,
    this.user_id,
  });

  factory RefillstationReview.fromJson(Map<String, dynamic> json) {
    return RefillstationReview(
      cleanness: json['cleanness'] as int,
      accessibility: json['accessibility'] as int,
      water_quality: json['water_quality'] as int,
      user_id: json['user_id'] != null ? json['user_id'] as int : null,
      station_id: json['station_id'] != null ? json['station_id'] as int : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'station_id': station_id,
        'user_id': user_id,
        'cleanness': cleanness,
        'accessibility': accessibility, // Convert enum to string
        'water_quality': water_quality,
      };
}

class RefillstationProblem {
  final int station_id;
  final String title;
  final String description;

  //final List<int>? mediaLink;
  final String status;

  RefillstationProblem({
    required this.station_id,
    required this.title,
    required this.description,
    required this.status,
    //this.mediaLink,
  });

  factory RefillstationProblem.fromJson(Map<String, dynamic> json) {
    return RefillstationProblem(
      station_id: json['refillstationId'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      //mediaLink: json['mediaLink'] as List<int>,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'station_id': station_id,
        'title': title,
        'description': description,
        'status': status, // Convert enum to string
        //'mediaLink': mediaLink,
      };
}

class RefillStationImage {
  final String? image;

  RefillStationImage({
    required this.image,
  }) : super();

  factory RefillStationImage.fromJson(Map<String, dynamic> json) {
    return RefillStationImage(
      image: json['station_image'] as String,
    );
  }
}