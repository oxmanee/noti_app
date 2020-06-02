import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:noti_app/helper/manageUser.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeState();
  }
}


class _HomeState extends State<HomePage> {
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String textValue = 'hello';

  Future _showNotificationWithSound() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max,
        priority: Priority.High);
    var iOSPlatformChannelSpecifics =
    new IOSNotificationDetails(sound: "slow_spring_board.aiff");
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'New Post',
      'How to Show Notification in Flutter',
      platformChannelSpecifics,
      payload: 'Custom_Sound',
    );
  }


  @override
  void initState() {

    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid  = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS  = new IOSInitializationSettings();
    var initializationSettings  = new InitializationSettings(initializationSettingsAndroid,initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    firebaseMessaging.subscribeToTopic("NEWS");
//    _showNotificationWithSound();
    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> msg) {
        print("onLaunch callled");
      },
      onResume: (Map<String, dynamic> msg) {
        print("onResume callled");
      },
      onMessage: (Map<String, dynamic> msg) {
        print("onMessange $msg");
        Map mapNotification = msg["notification"];
        String title = mapNotification["title"];
        String body = mapNotification["body"];
        print(body);
        _showNotificationWithSound();
      },
    );

    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));

    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print('Ios Setting Registed');
    });

    firebaseMessaging.getToken().then((token) {
      update(token);
    });

  }

  Future onSelectNotification(String payload){
    debugPrint("payload :  $payload");
  }

  update(String token) {
    print(token);
    textValue = token;
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          backgroundColor: Colors.deepPurple,
        ),
        drawer: Drawer(
          child: ExpansionTile(
            initiallyExpanded: true,
            title: UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              accountName: Text("Mohamed Ali"),
              accountEmail: Text("mohamed.ali6996@hotmail.com"),
              currentAccountPicture: CircleAvatar(
                child: Text("M"),
                backgroundColor: Colors.white,
              ),
            ),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: ListTile(
                    title: Text("Home Page"),
                    leading: Icon(
                      Icons.home,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, right: 30),
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
                height: 0.3,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: InkWell(
                  child: ListTile(
                      title: Text("Log out"),
                      leading: Icon(
                        Icons.assignment_return,
                        color: Colors.deepPurpleAccent,
                      ),
                      onTap: () async {
                        var manageData = manageUser();
                        await manageData.clearData();
                        firebaseMessaging.unsubscribeFromTopic("NEWS");
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/main', (Route<dynamic> route) => false);
                      }),
                ),
              ),
            ],
          ),
        ),
        body: Container());
  }
}

