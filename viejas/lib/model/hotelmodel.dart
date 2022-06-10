import 'package:meta/meta.dart';
import 'dart:convert';

List<HotelRoot> hotelRootFromJson(String str) =>
    List<HotelRoot>.from(json.decode(str).map((x) => HotelRoot.fromJson(x)));

String hotelRootToJson(List<HotelRoot> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HotelRoot {
  HotelRoot({
    required this.bannerImage,
    required this.datavalues,
  });

  final String bannerImage;
  final List<HotelDatavalue> datavalues;

  factory HotelRoot.fromJson(Map<String, dynamic> json) => HotelRoot(
        bannerImage: json["banner_image"],
        datavalues: List<HotelDatavalue>.from(
            json["datavalues"].map((x) => HotelDatavalue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "banner_image": bannerImage,
        "datavalues": List<dynamic>.from(datavalues.map((x) => x.toJson())),
      };
}

class HotelDatavalue {
  HotelDatavalue({
    required this.mainHeader,
    required this.data,
  });

  final String mainHeader;
  final List<HotelDatum> data;

  factory HotelDatavalue.fromJson(Map<String, dynamic> json) => HotelDatavalue(
        mainHeader: json["main_header"],
        data: List<HotelDatum>.from(
            json["data"].map((x) => HotelDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "main_header": mainHeader,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class HotelDatum {
  HotelDatum({
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

  factory HotelDatum.fromJson(Map<String, dynamic> json) => HotelDatum(
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
