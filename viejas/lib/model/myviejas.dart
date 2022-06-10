import 'package:meta/meta.dart';
import 'dart:convert';

List<MyViejasObject> myViejasObjectFromJson(String str) =>
    List<MyViejasObject>.from(
        json.decode(str).map((x) => MyViejasObject.fromJson(x)));

String myViejasObjectToJson(List<MyViejasObject> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyViejasObject {
  MyViejasObject({
    required this.bannerImage,
    required this.mainHeader,
    required this.data,
  });

  final String bannerImage;
  final String mainHeader;
  final List<MyViejasDatum> data;

  factory MyViejasObject.fromJson(Map<String, dynamic> json) => MyViejasObject(
        bannerImage: json["banner_image"],
        mainHeader: json["main_header"],
        data: List<MyViejasDatum>.from(
            json["data"].map((x) => MyViejasDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "banner_image": bannerImage,
        "main_header": mainHeader,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class MyViejasDatum {
  MyViejasDatum({
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

  factory MyViejasDatum.fromJson(Map<String, dynamic> json) => MyViejasDatum(
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
