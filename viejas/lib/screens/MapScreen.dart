import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:viejas/helpers/widgets.dart';
import 'package:viejas/screens/SideMenu.dart';

class MapScreen extends StatefulWidget {
  final bool showAppBar;

  const MapScreen({Key? key, required this.showAppBar}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidemenu(),
      appBar: widget.showAppBar ? myAppBar(context: context) : null,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            height: 280.0,
            width: double.infinity,
            color: Colors.red,
            child: CachedNetworkImage(
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(
                child: Stack(alignment: Alignment.center, children: [
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: Image(
                        fit: BoxFit.cover,
                        image: AssetImage('images/placeholderimage.jpeg')),
                  ),
                  Container(
                      height: 20,
                      width: 20,
                      child: const CircularProgressIndicator()),
                ]),
              ),
              imageUrl: 'http://www.casinovizion.com/viejasapp/images/map.png',
            ),
          ),
        ],
      ),
    );
  }
}
