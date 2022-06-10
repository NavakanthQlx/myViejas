// To parse this JSON data, do
//
//     final promotions = promotionsFromJson(jsonString);

// List<Promotions> promotionsFromJson(String str) => List<Promotions>.from(json.decode(str).map((x) => Promotions.fromJson(x)));

// String promotionsToJson(List<Promotions> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PromotionsHead {
  final List<PromotionsList> users;
  PromotionsHead({required this.users});
  factory PromotionsHead.fromJson(List<dynamic> parsedJson) {
    List<PromotionsList> users = [];
    users = parsedJson.map((i) => PromotionsList.fromJson(i)).toList();
    return PromotionsHead(users: users);
  }
}

class PromotionsList {
  PromotionsList({
    required this.promoname,
    required this.promotitle,
    required this.img,
    required this.description,
    required this.timings,
    required this.dates,
    required this.promoid,
    required this.promocode,
    required this.promostatus,
    required this.videourl,
    required this.casinoId,
    required this.casinoname,
    required this.latitude,
    required this.longitude,
  });

  final String promoname;
  final String promotitle;
  final String img;
  final String description;
  final String timings;
  final String dates;
  final String promoid;
  final String promocode;
  final String promostatus;
  final String videourl;
  final String casinoId;
  final String casinoname;
  final String latitude;
  final String longitude;

  factory PromotionsList.fromJson(Map<String, dynamic> json) => PromotionsList(
        promoname: json["promoname"],
        promotitle: json["promotitle"],
        img: json["img"],
        description: json["description"],
        timings: json["timings"],
        dates: json["dates"],
        promoid: json["promoid"],
        promocode: json["promocode"],
        promostatus: json["promostatus"],
        videourl: json["videourl"],
        casinoId: json["casino_id"],
        casinoname: json["casinoname"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "promoname": promoname,
        "promotitle": promotitle,
        "img": img,
        "description": description,
        "timings": timings,
        "dates": dates,
        "promoid": promoid,
        "promocode": promocode,
        "promostatus": promostatus,
        "videourl": videourl,
        "casino_id": casinoId,
        "casinoname": casinoname,
        "latitude": latitude,
        "longitude": longitude,
      };
}
