import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:viejas/constants/constants.dart';
import 'package:viejas/screens/tabspage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print(
            'Location permissions are permanently denied, we cannot request permissions.');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      // return position;
      print("position is -> $position");
    } catch (e) {
      print('error -> $e');
      return Future.error(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: TabsPage(selectedIndex: 0),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
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
    );
  }
}
