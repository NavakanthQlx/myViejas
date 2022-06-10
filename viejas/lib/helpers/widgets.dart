import 'package:flutter/material.dart';
import 'package:viejas/screens/notifications.dart';

AppBar myAppBar({BuildContext? context}) {
  return AppBar(
    centerTitle: true,
    title: Center(
      child: Container(
        width: 80,
        height: 90,
        child: Image.asset('images/Logo.png', fit: BoxFit.fill),
      ),
    ),
    actions: [
      IconButton(
          iconSize: 30,
          onPressed: () => {
                if (context != null)
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Notifications()),
                    )
                  }
              },
          icon: Icon(Icons.notifications)),
    ],
  );
}
