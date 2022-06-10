// To parse this JSON data, do
//
//     final eventsList = eventsListFromJson(jsonString);

import 'dart:convert';

List<EventsList> eventsListFromJson(String str) =>
    List<EventsList>.from(json.decode(str).map((x) => EventsList.fromJson(x)));

String eventsListToJson(List<EventsList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EventHead {
  final List<EventsList> users;
  EventHead({required this.users});
  factory EventHead.fromJson(List<dynamic> parsedJson) {
    List<EventsList> users = [];
    users = parsedJson.map((i) => EventsList.fromJson(i)).toList();
    return EventHead(users: users);
  }
}

class EventsList {
  EventsList({
    required this.eventname,
    required this.img,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.price,
    required this.date,
    required this.timings,
    required this.eventstatus,
    required this.eventid,
    required this.distance,
    required this.vendorurl,
    required this.casinoId,
    required this.casinoname,
    required this.casinolatitude,
    required this.casinolongitude,
    required this.videourl,
  });

  final String eventname;
  final String img;
  final String description;
  final String address;
  final String latitude;
  final String longitude;
  final String price;
  final String date;
  final String timings;
  final String eventstatus;
  final String eventid;
  final String distance;
  final String vendorurl;
  final String casinoId;
  final String casinoname;
  final String casinolatitude;
  final String casinolongitude;
  final String videourl;

  factory EventsList.fromJson(Map<String, dynamic> json) => EventsList(
        eventname: json["eventname"],
        img: json["img"],
        description: json["description"],
        address: json["address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        price: json["price"],
        date: json["date"],
        timings: json["timings"],
        eventstatus: json["eventstatus"],
        eventid: json["eventid"],
        distance: json["distance"],
        vendorurl: json["vendorurl"],
        casinoId: json["casino_id"],
        casinoname: json["casinoname"],
        casinolatitude: json["casinolatitude"],
        casinolongitude: json["casinolongitude"],
        videourl: json["videourl"],
      );

  Map<String, dynamic> toJson() => {
        "eventname": eventname,
        "img": img,
        "description": description,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "price": price,
        "date": date,
        "timings": timings,
        "eventstatus": eventstatus,
        "eventid": eventid,
        "distance": distance,
        "vendorurl": vendorurl,
        "casino_id": casinoId,
        "casinoname": casinoname,
        "casinolatitude": casinolatitude,
        "casinolongitude": casinolongitude,
        "videourl": videourl,
      };
}
