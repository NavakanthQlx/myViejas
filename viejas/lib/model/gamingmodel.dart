import 'package:meta/meta.dart';
import 'dart:convert';

List<GamingRoot> gamingRootFromJson(String str) =>
    List<GamingRoot>.from(json.decode(str).map((x) => GamingRoot.fromJson(x)));

String gamingRootToJson(List<GamingRoot> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GamingRoot {
  GamingRoot({
    required this.bannerImage,
    required this.datavalues,
  });

  final String bannerImage;
  final List<GamingDatavalue> datavalues;

  factory GamingRoot.fromJson(Map<String, dynamic> json) => GamingRoot(
        bannerImage: json["banner_image"],
        datavalues: List<GamingDatavalue>.from(
            json["datavalues"].map((x) => GamingDatavalue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "banner_image": bannerImage,
        "datavalues": List<dynamic>.from(datavalues.map((x) => x.toJson())),
      };
}

class GamingDatavalue {
  GamingDatavalue({
    required this.mainHeader,
    required this.data,
  });

  final String mainHeader;
  final List<GamingDatum> data;

  factory GamingDatavalue.fromJson(Map<String, dynamic> json) =>
      GamingDatavalue(
        mainHeader: json["main_header"],
        data: List<GamingDatum>.from(
            json["data"].map((x) => GamingDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "main_header": mainHeader,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class GamingDatum {
  GamingDatum({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.redirectUrl,
  });

  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String redirectUrl;

  factory GamingDatum.fromJson(Map<String, dynamic> json) => GamingDatum(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        imageUrl: json["image_url"],
        redirectUrl: json["redirect_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "image_url": imageUrl,
        "redirect_url": redirectUrl,
      };
}
