import 'package:meta/meta.dart';
import 'dart:convert';

List<MusicRoot> musicRootFromJson(String str) =>
    List<MusicRoot>.from(json.decode(str).map((x) => MusicRoot.fromJson(x)));

String musicRootToJson(List<MusicRoot> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MusicRoot {
  MusicRoot({
    required this.bannerImage,
    required this.datavalues,
  });

  final String bannerImage;
  final List<MusicDatavalue> datavalues;

  factory MusicRoot.fromJson(Map<String, dynamic> json) => MusicRoot(
        bannerImage: json["banner_image"],
        datavalues: List<MusicDatavalue>.from(
            json["datavalues"].map((x) => MusicDatavalue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "banner_image": bannerImage,
        "datavalues": List<dynamic>.from(datavalues.map((x) => x.toJson())),
      };
}

class MusicDatavalue {
  MusicDatavalue({
    required this.mainHeader,
    required this.data,
  });

  final String mainHeader;
  final List<MusicDatum> data;

  factory MusicDatavalue.fromJson(Map<String, dynamic> json) => MusicDatavalue(
        mainHeader: json["main_header"],
        data: List<MusicDatum>.from(
            json["data"].map((x) => MusicDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "main_header": mainHeader,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class MusicDatum {
  MusicDatum({
    required this.id,
    required this.title,
    required this.description,
    required this.menuUrl,
    required this.redirectUrl,
  });

  final String id;
  final String title;
  final String description;
  final String menuUrl;
  final String redirectUrl;

  factory MusicDatum.fromJson(Map<String, dynamic> json) => MusicDatum(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        menuUrl: json["menu_url"],
        redirectUrl: json["redirect_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "menu_url": menuUrl,
        "redirect_url": redirectUrl,
      };
}
