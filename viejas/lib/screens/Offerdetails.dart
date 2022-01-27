import 'package:flutter/material.dart';
import 'package:viejas/helpers/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:viejas/screens/WebViewScreen.dart';
import 'package:viejas/screens/contactus.dart';

class OfferDetails extends StatefulWidget {
  const OfferDetails({Key? key}) : super(key: key);

  @override
  _OfferDetailsState createState() => _OfferDetailsState();
}

class _OfferDetailsState extends State<OfferDetails> {
  String bannerImageUrl = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context: context),
      body: Container(child: _buildListView(context)),
    );
  }

  ListView _buildListView(BuildContext context) {
    return ListView.builder(
      itemCount: 2,
      shrinkWrap: true,
      itemBuilder: (contex, index) {
        if (index == 0) {
          return _buildHeaderImage();
        } else {
          return _buildNewSlots();
        }
      },
    );
  }

  Container _buildHeaderImage() {
    if (bannerImageUrl.isNotEmpty) {
      return _buildHeaderImageFromNetwork();
    } else {
      return Container(
        height: 280.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('images/temp.png'),
          ),
        ),
      );
    }
  }

  Container _buildHeaderImageFromNetwork() {
    return Container(
      height: 280.0,
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        placeholder: (context, url) => Center(
          child: Stack(alignment: Alignment.center, children: [
            Container(
              height: double.infinity,
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
        imageUrl: bannerImageUrl,
      ),
    );
  }

  Container _buildNewSlots() {
    return Container(
      margin: EdgeInsets.fromLTRB(25, 15, 15, 10),
      child: Column(
        children: [
          Text(
            'Offer details',
            style: TextStyle(
                overflow: TextOverflow.visible,
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ],
      ),
    );
  }

  // Container _buildNewSlots(GroupedModel obj) {
  //   return Container(
  //     margin: EdgeInsets.fromLTRB(25, 15, 15, 10),
  //     child: Column(
  //       children: [
  //         Text(
  //           obj.data.pageHeader,
  //           style: TextStyle(
  //               overflow: TextOverflow.visible,
  //               fontSize: 17,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.white),
  //         ),
  //         SizedBox(
  //           height: 10,
  //         ),
  //         Container(height: 3, width: 150, color: Colors.red),
  //         SizedBox(
  //           height: 15,
  //         ),
  //         Text(
  //           obj.data.pageDescription,
  //           style: TextStyle(
  //               overflow: TextOverflow.visible,
  //               fontSize: 15,
  //               color: Colors.white),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
