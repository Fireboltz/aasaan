import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(this.appBarTitle)),
      body: new Container(
          child: allData.length == 0
              ? Center(
                  child: SizedBox(
                  child: new CircularProgressIndicator(),
                  height: 60,
                  width: 60,
                ))
              : new ListView.builder(
                  itemCount: allData.length,
                  itemBuilder: (_, index) {
                    return UI(allData[index].fileURL, allData[index].fileName);
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
        DocumentModel d = new DocumentModel(data[key]['Name'], data[key]['PDF']);
        allData.add(d);
      }
      setState(() {
        print('Length : ${allData.length}');
      });
    });
  }

  Widget UI(String fileName, String fileURL) {
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
    );
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

  DocumentModel(this.fileURL, this.fileName);
}
