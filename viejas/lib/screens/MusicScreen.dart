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
import 'package:viejas/model/hotelmodel.dart';
import 'package:viejas/model/musicmodel.dart';
import 'package:viejas/screens/WebViewScreen.dart';

class MusicGroupedModel {
  MusicGroupedModel({
    required this.mainHeader,
    required this.data,
  });

  final String mainHeader;
  final MusicDatum data;
}

class MusicScreen extends StatefulWidget {
  const MusicScreen({Key? key}) : super(key: key);

  @override
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
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
    String urlStr = Constants.getMusicLoungesUrl;
    var params = {"casino_id": "30"};
    var url = Uri.parse(urlStr);
    var response = await http.post(
      url,
      body: convert.jsonEncode(params),
    );
    var json = convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      var usersListArray = musicRootFromJson(response.body);
      return usersListArray;
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
          if (snapshot.data is List<MusicRoot>?) {
            List<MusicRoot>? usersArray = snapshot.data;
            if (usersArray!.length > 0) {
              bannerImageUrl = usersArray.first.bannerImage;
              List<MusicDatavalue> dataValues = usersArray.first.datavalues;
              List<MusicGroupedModel> groupedModel = [];
              for (MusicDatavalue i in dataValues) {
                if (i.data.length > 1) {
                  for (MusicDatum j in i.data) {
                    groupedModel.add(
                        MusicGroupedModel(mainHeader: i.mainHeader, data: j));
                  }
                } else {
                  groupedModel.add(MusicGroupedModel(
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

  GroupedListView<MusicGroupedModel, String> _buildGroupedListView(
      List<MusicGroupedModel> _elements) {
    return GroupedListView<MusicGroupedModel, String>(
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

  Widget _buildDiningCell(MusicDatum obj) {
    return GestureDetector(
      onTap: () {
        if (obj.redirectUrl != "") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    WebViewScreen(urlString: obj.redirectUrl)),
          );
        }
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
                  imageUrl: obj.menuUrl,
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
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
