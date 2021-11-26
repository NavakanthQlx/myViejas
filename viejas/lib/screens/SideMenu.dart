import 'package:flutter/material.dart';
import 'package:viejas/screens/LoginScreen.dart';
import 'package:viejas/screens/MapScreen.dart';
import 'package:viejas/screens/Settings.dart';

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
    return Drawer(
      child: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 40, 10, 70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildSideMenuRow('Home.png', 'Home', onTap: () {
                Navigator.of(context).pop();
              }),
              _buildSideMenuRow('Offers.png', 'Offers'),
              _buildSideMenuRow('Promotions.png', 'Promotions'),
              _buildSideMenuRow('Gaming.png', 'Gaming'),
              _buildSideMenuRow('Hotel.png', 'Hotel'),
              _buildSideMenuRow('Dining.png', 'Dining'),
              _buildSideMenuRow('Music.png', 'Music and Lounges'),
              _buildSideMenuRow('Cart.png', 'Viejas Outlet Centre'),
              _buildSideMenuRow('Contactus.png', 'Contact us'),
              _buildSideMenuRow('Map.png', 'Map', onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapScreen()),
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
    );
  }
}
