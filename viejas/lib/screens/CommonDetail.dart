import 'package:flutter/material.dart';
import 'package:viejas/helpers/widgets.dart';
import 'package:viejas/model/dining.dart';
import 'package:viejas/model/events.dart';
import 'package:viejas/screens/WebViewScreen.dart';
import 'package:viejas/constants/constants.dart';
import 'package:viejas/helpers/utils.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity/connectivity.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CommonDetailScreen extends StatefulWidget {
  final String bannerImageUrl;

  const CommonDetailScreen({Key? key, required this.bannerImageUrl})
      : super(key: key);

  @override
  _CommonDetailScreenState createState() => _CommonDetailScreenState();
}

class _CommonDetailScreenState extends State<CommonDetailScreen> {
  Future<dynamic> getDataFromAPI() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      print('connected');
    } else if (connectivityResult == ConnectivityResult.none) {
      Utils.showToast('Please check your Internet Connection');
      return [];
    }
    //1056471
    String playerID = await UserManager.getPlayerId();
    String url = Constants.loaddinelist + "player_id=$playerID&casino_id=30";
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    print('url -> $url');
    print('json -> $json');
    if (response.statusCode == 200) {
      var usersListArray = DiningHead.fromJson(json);
      return usersListArray.users;
    } else {
      var error = json['error'];
      return error;
    }
  }

  Future<dynamic> getEventDataFromAPI() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      print('connected');
    } else if (connectivityResult == ConnectivityResult.none) {
      Utils.showToast('Please check your Internet Connection');
      return [];
    }
    String url = Constants.loaddinelist + "player_id=1056471&casino_id=30";
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
          if (snapshot.data is List<DiningList>?) {
            List<DiningList>? usersArray = snapshot.data;
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

  ListView _buildListView(BuildContext context, List<DiningList> users) {
    return ListView.builder(
      itemCount: users.length + 1,
      itemBuilder: (contex, index) {
        if (index == 0) {
          return _buildHeaderImage();
        } else {
          return _buildDiningCell(context, users[index - 1]);
        }
      },
    );
  }

  Container _buildHeaderImage() {
    if (widget.bannerImageUrl.isNotEmpty) {
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
        imageUrl: widget.bannerImageUrl,
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

  Widget _buildDiningCell(BuildContext context, DiningList diningObj) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WebViewScreen()),
        );
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
        alignment: Alignment.topLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 70.0,
              height: 70.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35),
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
                  imageUrl: diningObj.img,
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    diningObj.diningtitle,
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    diningObj.description,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        overflow: TextOverflow.visible,
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                        color: Colors.white70),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
