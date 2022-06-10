// To parse this JSON data, do
//
//     final diningList = diningListFromJson(jsonString);

import 'dart:convert';

List<DiningList> diningListFromJson(String str) =>
    List<DiningList>.from(json.decode(str).map((x) => DiningList.fromJson(x)));

String diningListToJson(List<DiningList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DiningHead {
  final List<DiningList> users;
  DiningHead({required this.users});
  factory DiningHead.fromJson(List<dynamic> parsedJson) {
    List<DiningList> users = [];
    users = parsedJson.map((i) => DiningList.fromJson(i)).toList();
    return DiningHead(users: users);
  }
}

class DiningList {
  DiningList({
    required this.diningname,
    required this.diningtitle,
    required this.img,
    required this.description,
    required this.timings,
    required this.diningstatus,
    required this.diningid,
    required this.phone,
    required this.casinoId,
    required this.casinoname,
    required this.latitude,
    required this.longitude,
    required this.videourl,
  });

  final String diningname;
  final String diningtitle;
  final String img;
  final String description;
  final String timings;
  final String diningstatus;
  final String diningid;
  final String phone;
  final String casinoId;
  final String casinoname;
  final String latitude;
  final String longitude;
  final String videourl;

  factory DiningList.fromJson(Map<String, dynamic> json) => DiningList(
        diningname: json["diningname"],
        diningtitle: json["diningtitle"],
        img: json["img"],
        description: json["description"],
        timings: json["timings"],
        diningstatus: json["diningstatus"],
        diningid: json["diningid"],
        phone: json["phone"],
        casinoId: json["casino_id"],
        casinoname: json["casinoname"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        videourl: json["videourl"],
      );

  Map<String, dynamic> toJson() => {
        "diningname": diningname,
        "diningtitle": diningtitle,
        "img": img,
        "description": description,
        "timings": timings,
        "diningstatus": diningstatus,
        "diningid": diningid,
        "phone": phone,
        "casino_id": casinoId,
        "casinoname": casinoname,
        "latitude": latitude,
        "longitude": longitude,
        "videourl": videourl,
      };
}
