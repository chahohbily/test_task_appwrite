import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_and_appwrite/my_app.dart';

Client client = Client();
Storage? storage = Storage(client);
Session? session;
User? user;
FileList? file;
Realtime realtime = Realtime(client);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  client
          .setEndpoint('http://192.168.0.108:80/v1') // Your Appwrite Endpoint
          .setProject('62e38d16e59eb48c29e0') // Your project ID
      ;
  Account account = Account(client);

  try {
    user = await account.get(); // данные аккаунта
    if (user == null) {}
  } on Exception catch (e) {
    try {
      session = await account.createEmailSession(
          email: 'alex@test.com', password: '12345678'); //создание сессии
      user = await account.get(); // данные аккаунта
      if (user == null) {}
    } on Exception catch (e) {
      log('session error');
      log(e.toString());
    }
    log('get error');
    log(e.toString());
  }

  try {
    file = await storage!.listFiles(bucketId: '62e7971e274a1754cf4f');
    log(file!.total.toString());
  } on Exception catch (e) {
    log('get list file error');
    log(e.toString());
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Widget> files = [];
  bool isEdit = false;
  bool isDelete = false;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyAppSceen(),
    );
  }
}
