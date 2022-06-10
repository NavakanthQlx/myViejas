import 'package:meta/meta.dart';
import 'dart:convert';

List<GamingDetailRoot> gamingDetailRootFromJson(String str) =>
    List<GamingDetailRoot>.from(
        json.decode(str).map((x) => GamingDetailRoot.fromJson(x)));

String gamingRootToJson(List<GamingDetailRoot> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GamingDetailRoot {
  GamingDetailRoot({
    required this.bannerImage,
    required this.features,
    required this.description,
    required this.headerTitle,
    required this.datavalues,
  });

  final String bannerImage;
  final String features;
  final String description;
  final String headerTitle;
  final List<GamingDetailDatavalue> datavalues;

  factory GamingDetailRoot.fromJson(Map<String, dynamic> json) =>
      GamingDetailRoot(
        bannerImage: json["banner_image"],
        features: json["features"],
        description: json["description"],
        headerTitle: json["header_title"],
        datavalues: List<GamingDetailDatavalue>.from(
            json["datavalues"].map((x) => GamingDetailDatavalue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "banner_image": bannerImage,
        "features": features,
        "description": description,
        "header_title": headerTitle,
        "datavalues": List<dynamic>.from(datavalues.map((x) => x.toJson())),
      };
}

class GamingDetailDatavalue {
  GamingDetailDatavalue({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  final String id;
  final String title;
  final String description;
  final String imageUrl;

  factory GamingDetailDatavalue.fromJson(Map<String, dynamic> json) =>
      GamingDetailDatavalue(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "image_url": imageUrl,
      };
}
