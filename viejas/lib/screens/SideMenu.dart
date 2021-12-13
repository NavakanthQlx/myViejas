import 'package:flutter/material.dart';
import 'package:viejas/screens/CommonDetail.dart';
import 'package:viejas/screens/EventScreen.dart';
import 'package:viejas/screens/LoginScreen.dart';
import 'package:viejas/screens/Settings.dart';
import 'package:viejas/screens/tabspage.dart';

class Sidemenu extends StatefulWidget {
  const Sidemenu({Key? key}) : super(key: key);

  @override
  _SidemenuState createState() => _SidemenuState();
}

class _SidemenuState extends State<Sidemenu> {
  ListTile _buildSideMenuRow(String imageName, String title,
      {VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      leading: ImageIcon(
        AssetImage("images/$imageName"),
        color: Colors.grey,
        size: 35,
      ),
      title: Text(
        title,
        style: TextStyle(
            color: Colors.white70, fontWeight: FontWeight.normal, fontSize: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.black),
      child: Drawer(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 40, 10, 70),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildSideMenuRow('Home.png', 'Home', onTap: () {
                    moveToHomePage();
                  }),
                  _buildSideMenuRow('Offers.png', 'Offers', onTap: () {
                    moveToOffersPage();
                  }),
                  _buildSideMenuRow('Promotions.png', 'Promotions', onTap: () {
                    moveToPromotionsPage();
                  }),
                  _buildSideMenuRow('Gaming.png', 'Gaming', onTap: () {
                    moveToCommonDetailPage();
                  }),
                  _buildSideMenuRow('Hotel.png', 'Hotel', onTap: () {
                    moveToEventPage();
                  }),
                  _buildSideMenuRow('Dining.png', 'Dining', onTap: () {
                    moveToCommonDetailPage();
                  }),
                  _buildSideMenuRow('Music.png', 'Music and Lounges'),
                  _buildSideMenuRow('Cart.png', 'Viejas Outlet Centre'),
                  _buildSideMenuRow('Contactus.png', 'Contact us'),
                  _buildSideMenuRow('Map.png', 'Map', onTap: () {
                    // Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TabsPage(selectedIndex: 1)),
                    );
                  }),
                  _buildSideMenuRow('Settings.png', 'Settings', onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Settings()),
                    );
                  }),
                  _buildSideMenuRow('Login.png', 'Login', onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void moveToHomePage() {
    // Navigator.of(context).pop();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TabsPage(selectedIndex: 0),
      ),
    );
  }

  void moveToPromotionsPage() {
    // Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TabsPage(selectedIndex: 2),
      ),
    );
  }

  void moveToOffersPage() {
    // Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TabsPage(selectedIndex: 3)),
    );
  }

  void moveToCommonDetailPage() {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommonDetailScreen(
          bannerImageUrl: '',
        ),
      ),
    );
  }

  void moveToEventPage() {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventScreen(
          bannerImageUrl: '',
        ),
      ),
    );
  }
}
