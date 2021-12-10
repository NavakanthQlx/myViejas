import 'package:flutter/material.dart';
import 'package:viejas/constants/constants.dart';
import 'package:viejas/helpers/widgets.dart';
import 'package:viejas/screens/Balance.dart';
import 'package:viejas/screens/HomeScreen.dart';
import 'package:viejas/screens/MapScreen.dart';
import 'package:viejas/screens/Offers.dart';
import 'package:viejas/screens/Promotions.dart';
import 'package:viejas/screens/SideMenu.dart';
import 'package:viejas/screens/notifications.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  List<Widget> tabs = [
    HomeScreen(),
    MapScreen(
      showAppBar: false,
    ),
    Promotions(
      bannerImageUrl: "",
      showAppBar: false,
    ),
    Offers(
      showAppBar: false,
    ),
    Balance()
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white //here you can give the text color
            ),
        primaryTextTheme: TextTheme(headline6: TextStyle(color: Colors.white)),
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Constants.appGrayBgColor,
        bottomAppBarColor: Colors.black,
        textTheme: TextTheme(
          bodyText1: TextStyle(),
          bodyText2: TextStyle(),
        ).apply(
          bodyColor: Colors.white,
        ),
      ),
      home: Scaffold(
        appBar: myAppBar(),
        drawer: Sidemenu(),
        bottomNavigationBar: tabbar(context),
        body: tabs[_selectedIndex],
      ),
    );
  }

  Theme tabbar(BuildContext context) {
    return new Theme(
      data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: Colors.black,
          // sets the active color of the `BottomNavigationBar` if `Brightness` is light
          primaryColor: Colors.red,
          textTheme: Theme.of(context).textTheme.copyWith(
              caption: new TextStyle(
                  color: Colors
                      .white))), // sets the inactive color of the `BottomNavigationBar`
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("images/Home.png"),
            ),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("images/Map.png"),
            ),
            label: 'MAP',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("images/Promotions.png"),
            ),
            label: 'PROMOTIONS',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("images/Offers.png"),
            ),
            label: 'OFFERS',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("images/Balance.png"),
            ),
            label: 'BALANCE',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white,
        showUnselectedLabels: true,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
