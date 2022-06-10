import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:viejas/helpers/widgets.dart';
import 'package:viejas/model/offersmodel.dart';
import 'package:viejas/model/promotions.dart';
import 'package:viejas/screens/Offerdetails.dart';
import 'package:viejas/screens/SideMenu.dart';
import 'package:viejas/screens/WebViewScreen.dart';
import 'package:viejas/constants/constants.dart';
import 'package:viejas/helpers/utils.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity/connectivity.dart';

class Offers extends StatefulWidget {
  final bool showAppBar;

  const Offers({Key? key, required this.showAppBar}) : super(key: key);

  @override
  _OffersState createState() => _OffersState();
}

class _OffersState extends State<Offers> {
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
    String urlStr = Constants.getOffersURL;
    String playerId = await UserManager.getPlayerId();
    var params = {'player_id': playerId};
    var url = Uri.parse(urlStr);
    var response = await http.post(
      url,
      body: convert.jsonEncode(params),
    );
    var json = convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      var usersListArray = offerFromJson(response.body);
      return usersListArray;
    } else {
      var error = json['error'];
      return error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: widget.showAppBar ? Sidemenu() : null,
      appBar: myAppBar(context: context),
      // body: Container(child: _buildFuture()),
      body: RefreshIndicator(
    onRefresh: () async {
    await Future.delayed(Duration(seconds: 2));
    getDataFromAPI();
    }, child: _buildFuture(),),
    );
  }

  FutureBuilder<dynamic> _buildFuture() {
    return FutureBuilder<dynamic>(
      future: getDataFromAPI(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data is List<OffersList>?) {
            List<OffersList>? usersArray = snapshot.data;
            if (usersArray!.length > 0) {
              return _buildGridView(context, usersArray);
            } else {
              return _showErrorMessage('No Offers Available');
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

  ListView _buildGridView(BuildContext context, List<OffersList> users) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: users.length,
      itemBuilder: (contex, index) {
        return _buildPromotionCell(context, users[index]);
      },
    );
  }

  Widget _buildPromotionCell(BuildContext context, OffersList promotionObj) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OfferDetails(
              obj: promotionObj,
            ),
          ),
        );
      },
      child: Container(
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
                      imageUrl: promotionObj.tagIcon ?? "",
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
                        promotionObj.title ?? "",
                        style: TextStyle(
                            overflow: TextOverflow.clip,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        promotionObj.validity ?? "",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
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
      ),
    );
  }

  Center _showErrorMessage(String errorMessage) {
    return Center(
      child: Text(
        errorMessage,
        style: TextStyle(fontSize: 20),
      ),
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
