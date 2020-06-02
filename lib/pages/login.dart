import 'dart:convert';
import 'dart:io';

import 'package:noti_app/helper/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noti_app/helper/manageUser.dart';
import 'package:noti_app/pages/home.dart';
import 'package:local_auth/local_auth.dart';
import 'package:key_guardmanager/key_guardmanager.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginState();
  }
}

class _LoginState extends State<LoginPage> {
  final LocalAuthentication auth = LocalAuthentication();

  Future<void> _authenticate(context, username) async {
    bool authenticated = false;
//    bool canCheckBiometrics = await auth.canCheckBiometrics;
    bool canCheckBiometrics = false;
    if (canCheckBiometrics) {
      try {
        authenticated = await auth.authenticateWithBiometrics(
            localizedReason: 'Scan your fingerprint to authenticate',
            useErrorDialogs: true,
            stickyAuth: true);
      } on PlatformException catch (e) {
        print(e);
      }
      if (!mounted) return;
      if (authenticated) {
        await userData.save(username);
        Navigator.pushNamed(context, '/home');
      }
    } else {
      String platformAuth;
      // Platform messages may fail, so we use a try/catch PlatformException.
      try {
        platformAuth = await KeyGuardmanager.authStatus;
        if(platformAuth == 'true'){
          await userData.save(username);
          Navigator.pushNamed(context, '/home');
        }
      } on PlatformException {
        platformAuth = 'Failed to get platform auth.';
      }
    }
  }

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  var userData = manageUser();

  @override
  void initState() {
    super.initState();
    userData.readUser().then((value) {
      if (value != 0) {
        Future(() {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.3), BlendMode.dstATop),
            image: AssetImage('images/template.png'),
            fit: BoxFit.fill,
          ),
        ),
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.width / 6,
            left: 40,
            right: 40,
            bottom: MediaQuery.of(context).size.width / 6),
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: 128,
              height: 160,
              child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 40),
                      Text(
                        'Notification',
                        style: TextStyle(
                          fontSize: 50,
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  )),
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              // autofocus: true,
              keyboardType: TextInputType.text,
              controller: _usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Username",
                labelStyle: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              style: TextStyle(fontSize: 20, color: Colors.deepPurple),
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              // autofocus: true,
              keyboardType: TextInputType.text,
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Password",
                labelStyle: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              style: TextStyle(fontSize: 20, color: Colors.deepPurple),
            ),
            Container(
              height: 40,
              alignment: Alignment.centerRight,
              child: FlatButton(
                child: Text(
                  "Forgot password",
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.indigo),
                ),
                onPressed: () {},
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              height: 60,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  end: Alignment.bottomRight,
                  stops: [0.3, 1],
                  colors: [
                    Colors.deepPurple,
                    Colors.purpleAccent,
                  ],
                ),
              ),
              child: SizedBox.expand(
                child: FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  onPressed: () async {
                    var username = _usernameController.text;
                    var password = _passwordController.text;

                    if (username == '' || password == '') {
                      await dialog('Valid input!',
                          'Please enter your username and password.', context);
//                      return false;
                    } else if (username != 'test' && password != '1234') {
                      await dialog('Valid inp อut!',
                          'Your account or password is incorrect.', context);
                    } else {
                      _authenticate(context, username);
//                      await userData.save(username);
//                      Navigator.pushNamed(context, '/home');
//                      return true;
                    }
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 60,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.indigo),
              ),
              child: SizedBox.expand(
                child: FlatButton(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Register",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  onPressed: () async {
                    var data = await userData.readUser();
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
