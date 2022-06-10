import 'dart:convert';

List<OffersList> offerFromJson(String str) =>
    List<OffersList>.from(json.decode(str).map((x) => OffersList.fromJson(x)));

String offerToJson(List<OffersList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OffersList {
  OffersList({
    required this.tagIcon,
    required this.title,
    required this.description,
    required this.validity,
    required this.tagBannerimg,
    required this.offer_category,
  });

  final String? tagIcon;
  final String? title;
  final String? description;
  final String? validity;
  final String? tagBannerimg;
  final String? offer_category;

  factory OffersList.fromJson(Map<String, dynamic> json) => OffersList(
        tagIcon: json["tag_icon"],
        title: json["title"],
        description: json["description"],
        validity: json["validitiy"],
        tagBannerimg: json["tag_bannerimg"],
        offer_category: json["offer_category"],
      );

  Map<String, dynamic> toJson() => {
        "tag_icon": tagIcon,
        "title": title,
        "description": description,
        "validity": validity,
        "tag_bannerimg": tagBannerimg,
        "offer_category": offer_category,
      };
}
