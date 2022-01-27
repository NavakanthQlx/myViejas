import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:viejas/helpers/widgets.dart';
import 'package:viejas/model/promotions.dart';
import 'package:viejas/screens/SideMenu.dart';
import 'package:viejas/screens/WebViewScreen.dart';
import 'package:viejas/constants/constants.dart';
import 'package:viejas/helpers/utils.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity/connectivity.dart';

class Promotions extends StatefulWidget {
  final bool showAppBar;

  const Promotions({Key? key, required this.showAppBar}) : super(key: key);

  @override
  _PromotionsState createState() => _PromotionsState();
}

class _PromotionsState extends State<Promotions> {
  String bannerImageUrl = "";

  Future<dynamic> getDataFromAPI() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      print('connected');
    } else if (connectivityResult == ConnectivityResult.none) {
      Utils.showToast('Please check your Internet Connection');
      return [];
    }
    // print('url -> $url');
    // print('json -> $json');
    String urlStr = Constants.loadpromotionlist;
    String casinoId = await UserManager.getCasinoId();
    String playerId = await UserManager.getPlayerId();
    var params = {'player_id': playerId, "casino_id": casinoId};
    var url = Uri.parse(urlStr);
    var response = await http.post(
      url,
      body: convert.jsonEncode(params),
    );
    var json = convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      var usersListArray = PromotionsHead.fromJson(json);
      return usersListArray.users;
    } else {
      var error = json['error'];
      return error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: widget.showAppBar ? Sidemenu() : null,
      appBar: myAppBar(),
      body: Container(child: _buildFuture()),
    );
  }

  FutureBuilder<dynamic> _buildFuture() {
    return FutureBuilder<dynamic>(
      future: getDataFromAPI(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data is List<PromotionsList>?) {
            List<PromotionsList>? usersArray = snapshot.data;
            if (usersArray!.length > 0) {
              bannerImageUrl = usersArray.first.img;
              return _buildGridView(context, usersArray);
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

  ListView _buildGridView(BuildContext context, List<PromotionsList> users) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: users.length + 2,
      itemBuilder: (contex, index) {
        if (index == 0) {
          return _buildHeaderImage();
        } else if (index == 1) {
          return _buildSectionHeaderText();
        } else {
          return _buildPromotionCell(context, users[index - 2]);
        }
      },
    );
  }

  Padding _buildSectionHeaderText() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          'PROMOTIONS',
          style: TextStyle(
              overflow: TextOverflow.clip,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
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

  Container _buildPromotionCell(
      BuildContext context, PromotionsList promotionObj) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Column(
        children: [
          Row(
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
                              image:
                                  AssetImage('images/placeholderimage.jpeg')),
                        ),
                        Container(
                            height: 20,
                            width: 20,
                            child: const CircularProgressIndicator()),
                      ]),
                    ),
                    imageUrl: promotionObj.img,
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // _buildSectionHeader(),
                    Text(
                      promotionObj.promotitle,
                      style: TextStyle(
                          overflow: TextOverflow.clip,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WebViewScreen(
                                    urlString: promotionObj.videourl,
                                  )),
                        );
                      },
                      child: Text(
                        'Get details of all promotions',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.normal,
                            color: Colors.white70),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
            height: 5,
            padding: EdgeInsets.symmetric(horizontal: 100),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/line.png'), fit: BoxFit.cover),
            ),
          ),
        ],
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
}
