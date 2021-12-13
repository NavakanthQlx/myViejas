import 'package:flutter/material.dart';
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
