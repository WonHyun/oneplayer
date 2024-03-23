import 'dart:io';

import 'package:flutter/material.dart';
import 'package:oneplayer/pages/main_page.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  // 저장소 접근 권한 상태 확인
  var status = await Permission.manageExternalStorage.status;
  if (!status.isGranted) {
    // 저장소 접근 권한 요청
    await Permission.manageExternalStorage.request();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid || Platform.isIOS) {
    await requestPermissions();
  }
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
