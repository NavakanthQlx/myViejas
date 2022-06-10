import 'package:meta/meta.dart';
import 'dart:convert';

List<DiningDetailRoot> diningDetailRootFromJson(String str) =>
    List<DiningDetailRoot>.from(
        json.decode(str).map((x) => DiningDetailRoot.fromJson(x)));

String diningDetailRootToJson(List<DiningDetailRoot> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DiningDetailRoot {
  DiningDetailRoot({
    required this.bannerImage,
    required this.mainHeader,
    required this.dinetime,
    required this.longDescription,
    required this.menu,
  });

  final String bannerImage;
  final String mainHeader;
  final String dinetime;
  final String longDescription;
  final List<DiningMenu> menu;

  factory DiningDetailRoot.fromJson(Map<String, dynamic> json) =>
      DiningDetailRoot(
        bannerImage: json["banner_image"],
        mainHeader: json["main_header"],
        dinetime: json["dinetime"],
        longDescription: json["long_description"],
        menu: List<DiningMenu>.from(
            json["menu"].map((x) => DiningMenu.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "banner_image": bannerImage,
        "main_header": mainHeader,
        "dinetime": dinetime,
        "long_description": longDescription,
        "menu": List<dynamic>.from(menu.map((x) => x.toJson())),
      };
}

class DiningMenu {
  DiningMenu({
    required this.menuId,
    required this.menuTitle,
    required this.menuLink,
  });

  final String menuId;
  final String menuTitle;
  final String menuLink;

  factory DiningMenu.fromJson(Map<String, dynamic> json) => DiningMenu(
        menuId: json["menu_id"],
        menuTitle: json["menu_title"],
        menuLink: json["menu_link"],
      );

  Map<String, dynamic> toJson() => {
        "menu_id": menuId,
        "menu_title": menuTitle,
        "menu_link": menuLink,
      };
}
