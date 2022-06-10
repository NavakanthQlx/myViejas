import 'package:meta/meta.dart';
import 'dart:convert';

List<ContactusRoot> contactusFromJson(String str) => List<ContactusRoot>.from(
    json.decode(str).map((x) => ContactusRoot.fromJson(x)));

// String contactusToJson(List<ContactusRoot> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ContactusRoot {
  ContactusRoot({
    required this.bannerImage,
    required this.datavalues,
  });

  final String bannerImage;
  final List<ContactDatavalue> datavalues;

  factory ContactusRoot.fromJson(Map<String, dynamic> json) => ContactusRoot(
        bannerImage: json["banner_image"],
        datavalues: List<ContactDatavalue>.from(
            json["datavalues"].map((x) => ContactDatavalue.fromJson(x))),
      );

  // Map<String, dynamic> toJson() => {
  //       "banner_image": bannerImage,
  //       "datavalues": List<dynamic>.from(datavalues.map((x) => x.toJson())),
  //     };
}

class ContactDatavalue {
  ContactDatavalue({
    required this.mainHeader,
    required this.data,
  });

  final String mainHeader;
  final List<ContactusDatum> data;

  factory ContactDatavalue.fromJson(Map<String, dynamic> json) =>
      ContactDatavalue(
        mainHeader: json["main_header"],
        data: List<ContactusDatum>.from(
            json["data"].map((x) => ContactusDatum.fromJson(x))),
      );

  // Map<String, dynamic> toJson() => {
  //       "main_header": mainHeader,
  //       "data": List<dynamic>.from(data.map((x) => x.toJson())),
  //     };
}

class ContactusDatum {
  ContactusDatum({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.directRedirectUrl,
    required this.pageHeader,
    required this.pageDescription,
    required this.pageButton,
    required this.redirectUrl,
  });

  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String directRedirectUrl;
  final String pageHeader;
  final String pageDescription;
  final String pageButton;
  final String redirectUrl;

  factory ContactusDatum.fromJson(Map<String, dynamic> json) => ContactusDatum(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        imageUrl: json["image_url"],
        directRedirectUrl: json["direct_redirect_url"],
        pageHeader: json["page_header"],
        pageDescription: json["page_description"],
        pageButton: json["page_button"],
        redirectUrl: json["redirect_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "image_url": imageUrl,
        "direct_redirect_url": directRedirectUrl,
        "page_header": pageHeader,
        "page_description": pageDescription,
        "page_button": pageButton,
        "redirect_url": redirectUrl,
      };
}
