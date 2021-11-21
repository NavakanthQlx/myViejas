import 'package:flutter/material.dart';
import 'package:viejas/constants/constants.dart';
import 'package:viejas/screens/Balance.dart';
import 'package:viejas/screens/HomeScreen.dart';
import 'package:viejas/screens/MapScreen.dart';
import 'package:viejas/screens/Offers.dart';
import 'package:viejas/screens/Promotions.dart';

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
    MapScreen(),
    Promotions(),
    Offers(),
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
        appBar: AppBar(
          title: Text('VIEJAS'),
        ),
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
          print(index);
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class Sidemenu extends StatelessWidget {
  const Sidemenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 40, 10, 70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildSideMenuRow('Home.png', 'Home'),
              _buildSideMenuRow('Offers.png', 'Offers'),
              _buildSideMenuRow('Promotions.png', 'Promotions'),
              _buildSideMenuRow('Gaming.png', 'Gaming'),
              _buildSideMenuRow('Hotel.png', 'Hotel'),
              _buildSideMenuRow('Dining.png', 'Dining'),
              _buildSideMenuRow('Music.png', 'Music and Lounges'),
              _buildSideMenuRow('Cart.png', 'Viejas Outlet Centre'),
              _buildSideMenuRow('Contactus.png', 'Contact us'),
              _buildSideMenuRow('Map.png', 'Map'),
              _buildSideMenuRow('Settings.png', 'Settings'),
              _buildSideMenuRow('Login.png', 'Login'),
            ],
          ),
        ),
      ),
    );
  }

  ListTile _buildSideMenuRow(String imageName, String title) {
    return ListTile(
      onTap: () {},
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
}
