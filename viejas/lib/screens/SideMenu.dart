import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viejas/constants/constants.dart';
import 'package:viejas/helpers/utils.dart';
import 'package:viejas/screens/CommonDetail.dart';
import 'package:viejas/screens/Dining/DiningScreen.dart';
import 'package:viejas/screens/Gaming/GamingScreen.dart';
import 'package:viejas/screens/Hotel/HotelScreen.dart';
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
      title: Column(
        children: [
          Text(
            title,
            style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.normal,
                fontSize: 20),
          ),
          Container(
            height: 5,
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/line.png'), fit: BoxFit.fill),
            ),
          ),
        ],
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
                    moveToGamingPage();
                  }),
                  _buildSideMenuRow('Hotel.png', 'Hotel', onTap: () {
                    moveToHotelPage();
                  }),
                  _buildSideMenuRow('Dining.png', 'Dining', onTap: () {
                    moveToDiningPage();
                  }),
                  _buildSideMenuRow('Music.png', 'Music and Lounges',
                      onTap: () {
                    moveToCommonDetailPage();
                  }),
                  _buildSideMenuRow('Cart.png', 'Viejas Outlet Centre',
                      onTap: () {
                    moveToCommonDetailPage();
                  }),
                  _buildSideMenuRow('Contactus.png', 'Contact us', onTap: () {
                    moveToCommonDetailPage();
                  }),
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
                  FutureBuilder(
                    future: UserManager.isUserLogin(),
                    builder: (BuildContext context, AsyncSnapshot<bool> prefs) {
                      var x = prefs.data ?? false;
                      if (x == true) {
                        return _buildSideMenuRow('Logout.png', 'Logout',
                            onTap: () {
                          Utils.showAndroidDialog(context,
                              title: "Warning",
                              message: "Are you sure you want to Logout ?",
                              okCallback: () async {
                            // Constants.removeUserData();
                            final prefs = await SharedPreferences.getInstance();
                            prefs.remove(Constants.userID);
                            prefs.remove(Constants.onesignaluserID);
                            setState(() {});
                          });
                        });
                      } else {
                        return _buildSideMenuRow('Login.png', 'Login',
                            onTap: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        });
                      }
                    },
                  ),
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

  void moveToGamingPage() {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GamingScreen(
          bannerImageUrl: '',
        ),
      ),
    );
  }

  void moveToHotelPage() {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HotelScreen(
          bannerImageUrl: '',
        ),
      ),
    );
  }

  void moveToDiningPage() {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiningScreen(
          bannerImageUrl: '',
        ),
      ),
    );
  }
}
