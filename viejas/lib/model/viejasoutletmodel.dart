import 'package:meta/meta.dart';
import 'dart:convert';

List<ViejasOutletRoot> viejasOutletRootFromJson(String str) =>
    List<ViejasOutletRoot>.from(
        json.decode(str).map((x) => ViejasOutletRoot.fromJson(x)));

String viejasOutletRootToJson(List<ViejasOutletRoot> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ViejasOutletRoot {
  ViejasOutletRoot({
    required this.bannerImage,
    required this.mainHeader,
    required this.data,
  });

  final String bannerImage;
  final String mainHeader;
  final List<ViejasOutletDatum> data;

  factory ViejasOutletRoot.fromJson(Map<String, dynamic> json) =>
      ViejasOutletRoot(
        bannerImage: json["banner_image"],
        mainHeader: json["main_header"],
        data: List<ViejasOutletDatum>.from(
            json["data"].map((x) => ViejasOutletDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "banner_image": bannerImage,
        "main_header": mainHeader,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ViejasOutletDatum {
  ViejasOutletDatum({
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

  factory ViejasOutletDatum.fromJson(Map<String, dynamic> json) =>
      ViejasOutletDatum(
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
