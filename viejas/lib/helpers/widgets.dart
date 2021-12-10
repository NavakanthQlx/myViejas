import 'package:flutter/material.dart';

AppBar myAppBar() {
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
                //  Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => Notifications()),
                // )
              },
          icon: Icon(Icons.notifications)),
    ],
  );
}
