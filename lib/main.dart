import 'dart:io';

import 'package:flutter/material.dart';
import 'package:oneplayer/pages/main_page.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  //TODO: implement seperate screen
  if (Platform.isAndroid || Platform.isIOS) {
    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      await Permission.manageExternalStorage.request();
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: MainPage(),
        ),
      ),
    );
  }
}
