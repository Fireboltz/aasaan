# Facilitation of Document Upload

## What does aasaan Solve ? :eyes:

* Making and uploading of documents etc. In online applications a piece of cake.
* This we are achieving by able to redirect to an app once the user clicks the upload button.
* From the app the users can take a photo of the desired documents and can upload it to the required component. by compressing it to the **required** size

## Technology Stack :star:

* [Flutter](https://flutter.dev/)
* [Firebase](https://firebase.google.com/)
* [OpenCV](https://opencv.org/)
* [Mobile vison](https://developers.google.com/vision)
* [Google auth](https://developers.google.com/identity/protocols/oauth2)
* [React](https://reactjs.org/)


## What all aasaan can do ? :thought_balloon:

Aasaan contains some of the features which will be helped to scan document and upload.

**Scanning UI** \
User guidance to the best position for capturing the document with manual + automatic photo capture of document.

**Pre-Processing of images** \
By scanning the document it will automatically process the image and give you readable documents with multiple filters.

**Perspective Correction** \
4 Point getPerspective Transform, it will automatically detect crop the image.

**Text Recognition (OCR)** \
Text Recognition is done using Mobile vision API. so, when user want to scan the Aadhar card he can automatically get the code.
 
**Online Cloud** \
We used firebase database for online cloud, if the user lost the documents also he can retrieve all of them with no time.

**File compression** \
With the help of openCV 3.0 we added the compressor, user can compress the document with the given input.

**Multiple Formats** \
The scanned image can be converted into multiple forms JPG, PDF, TiFF etc.

## How is privacy ensured? 
All files being stored in Firebase cloud, no one except with user authentication would be able to read them. 
For further clarification, when ever the user upload or download the documents it will automatically check the authentication.

## How to build and run locally?
Install [Flutter](https://flutter.dev) and all required dev tools.

Fetch this repository and navigate to the project directory.

```
cd scanbot-sdk-example-flutter/
```
Fetch and install the dependencies of this example project via Flutter CLI:

```
flutter pub get
```
Connect a mobile device via USB and run the app.

**Android:** 
```
flutter run -d <DEVICE_ID>
```
You can get the IDs of all connected devices via `flutter devices`.

**iOS:** 
Install Pods dependencies:
```
cd ios/
pod install --repo-update
```

Open the **workspace**(!) `ios/Runner.xcworkspace` in Xcode and adjust the *Signing / Developer Account* settings. 
Then build and run the app in Xcode.

## Future goals :soon:
* We plan to implement the OCR in a much more efficient way.
* The 2fa is also going to be implemented just to improve the user login security.
* We also plan to make use of the Digilocker API to
	* Fetch issued documents directly as a Digilocker copy (Requester API)
	* Store scanned documents in Digilocker as files

## Screenshots

<table border="0">
  <tr>
     <td><img src="https://user-images.githubusercontent.com/48018942/97796401-87ad6980-1c37-11eb-999a-5bbbfbb80221.png" width="300"></td>
       <td><img src="https://user-images.githubusercontent.com/48018942/97796402-87ad6980-1c37-11eb-98d7-5540c22eac6e.png" width="300"></td>
    <td><img src="https://user-images.githubusercontent.com/48018942/97796399-854b0f80-1c37-11eb-8782-ee63188f9dff.png" width="300"></td>


  </tr>
  <tr>
    <td><img src="https://user-images.githubusercontent.com/48018942/97796400-8714d300-1c37-11eb-9033-330e57ad67e2.png" width="300"></td>
    <td><img src="https://user-images.githubusercontent.com/48018942/97796403-88460000-1c37-11eb-94d6-087c6bb3fbf2.png" width="300"></td>
    <td><img src="https://user-images.githubusercontent.com/48018942/97796404-88de9680-1c37-11eb-9859-ef2911c128fc.png" width="300"></td>
  </tr>
</table>

## Developers :information_desk_person:

[Ajay Prabhakar](https://github.com/chromicle) \
[Puneeth chanda](https://github.com/puneeth2001) \
[Ashwin Ramakrishnan](https://github.com/ashwinkey04) \
[Akshay Praveen Nair](https://github.com/iammarco11) \
[Nehal Nevle](https://github.com/Blackcipher101)

