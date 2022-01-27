import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:viejas/helpers/widgets.dart';
import 'package:viejas/constants/constants.dart';
import 'package:viejas/helpers/utils.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity/connectivity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:viejas/model/gamingmodel.dart';
import 'package:viejas/screens/Gaming/GamingDetail.dart';

class GamingGroupedModel {
  GamingGroupedModel({
    required this.mainHeader,
    required this.data,
  });

  final String mainHeader;
  final GamingDatum data;
}

class GamingScreen extends StatefulWidget {
  const GamingScreen({Key? key}) : super(key: key);

  @override
  _GamingScreenState createState() => _GamingScreenState();
}

class _GamingScreenState extends State<GamingScreen> {
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
    String urlStr = Constants.getGamingUrl;
    String casinoId = await UserManager.getCasinoId();
    var params = {"casino_id": casinoId};
    var url = Uri.parse(urlStr);
    var response = await http.post(
      url,
      body: convert.jsonEncode(params),
    );
    var json = convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      var usersListArray = gamingRootFromJson(response.body);
      return usersListArray;
    } else {
      var error = json['error'];
      return error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context: context),
      body: Container(child: _buildFuture()),
    );
  }

  FutureBuilder<dynamic> _buildFuture() {
    return FutureBuilder<dynamic>(
      future: getDataFromAPI(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data is List<GamingRoot>?) {
            List<GamingRoot>? usersArray = snapshot.data;
            if (usersArray!.length > 0) {
              bannerImageUrl = usersArray.first.bannerImage;
              List<GamingDatavalue> dataValues = usersArray.first.datavalues;
              List<GamingGroupedModel> groupedModel = [];
              for (GamingDatavalue i in dataValues) {
                if (i.data.length > 1) {
                  for (GamingDatum j in i.data) {
                    groupedModel.add(
                        GamingGroupedModel(mainHeader: i.mainHeader, data: j));
                  }
                } else {
                  groupedModel.add(GamingGroupedModel(
                      mainHeader: i.mainHeader, data: i.data.first));
                }
              }
              return ListView(
                children: [
                  _buildHeaderImage(),
                  _buildGroupedListView(groupedModel)
                ],
              );
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

  GroupedListView<GamingGroupedModel, String> _buildGroupedListView(
      List<GamingGroupedModel> _elements) {
    return GroupedListView<GamingGroupedModel, String>(
      shrinkWrap: true,
      elements: _elements,
      groupBy: (element) => element.mainHeader,
      useStickyGroupSeparators: false,
      groupSeparatorBuilder: (String value) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      itemBuilder: (context, element) {
        return _buildDiningCell(element.data);
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

  Widget _buildDiningCell(GamingDatum obj) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GamingDetail(
                    gamingId: obj.id,
                  )),
        );
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Row(
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
                                image:
                                    AssetImage('images/placeholderimage.jpeg')),
                          ),
                          Container(
                              height: 20,
                              width: 20,
                              child: const CircularProgressIndicator()),
                        ]),
                      ),
                      imageUrl: obj.imageUrl,
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
                        obj.title,
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold),
                      ),
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
}
