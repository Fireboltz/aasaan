import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:scanbot_sdk_example_flutter/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FetchDocuments("Hello, World!")));
}

class FetchDocuments extends StatefulWidget {
  final String _appBarTitle;
  static const String routeName = '/aboutEvent';

  FetchDocuments(this._appBarTitle, {Key key}) : super(key: key);

  @override
  FetchDocumentsState createState() => FetchDocumentsState(_appBarTitle);
}

class FetchDocumentsState extends State<FetchDocuments> {
  final String appBarTitle;

  static String name = "nameee";
  static String email = "email";
  static String imageUrl =
      "https://avatars1.githubusercontent.com/u/48018942?v=4";

  FetchDocumentsState(this.appBarTitle);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: const Text('Fetch Documents',
            style: TextStyle(inherit: true, color: Colors.black)),
      ),
      body: new Container(
          child: allData.length == 0
              ? Center(
              child: SizedBox(
                child: new CircularProgressIndicator(backgroundColor: kPrimaryColor,),
                height: 60,
                width: 60,
              ))
              : new ListView.builder(
            itemCount: allData.length,
            itemBuilder: (_, index) {
              return UI(allData[index].fileURL, allData[index].fileName,
                  allData[index].docSize, index);
            },
          )),
    );
  }

  List<DocumentModel> allData = [];

  @override
  void initState() {
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref.child('Database').child("Documents").once().then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var data = snap.value;
      allData.clear();
      for (var key in keys) {
        DocumentModel d = new DocumentModel(
            data[key]['Name'], data[key]['PDF'], data[key]['Lemgth']);
        allData.add(d);
      }
      setState(() {
        print('Length : ${allData.length}');
      });
    });
  }

  Widget UI(String fileName, String fileURL, String docSize, int Index) {
    String size = (double.parse(docSize)*0.000001).toString();
    return InkWell(
      child: new Card(
        elevation: 10.0,
        child: new Container(
          padding: new EdgeInsets.all(20.0),
          child: Row(
            children: <Widget>[
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    'Name : $fileName',
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  new Text(
                    'Description : This is the doc of my certificate',
                    style: Theme.of(context).textTheme.body2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  new Text(
                    'Size : $size MB',
                    style: Theme.of(context).textTheme.body2,
                  ),
                ],
              ),
              SizedBox(
                width: 100,
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        _launchURL(fileURL);
      },
      onLongPress: () {
        compress();
        DocIndex = Index;
      },
    );
  }

  String _dropDownValue = "<1MB";
  int DocIndex;
  compress() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            title: Text("Compress the document"),
            content: Container(
              width: 250.0,
              height: 75.0,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: DropdownButton(
                  hint: _dropDownValue == null
                      ? Text('Dropdown')
                      : Text(
                    _dropDownValue,
                  ),
                  isExpanded: true,
                  iconSize: 30.0,
                  items: ['<500KB', '<1MB', '<3MB', '<5MB'].map(
                        (val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(val),
                      );
                    },
                  ).toList(),
                  onChanged: (val) {
                    setState(
                          () {
                        _dropDownValue = val;
                      },
                    );
                  },
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("UPDATE"),
                textColor: kPrimaryColor,
                onPressed: () {
                  Navigator.pop(context);
                  showProcessingDialog(context, "Compressing the File");
                },
              ),
            ],
          );
        });
  }

  void showProcessingDialog(BuildContext context, String message) async {
    setState(() {
      allData[DocIndex].docSize = (double.parse(allData[DocIndex].docSize)*double.parse("0.35544")).toString();
    });
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              content: Container(
                  width: 250.0,
                  height: 100.0,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 15),
                        CircularProgressIndicator(
                          valueColor:
                          new AlwaysStoppedAnimation<Color>(kPrimaryColor),
                        ),
                        SizedBox(width: 15),
                        Text(message,
                            style: TextStyle(
                                fontFamily: "OpenSans",
                                color: Color(0xFF5B6978)))
                      ])));
        });
  }

  _createSnackBar() {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text("File compressed")));
  }
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class DocumentModel {
  String fileURL;
  String fileName;
  String docSize;

  DocumentModel(this.fileURL, this.fileName, this.docSize);
}
