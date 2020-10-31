import 'dart:convert';
import 'dart:io';

import 'package:scanbot_sdk_example_flutter/ui/preview_document_widget.dart';
import 'package:scanbot_sdk_example_flutter/ui/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scanbot_sdk/barcode_scanning_data.dart';
import 'package:scanbot_sdk/common_data.dart';
import 'package:scanbot_sdk/document_scan_data.dart';
import 'package:scanbot_sdk/ehic_scanning_data.dart';
import 'package:scanbot_sdk/mrz_scanning_data.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk_models.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'pages_repository.dart';
import 'ui/utils.dart';
import 'utils/size_config.dart';
import 'package:image_picker/image_picker.dart';
import 'utils/constants.dart';

void main() => runApp(MyApp());

const SCANBOT_SDK_LICENSE_KEY =   "OKrw3WYY6sSqn1988qBvNx7ysqB+2t" +
    "gqE9dRCLQCp4rbHI3yQKIZhYvNzpcV" +
    "dottRDWpCqWfBeD2AoHqInqwMhGuUH" +
    "boGprarcbTIyZIeMOrNnzU0OoZoAFG" +
    "SVOlAuo6WDloNiD2yIkWwZo54qFwwC" +
    "fFLaigqHC/4cK3YpnvoWBkzb9uO+Dy" +
    "o8Jx4zMKgmGlG57ISWeZsKWyEuwPV1" +
    "uuVfv2sZCn6WHQTBbPOtV9R1N0cgnz" +
    "IFINSKqKPpqyEEdYmCtV8OzkR/M9pV" +
    "W88Oy/I4rwxsWOObUUpOvPqTARQ3w4" +
    "HC7ozrxijk86is14C7/UKo2+oOXfpe" +
    "iCeuY3ieFVMw==\nU2NhbmJvdFNESw" +
    "pjb20uZXhhbXBsZS5hYXNhYW4KMTYw" +
    "Njc4MDc5OQo1OTAKMw==\n";


initScanbotSdk() async {
  // Consider adjusting this optional storageBaseDirectory - see the comments below.
  var customStorageBaseDirectory = await getDemoStorageBaseDirectory();

  var config = ScanbotSdkConfig(
      loggingEnabled:
          true, // Consider switching logging OFF in production builds for security and performance reasons.
      licenseKey: SCANBOT_SDK_LICENSE_KEY,
      imageFormat: ImageFormat.JPG,
      imageQuality: 80,
      storageBaseDirectory: customStorageBaseDirectory,
      documentDetectorMode: DocumentDetectorMode.ML_BASED);

  try {
    await ScanbotSdk.initScanbotSdk(config);
  } catch (e) {
    print(e);
  }
}

Future<String> getDemoStorageBaseDirectory() async {
  // !! Please note !!
  // It is strongly recommended to use the default (secure) storage location of the Scanbot SDK.
  // However, for demo purposes we overwrite the "storageBaseDirectory" of the Scanbot SDK by a custom storage directory.
  //
  // On Android we use the "ExternalStorageDirectory" which is a public(!) folder.
  // All image files and export files (PDF, TIFF, etc) created by the Scanbot SDK in this demo app will be stored
  // in this public storage directory and will be accessible for every(!) app having external storage permissions!
  // Again, this is only for demo purposes, which allows us to easily fetch and check the generated files
  // via Android "adb" CLI tools, Android File Transfer app, Android Studio, etc.
  //
  // On iOS we use the "ApplicationDocumentsDirectory" which is accessible via iTunes file sharing.
  //
  // For more details about the storage system of the Scanbot SDK Flutter Plugin please see our docs:
  // - https://scanbotsdk.github.io/documentation/flutter/
  //
  // For more details about the file system on Android and iOS we also recommend to check out:
  // - https://developer.android.com/guide/topics/data/data-storage
  // - https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/FileSystemOverview/FileSystemOverview.html

  Directory storageDirectory;
  if (Platform.isAndroid) {
    storageDirectory = await getExternalStorageDirectory();
  } else if (Platform.isIOS) {
    storageDirectory = await getApplicationDocumentsDirectory();
  } else {
    throw ("Unsupported platform");
  }

  return "${storageDirectory.path}/my-custom-storage";
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() {
    initScanbotSdk();
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPageWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPageWidget extends StatefulWidget {
  @override
  _MainPageWidgetState createState() => _MainPageWidgetState();
}

class _MainPageWidgetState extends State<MainPageWidget> {
  PageRepository _pageRepository = PageRepository();
  IconData panelIcon = Icons.keyboard_arrow_up;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: kWhite,
          body: SlidingUpPanel(
            color: Colors.grey[200],
            minHeight: 150,
            maxHeight: MediaQuery. of(context).size.height*0.55,
            borderRadius: BorderRadius.circular(30),
            onPanelClosed: (){
              panelIcon = Icons.keyboard_arrow_up;
              setState(() {
              });
            },
            onPanelOpened: (){
              panelIcon = Icons.keyboard_arrow_down;
              setState(() {
              });
              },
            panel: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    panelIcon,
                    size: 30,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ButtonTheme(
                      height: 80,
                      shape: CircleBorder(),
                      child: RaisedButton(
                        elevation: 10,
                        child: Icon(Icons.camera_alt,
                        size: 45,
                        color:  kPrimaryColor,),
                        onPressed: () => startDocumentScanning(),
                        color: Colors.white,
                      ),
                    ),
                    ButtonTheme(
                      minWidth: 60,
                      height: 60,
                      shape: CircleBorder(),
                      child: RaisedButton(
                        elevation: 10,
                        child: Icon(
                          Icons.filter,
                          size: 20,
                          color:kPrimaryColor,
                        ),
                        onPressed: () => importImage(),
                        color: kWhite,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () => gotoImagesView(),
                  child: Container(
                    width: MediaQuery. of(context).size.width * 0.9,
                    height: 50,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text(
                        'VIEW RESULTS',
                        style: TextStyle(color: kWhite, fontSize: 19),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () => startBarcodeScanner(),
                  child: Container(
                    width: MediaQuery. of(context).size.width * 0.9,
                    height: 50,
                    decoration:BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text(
                          'BARCODE SCANNER',
                        style: TextStyle(color: kWhite, fontSize: 19),

                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () => startQRScanner(),
                  child: Container(
                    width: MediaQuery. of(context).size.width * 0.9,
                    height: 50,
                    decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text(
                          'QR SCANNER',
                          style: TextStyle(color: kWhite, fontSize: 19),
                      ),
                    ),
                  ),
                )

              ],
            ),
            body: Column(
              children: [
                SizedBox(height: 80,),
                Text(
                  "AASAN",
                  style: TextStyle(
                    fontSize: 36,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Scan karo, Upload karo",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 80,),
                Image.asset(
                  'img/doc.png',
                  height: 300,
                  width: 400,
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          )
      ),
    );
  }

  // Widget oldHome() {
  //   return ListView(
  //     children: <Widget>[
  //       TitleItemWidget("Document Scanner"),
  //       MenuItemWidget(
  //         "Scan Document",
  //         onTap: () {
  //           startDocumentScanning();
  //         },
  //       ),
  //       MenuItemWidget(
  //         "Import Image",
  //         onTap: () {
  //           importImage();
  //         },
  //       ),
  //       MenuItemWidget(
  //         "View Image Results",
  //         endIcon: Icons.keyboard_arrow_right,
  //         onTap: () {
  //           gotoImagesView();
  //         },
  //       ),
  //       TitleItemWidget("Data Detectors"),
  //       MenuItemWidget(
  //         "Scan Barcode (all formats: 1D + 2D)",
  //         onTap: () {
  //           startBarcodeScanner();
  //         },
  //       ),
  //       MenuItemWidget(
  //         "Scan QR code (QR format only)",
  //         onTap: () {
  //           startQRScanner();
  //         },
  //       ),
  //       MenuItemWidget(
  //         "Scan MRZ (Machine Readable Zone)",
  //         onTap: () {
  //           startMRZScanner();
  //         },
  //       ),
  //       MenuItemWidget(
  //         "Scan EHIC (European Health Insurance Card)",
  //         onTap: () {
  //           startEhicScanner();
  //         },
  //       ),
  //       TitleItemWidget("Test other SDK API methods"),
  //       MenuItemWidget(
  //         "getLicenseStatus()",
  //         startIcon: Icons.phonelink_lock,
  //         onTap: () {
  //           getLicenseStatus();
  //         },
  //       ),
  //       MenuItemWidget(
  //         "getOcrConfigs()",
  //         startIcon: Icons.settings,
  //         onTap: () {
  //           getOcrConfigs();
  //         },
  //       ),
  //     ],
  //   );
  // }

  getOcrConfigs() async {
    try {
      var result = await ScanbotSdk.getOcrConfigs();
      showAlertDialog(context, jsonEncode(result), title: "OCR Configs");
    } catch (e) {
      print(e);
      showAlertDialog(context, "Error getting license status");
    }
  }

  getLicenseStatus() async {
    try {
      var result = await ScanbotSdk.getLicenseStatus();
      showAlertDialog(context, jsonEncode(result), title: "License Status");
    } catch (e) {
      print(e);
      showAlertDialog(context, "Error getting OCR configs");
    }
  }

  importImage() async {
    try {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      await createPage(image.uri);
      gotoImagesView();
    } catch (e) {
      print(e);
    }
  }

  createPage(Uri uri) async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    var dialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    dialog.style(message: "Processing");
    dialog.show();
    try {
      var page = await ScanbotSdk.createPage(uri, false);
      page = await ScanbotSdk.detectDocument(page);
      this._pageRepository.addPage(page);
    } catch (e) {
      print(e);
    } finally {
      dialog.hide();
    }
  }

  startDocumentScanning() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    DocumentScanningResult result;
    try {
      var config = DocumentScannerConfiguration(
        bottomBarBackgroundColor: Colors.blue,
        ignoreBadAspectRatio: true,
        multiPageEnabled: true,
        //maxNumberOfPages: 3,
        //flashEnabled: true,
        //autoSnappingSensitivity: 0.7,
        cameraPreviewMode: CameraPreviewMode.FIT_IN,
        orientationLockMode: CameraOrientationMode.PORTRAIT,
        //documentImageSizeLimit: Size(2000, 3000),
        cancelButtonTitle: "Cancel",
        pageCounterButtonTitle: "%d Page(s)",
        textHintOK: "Perfect, don't move...",
        //textHintNothingDetected: "Nothing",
        // ...
      );
      result = await ScanbotSdkUi.startDocumentScanner(config);
    } catch (e) {
      print(e);
    }

    if (isOperationSuccessful(result)) {
      _pageRepository.addPages(result.pages);
      gotoImagesView();
    }
  }

  startBarcodeScanner() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    try {
      var config = BarcodeScannerConfiguration(
        topBarBackgroundColor: Colors.blue,
        finderTextHint:
            "Please align any supported barcode in the frame to scan it.",
        // ...
      );
      var result = await ScanbotSdkUi.startBarcodeScanner(config);
      _showBarcodeScanningResult(result);
    } catch (e) {
      print(e);
    }
  }

  startQRScanner() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    try {
      var config = BarcodeScannerConfiguration(
        barcodeFormats: [BarcodeFormat.QR_CODE],
        finderTextHint: "Please align a QR code in the frame to scan it.",
        // ...
      );
      var result = await ScanbotSdkUi.startBarcodeScanner(config);
      _showBarcodeScanningResult(result);
    } catch (e) {
      print(e);
    }
  }

  _showBarcodeScanningResult(final BarcodeScanningResult result) {
    if (isOperationSuccessful(result)) {
      var mapped = result.barcodeItems
          .map((e) => (e.barcodeFormat.toString() + ": " + e.text + "\n"))
          .toString();
      showAlertDialog(context, mapped, title: "Barcode Result:");
    }
  }

  startEhicScanner() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    HealthInsuranceCardRecognitionResult result;
    try {
      var config = HealthInsuranceScannerConfiguration(
        topBarBackgroundColor: kPrimaryColor,
        topBarButtonsColor: Colors.white70,
        // ...
      );
      result = await ScanbotSdkUi.startEhicScanner(config);
    } catch (e) {
      print(e);
    }

    if (isOperationSuccessful(result) && result?.fields != null) {
      var concatenate = StringBuffer();
      result.fields
          .map((field) =>
              "${field.type.toString().replaceAll("HealthInsuranceCardFieldType.", "")}:${field.value}\n")
          .forEach((s) {
        concatenate.write(s);
      });
      showAlertDialog(context, concatenate.toString());
    }
  }

  startMRZScanner() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    MrzScanningResult result;
    try {
      var config = MrzScannerConfiguration(
        topBarBackgroundColor: kPrimaryColor,
        // ...
      );
      result = await ScanbotSdkUi.startMrzScanner(config);
    } catch (e) {
      print(e);
    }

    if (isOperationSuccessful(result)) {
      var concatenate = StringBuffer();
      result.fields
          .map((field) =>
              "${field.name.toString().replaceAll("MRZFieldName.", "")}:${field.value}\n")
          .forEach((s) {
        concatenate.write(s);
      });
      showAlertDialog(context, concatenate.toString());
    }
  }

  gotoImagesView() async {
    imageCache.clear();
    return await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => DocumentPreview(_pageRepository)),
    );
  }

  Color hex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}
