// Copyright (c) 2020 Chromicle(ajayprabhakar369@gmail.com)

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:scanbot_sdk_example_flutter/main.dart';
import 'package:scanbot_sdk_example_flutter/ui/sign_in.dart';
import 'package:scanbot_sdk_example_flutter/utils/constants.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String textValue = 'Hello World !';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 80,),
              Text(
                "AASAAN",
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
              _googleSignInButton()
            ],
          ),
        ),
      ),
    );
  }

  update(String token) {
    print(token);
    DatabaseReference databaseReference = new FirebaseDatabase().reference();
    databaseReference.child('fcm-token/${token}').set({"token": token});
    textValue = token;
    setState(() {});
  }


  Widget _googleSignInButton() {
    return InkWell(
      onTap: () {
        signInWithGoogle().whenComplete(() async {
          if (await FirebaseAuth.instance.currentUser() != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return MainPageWidget();
                },
              ),
            );
          }
        });
      },
      child: Container(
        width: MediaQuery. of(context).size.width * 0.9,
        height: 50,
        decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('img/google_logo.png',
            width: 25,
            height: 25),
            SizedBox(width: 20,),
            Text(
              'SIGN IN',
              style: TextStyle(color: kWhite, fontSize: 19),
            ),
          ],
        ),
      ),
    );
  }
}