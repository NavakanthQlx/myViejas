import 'package:grouped_list/grouped_list.dart';
import 'package:viejas/helpers/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:viejas/model/contactusmodel.dart';
import 'package:viejas/screens/WebViewScreen.dart';
import 'package:viejas/constants/constants.dart';
import 'package:viejas/helpers/utils.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity/connectivity.dart';
import 'package:viejas/screens/contactusdetails.dart';

class GroupedModel {
  GroupedModel({
    required this.mainHeader,
    required this.data,
  });

  final String mainHeader;
  final ContactusDatum data;
}

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
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

    String urlStr = Constants.getContactusUrl;
    String casinoId = await UserManager.getCasinoId();
    var params = {"casino_id": casinoId};
    var url = Uri.parse(urlStr);
    var response = await http.post(
      url,
      body: convert.jsonEncode(params),
    );
    var json = convert.jsonDecode(response.body);
    if (response.statusCode == 200) {
      var usersListArray = contactusFromJson(response.body);
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
          if (snapshot.data is List<ContactusRoot>?) {
            List<ContactusRoot>? usersArray = snapshot.data;
            if (usersArray!.length > 0) {
              bannerImageUrl = usersArray.first.bannerImage;
              List<ContactDatavalue> dataValues = usersArray.first.datavalues;
              List<GroupedModel> groupedModel = [];
              for (ContactDatavalue i in dataValues) {
                if (i.data.length > 1) {
                  for (ContactusDatum j in i.data) {
                    groupedModel
                        .add(GroupedModel(mainHeader: i.mainHeader, data: j));
                  }
                } else {
                  groupedModel.add(GroupedModel(
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

  GroupedListView<GroupedModel, String> _buildGroupedListView(
      List<GroupedModel> _elements) {
    return GroupedListView<GroupedModel, String>(
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
        return _buildCell(element, element.data);
      },
    );
  }

  Widget _buildCell(GroupedModel model, ContactusDatum obj) {
    return GestureDetector(
      onTap: () {
        if (obj.directRedirectUrl != "") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebViewScreen(
                      urlString: obj.directRedirectUrl,
                    )),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ContactUsDetailsScreen(
                      model: model,
                    )),
          );
        }
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
        imageUrl:
            "https://casinovizion.com/viejasapp/images/contact_us_images/contact_us_image.jpeg",
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
