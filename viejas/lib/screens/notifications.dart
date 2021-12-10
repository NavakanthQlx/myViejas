import 'package:flutter/material.dart';
import 'package:viejas/helpers/widgets.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: Container(
        child: Container(
          width: 100.0,
          height: 100.0,
        ),
      ),
    );
  }
}
