import 'package:meta/meta.dart';
import 'dart:convert';

List<DiningObject> diningObjectFromJson(String str) => List<DiningObject>.from(
    json.decode(str).map((x) => DiningObject.fromJson(x)));

String diningObjectToJson(List<DiningObject> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DiningObject {
  DiningObject({
    required this.bannerImage,
    required this.mainHeader,
    required this.venueData,
  });

  final String bannerImage;
  final String mainHeader;
  final List<VenueDatum> venueData;

  factory DiningObject.fromJson(Map<String, dynamic> json) => DiningObject(
        bannerImage: json["banner_image"],
        mainHeader: json["main_header"],
        venueData: List<VenueDatum>.from(
            json["venue_data"].map((x) => VenueDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "banner_image": bannerImage,
        "main_header": mainHeader,
        "venue_data": List<dynamic>.from(venueData.map((x) => x.toJson())),
      };
}

class VenueDatum {
  VenueDatum({
    required this.venueId,
    required this.venueTitle,
    required this.venueShortDescription,
    required this.venueImage,
  });

  final String venueId;
  final String venueTitle;
  final String venueShortDescription;
  final String venueImage;

  factory VenueDatum.fromJson(Map<String, dynamic> json) => VenueDatum(
        venueId: json["venue_id"],
        venueTitle: json["venue_title"],
        venueShortDescription: json["venue_short_description"],
        venueImage: json["venue_image"],
      );

  Map<String, dynamic> toJson() => {
        "venue_id": venueId,
        "venue_title": venueTitle,
        "venue_short_description": venueShortDescription,
        "venue_image": venueImage,
      };
}
