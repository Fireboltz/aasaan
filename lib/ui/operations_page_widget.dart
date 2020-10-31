import 'package:scanbot_sdk_example_flutter/ui/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:scanbot_sdk/common_data.dart' as c;
import 'package:scanbot_sdk/cropping_screen_data.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui.dart';
import 'package:scanbot_sdk_example_flutter/ui/utils.dart';
import 'package:scanbot_sdk_example_flutter/utils/constants.dart';

import '../pages_repository.dart';
import 'filter_page_widget.dart';
import 'pages_widget.dart';

class PageOperations extends StatefulWidget {
  c.Page _page;
  final PageRepository _pageRepository;

  PageOperations(this._page, this._pageRepository);

  @override
  _PageOperationsState createState() => _PageOperationsState();
}

class _PageOperationsState extends State<PageOperations> {
  @override
  Widget build(BuildContext context) {
    imageCache.clear();
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          title: const Text('Image Preview',
              style: TextStyle(inherit: true, color: Colors.black)),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    compress(context);
                  },
                  child: Icon(
                      Icons.compress
                  ),
                )
            ),
          ],
        ),
        body: PagesPreviewWidget(widget._page, widget._pageRepository));
  }

  String _dropDownValue ="0.8";

  compress(BuildContext context) {
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
                  items: ['0.9', '0.75', '0.5', '0.25'].map(
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

  static void showProcessingDialog(BuildContext context, String message) async {
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
}

class PagesPreviewWidget extends StatefulWidget {
  c.Page page;
  final PageRepository _pageRepository;

  PagesPreviewWidget(this.page, this._pageRepository);

  @override
  State<PagesPreviewWidget> createState() {
    return new PagesPreviewWidgetState(page, this._pageRepository);
  }
}

class PagesPreviewWidgetState extends State<PagesPreviewWidget> {
  c.Page page;
  final PageRepository _pageRepository;

  PagesPreviewWidgetState(this.page, this._pageRepository);

  void _updatePage(c.Page page) {
    imageCache.clear();
    _pageRepository.updatePage(page);
    setState(() {
      this.page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
            child: Container(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Center(child: PageWidget(page.documentImageFileUri)))),
        BottomAppBar(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.crop),
                    Container(width: 4),
                    Text('Crop & Rotate',
                        style: TextStyle(inherit: true, color: Colors.black)),
                  ],
                ),
                onPressed: () {
                  startCroppingScreen(page);
                  // _settingModalBottomSheet(context, page);
                },
              ),
              FlatButton(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.filter),
                    Container(width: 4),
                    Text('Filter',
                        style: TextStyle(inherit: true, color: Colors.black)),
                  ],
                ),
                onPressed: () {
                  showFilterPage(page);
                  // _settingModalBottomSheet(context, page);
                },
              ),
              FlatButton(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.delete, color: Colors.red),
                    Container(width: 4),
                    Text('Delete',
                        style: TextStyle(inherit: true, color: Colors.red)),
                  ],
                ),
                onPressed: () {
                  deletePage(page);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  deletePage(c.Page page) async {
    try {
      await ScanbotSdk.deletePage(page);
      this._pageRepository.removePage(page);
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }

  rotatePage(c.Page page) async {
    if (!await checkLicenseStatus(context)) { return; }

    try {
      var dialog = ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      dialog.style(message: "Processing ...");
      dialog.show();
      var updatedPage = await ScanbotSdk.rotatePageClockwise(page, 1);
      dialog.hide();
      if (updatedPage != null) {
        setState(() {
          _updatePage(updatedPage);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  showFilterPage(c.Page page) async {
    if (!await checkLicenseStatus(context)) { return; }

    var resultPage = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PageFiltering(page)),
    );
    if (resultPage != null) {
      _updatePage(resultPage);
    }
  }
  startCompressingScreen(c.Page page) async {
    if (!await checkLicenseStatus(context)) { return; }

    try {

    }
    catch(e){
      print(e);
    }
  }
  startCroppingScreen(c.Page page) async {
    if (!await checkLicenseStatus(context)) { return; }

    try {
      var config = CroppingScreenConfiguration(
        bottomBarBackgroundColor: Colors.blue,
        // polygonColor: Colors.yellow,
        // polygonLineWidth: 10,
        cancelButtonTitle: "Cancel",
        doneButtonTitle: "Save",
        // See further configs ...
      );
      var result = await ScanbotSdkUi.startCroppingScreen(page, config);
      if (isOperationSuccessful(result) && result.page != null) {
        setState(() {
          _updatePage(result.page);
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
