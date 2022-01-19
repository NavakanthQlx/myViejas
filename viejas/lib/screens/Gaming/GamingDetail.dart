import 'package:flutter/material.dart';
import 'package:viejas/helpers/widgets.dart';
import 'package:viejas/model/events.dart';
import 'package:viejas/constants/constants.dart';
import 'package:viejas/helpers/utils.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity/connectivity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:viejas/screens/WebViewScreen.dart';

class GamingDetail extends StatefulWidget {
  const GamingDetail({Key? key}) : super(key: key);

  @override
  _GamingDetailState createState() => _GamingDetailState();
}

class _GamingDetailState extends State<GamingDetail> {
  final String bannerImageUrl = "";

  Future<dynamic> getDataFromAPI() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      print('connected');
    } else if (connectivityResult == ConnectivityResult.none) {
      Utils.showToast('Please check your Internet Connection');
      return [];
    }
    String playerID = await UserManager.getPlayerId();
    String url = Constants.loadeventlist + "player_id=$playerID&casino_id=30";
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    print('url -> $url');
    print('json -> $json');
    if (response.statusCode == 200) {
      var usersListArray = EventHead.fromJson(json);
      return usersListArray.users;
    } else {
      var error = json['error'];
      return error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: Container(child: _buildFuture()),
    );
  }

  FutureBuilder<dynamic> _buildFuture() {
    return FutureBuilder<dynamic>(
      future: getDataFromAPI(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data is List<EventsList>?) {
            List<EventsList>? usersArray = snapshot.data;
            if (usersArray!.length > 0) {
              return _buildListView(context, usersArray);
            } else {
              return _showErrorMessage('Empty users');
            }
          } else {
            return _showErrorMessage(snapshot.data.toString());
          }
        } else if (snapshot.hasError) {
          return _showErrorMessage(snapshot.error.toString());
        } else {
          return _buildLoader();
        }
      },
    );
  }

  ListView _buildListView(BuildContext context, List<EventsList> users) {
    return ListView.builder(
      itemCount: users.length + 1,
      shrinkWrap: true,
      itemBuilder: (contex, index) {
        if (index == 0) {
          return _buildHeaderImage();
        } else if (index == 1) {
          return _buildNewSlots();
        } else {
          return _buildDiningCell(context, users[index - 1]);
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
        fit: BoxFit.fill,
        placeholder: (context, url) => Center(
          child: Stack(alignment: Alignment.center, children: [
            Container(
              height: double.infinity,
              child: Image(
                  fit: BoxFit.fill,
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

  Center _showErrorMessage(String errorMessage) {
    return Center(
      child: Text(errorMessage),
    );
  }

  Center _buildLoader() {
    return Center(
      child: SpinKitCircle(
        color: Colors.red,
        size: 50.0,
      ),
    );
  }

  Widget _buildDiningCell(BuildContext context, EventsList obj) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WebViewScreen()),
        );
      },
      child: _buildBottomCell(obj),
    );
  }

  Container _buildNewSlots() {
    return Container(
      margin: EdgeInsets.fromLTRB(25, 15, 15, 15),
      height: 100,
      child: Column(
        children: [
          Text(
            'THE NEW SLOTS',
            style: TextStyle(
                overflow: TextOverflow.visible,
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          SizedBox(
            height: 3,
          ),
          Container(height: 3, width: 150, color: Colors.red),
          SizedBox(
            height: 15,
          ),
          Text(
            'Enjoy the excitement of the best in San Diego casino action with the addition of 1,000 amzing all new slots!',
            style: TextStyle(
                overflow: TextOverflow.visible,
                fontSize: 15,
                color: Colors.white),
          ),
        ],
      ),
    );
  }

  Container _buildBottomCell(EventsList obj) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
      // height: 600,
      width: double.infinity,
      color: Colors.black,
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 300.0,
            child: CachedNetworkImage(
              fit: BoxFit.fill,
              placeholder: (context, url) => Center(
                child: Stack(alignment: Alignment.center, children: [
                  Container(
                    height: 300,
                    child: Image(
                        fit: BoxFit.fill,
                        image: AssetImage('images/placeholderimage.jpeg')),
                  ),
                  Container(
                      height: 20,
                      width: 20,
                      child: const CircularProgressIndicator()),
                ]),
              ),
              imageUrl: obj.img,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  obj.eventname,
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 3,
                ),
                Container(height: 3, width: 150, color: Colors.red),
                SizedBox(
                  height: 10,
                ),
                Text(
                  obj.description,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      overflow: TextOverflow.visible,
                      fontSize: 17,
                      fontWeight: FontWeight.normal,
                      color: Colors.white70),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
