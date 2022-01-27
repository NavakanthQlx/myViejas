import 'package:flutter/material.dart';
import 'package:viejas/helpers/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:viejas/screens/WebViewScreen.dart';
import 'package:viejas/screens/contactus.dart';

class ContactUsDetailsScreen extends StatefulWidget {
  final GroupedModel model;
  const ContactUsDetailsScreen({Key? key, required this.model})
      : super(key: key);

  @override
  _ContactUsDetailsScreenState createState() => _ContactUsDetailsScreenState();
}

class _ContactUsDetailsScreenState extends State<ContactUsDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: Container(child: _buildListView(context, widget.model)),
    );
  }

  ListView _buildListView(BuildContext context, GroupedModel users) {
    return ListView.builder(
      itemCount: 3,
      shrinkWrap: true,
      itemBuilder: (contex, index) {
        if (index == 0) {
          return _buildHeaderImage();
        } else if (index == 1) {
          return _buildNewSlots(users);
        } else {
          return _buildViewMenu(users);
        }
      },
    );
  }

  Container _buildHeaderImage() {
    if (widget.model.data.imageUrl.isNotEmpty) {
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
        imageUrl: widget.model.data.imageUrl,
      ),
    );
  }

  Container _buildViewMenu(GroupedModel obj) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 0, 15, 5),
      height: 50,
      child: Center(
        child: SizedBox(
          height: 40,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.redAccent),
            onPressed: () {
              if (obj.data.redirectUrl != "") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WebViewScreen(
                            urlString: obj.data.redirectUrl,
                          )),
                );
              }
            },
            child: Text(obj.data.pageButton),
          ),
        ),
      ),
    );
  }

  Container _buildNewSlots(GroupedModel obj) {
    return Container(
      margin: EdgeInsets.fromLTRB(25, 15, 15, 10),
      child: Column(
        children: [
          Text(
            obj.data.pageHeader,
            style: TextStyle(
                overflow: TextOverflow.visible,
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          SizedBox(
            height: 10,
          ),
          Container(height: 3, width: 150, color: Colors.red),
          SizedBox(
            height: 15,
          ),
          Text(
            obj.data.pageDescription,
            style: TextStyle(
                overflow: TextOverflow.visible,
                fontSize: 15,
                color: Colors.white),
          ),
        ],
      ),
    );
  }
}
