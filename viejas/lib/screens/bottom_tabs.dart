import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:viejas/screens/Balance.dart';
import 'package:viejas/screens/HomeScreen.dart';
import 'package:viejas/screens/MapScreen.dart';
import 'package:viejas/screens/Offers.dart';
import 'package:viejas/screens/Promotions.dart';

class TabNavigationItem {
  final Widget page;
  final Widget title;
  final Widget icon;

  TabNavigationItem(
      {required this.page, required this.title, required this.icon});

  static List<TabNavigationItem> get items => [
        TabNavigationItem(
          page: HomeScreen(),
          icon: ImageIcon(
            AssetImage("images/Home.png"),
          ),
          title: Text("HOME"),
        ),
        TabNavigationItem(
          page: MapScreen(
            showAppBar: true,
          ),
          icon: ImageIcon(
            AssetImage("images/Map.png"),
          ),
          title: Text("MAP"),
        ),
        TabNavigationItem(
          page: Promotions(
            showAppBar: true,
          ),
          icon: ImageIcon(
            AssetImage("images/Promotions.png"),
          ),
          title: Text("PROMOTIONS"),
        ),
        TabNavigationItem(
          page: Offers(
            showAppBar: true,
          ),
          icon: ImageIcon(
            AssetImage("images/Offers.png"),
          ),
          title: Text("OFFERS"),
        ),
        TabNavigationItem(
          page: Balance(),
          icon: ImageIcon(
            AssetImage("images/Balance.png"),
          ),
          title: Text("BALANCE"),
        ),
      ];
}
