import 'dart:convert';

List<Casino> casinoFromJson(String str) =>
    List<Casino>.from(json.decode(str).map((x) => Casino.fromJson(x)));

String casinoToJson(List<Casino> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Casino {
  Casino({
    required this.data,
  });

  final List<CasinoList> data;

  factory Casino.fromJson(Map<String, dynamic> json) => Casino(
        data: List<CasinoList>.from(
            json["data"].map((x) => CasinoList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CasinoList {
  CasinoList({
    required this.name,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.timings,
    required this.phone,
    required this.website,
    required this.id,
    required this.logo,
    required this.thumbnail,
    required this.services,
  });

  final String name;
  final String description;
  final String address;
  final String latitude;
  final String longitude;
  final String timings;
  final String phone;
  final String website;
  final String id;
  final String logo;
  final String thumbnail;
  final List<Service> services;

  factory CasinoList.fromJson(Map<String, dynamic> json) => CasinoList(
        name: json["name"],
        description: json["description"],
        address: json["address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        timings: json["timings"],
        phone: json["phone"],
        website: json["website"],
        id: json["id"],
        logo: json["logo"],
        thumbnail: json["thumbnail"],
        services: List<Service>.from(
            json["services"].map((x) => Service.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "timings": timings,
        "phone": phone,
        "website": website,
        "id": id,
        "logo": logo,
        "thumbnail": thumbnail,
        "services": List<dynamic>.from(services.map((x) => x.toJson())),
      };
}

class Service {
  Service({
    required this.serviceIcon,
    required this.serviceName,
    required this.logo,
  });

  final String serviceIcon;
  final String serviceName;
  final String logo;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        serviceIcon: json["service_icon"],
        serviceName: json["service_name"],
        logo: json["logo"],
      );

  Map<String, dynamic> toJson() => {
        "service_icon": serviceIcon,
        "service_name": serviceName,
        "logo": logo,
      };
}
