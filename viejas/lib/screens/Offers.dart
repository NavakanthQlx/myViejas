import 'package:flutter/material.dart';
import 'package:viejas/helpers/widgets.dart';
import 'package:viejas/screens/SideMenu.dart';

class Offers extends StatefulWidget {
  final bool showAppBar;

  const Offers({Key? key, required this.showAppBar}) : super(key: key);

  @override
  _OffersState createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidemenu(),
      appBar: widget.showAppBar ? myAppBar(context: context) : null,
      body: Container(
        child: Container(
          width: 100.0,
          height: 100.0,
        ),
      ),
    );
  }
}
