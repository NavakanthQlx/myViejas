import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viejas/constants/constants.dart';
import 'package:viejas/helpers/utils.dart';
import 'package:viejas/screens/CommonDetail.dart';
import 'package:viejas/screens/Dining/DiningScreen.dart';
import 'package:viejas/screens/Gaming/GamingScreen.dart';
import 'package:viejas/screens/Hotel/HotelScreen.dart';
import 'package:viejas/screens/LoginScreen.dart';
import 'package:viejas/screens/MusicScreen.dart';
import 'package:viejas/screens/Settings.dart';
import 'package:viejas/screens/ViejasOutlet.dart';
import 'package:viejas/screens/contactus.dart';
import 'package:viejas/screens/tabspage.dart';

class Sidemenu extends StatefulWidget {
  const Sidemenu({Key? key}) : super(key: key);

  @override
  _SidemenuState createState() => _SidemenuState();
}

class _SidemenuState extends State<Sidemenu> {
  // ListTile _buildSideMenuRow(String imageName, String title,
  //     {VoidCallback? onTap}) {
  //   return ListTile(
  //     onTap: onTap,
  //     leading: ImageIcon(
  //       AssetImage("images/$imageName"),
  //       color: Colors.grey,
  //       size: 35,
  //     ),
  //     title: Column(
  //       children: [
  //         Text(
  //           title,
  //           style: TextStyle(
  //               color: Colors.white70,
  //               fontWeight: FontWeight.normal,
  //               fontSize: 20),
  //         ),
  //         Container(
  //           height: 5,
  //           margin: EdgeInsets.only(top: 10),
  //           decoration: BoxDecoration(
  //             image: DecorationImage(
  //                 image: AssetImage('images/line.png'), fit: BoxFit.fill),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildSideMenuRow(String imageName, String title,
      {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Row(
              children: [
                ImageIcon(
                  AssetImage("images/$imageName"),
                  color: Colors.grey,
                  size: 30,
                ),
                SizedBox(
                  width: 25,
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.normal,
                      fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 5,
              padding: EdgeInsets.symmetric(horizontal: 100),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/line.png'), fit: BoxFit.fill),
              ),
            ),
          ],
        ),
      ),
    );
  }

  var isUserLoggedIn = false;

  getIsUserLoggedIn() async {
    isUserLoggedIn = await UserManager.isUserLogin();
    setState(() {});
  }

  @override
  initState() {
    super.initState();
    getIsUserLoggedIn();
    print('isUserLoggedIn ***--> $isUserLoggedIn');
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSideMenuRow('Home.png', 'Home', onTap: () {
                    moveToHomePage();
                  }),
                  _buildSideMenuRow('Offers.png', 'Offers', onTap: () {
                    if (isUserLoggedIn) {
                      moveToOffersPage();
                    } else {
                      moveToLoginScreen();
                    }
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
                    moveToMusicPage();
                  }),
                  _buildSideMenuRow('Cart.png', 'Viejas Outlet Centre',
                      onTap: () {
                    moveToViejasOutletPage();
                  }),
                  _buildSideMenuRow('Contactus.png', 'Contact us', onTap: () {
                    moveToContactusPage();
                  }),
                  _buildSideMenuRow('Map.png', 'Map', onTap: () {
                    moveToMapPage();
                  }),
                  _buildSideMenuRow('Settings.png', 'Settings', onTap: () {
                    if (isUserLoggedIn) {
                      moveToSettingsScreen();
                    } else {
                      moveToLoginScreen();
                    }
                  }),
                  FutureBuilder(
                    future: UserManager.isUserLogin(),
                    builder: (BuildContext context, AsyncSnapshot<bool> prefs) {
                      print('isuserloggedin -> ${prefs.data}');
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
                            prefs.remove(Constants.userName);
                            prefs.remove(Constants.tier);
                            prefs.remove(Constants.points);
                            getIsUserLoggedIn();
                            moveToHomePage();
                          });
                        });
                      } else {
                        return _buildSideMenuRow('Login.png', 'Login',
                            onTap: () {
                          moveToLoginScreen();
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

  void moveToSettingsScreen() {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Settings()),
    );
  }

  void moveToLoginScreen() async {
    Navigator.of(context).pop();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
    if (result == true) {
      getIsUserLoggedIn();
    }
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

  void moveToMapPage() {
    Navigator.of(context).pop();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TabsPage(selectedIndex: 1)),
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

  void moveToViejasOutletPage() {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViejasOutletScreen(),
      ),
    );
  }

  void moveToMusicPage() {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MusicScreen(),
      ),
    );
  }

  void moveToContactusPage() {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactUsScreen(),
      ),
    );
  }

  void moveToGamingPage() {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GamingScreen(),
      ),
    );
  }

  void moveToHotelPage() {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HotelScreen(),
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
