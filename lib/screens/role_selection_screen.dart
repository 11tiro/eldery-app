import 'package:flutter/material.dart'; //FlutterのUIライブラリ
import 'package:intl/intl.dart';
import 'dart:async';

class RoleSelectionScreen extends StatefulWidget {
  @override
  _RoleSelectionScreenState createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  late String currentTime; // 時刻を格納する変数
  late String currentDate; // 日付を格納する変数
  late Timer _timer; // タイマー

  @override
  void initState() {
    super.initState();

    // 初期時刻と日付を設定
    currentDate = DateFormat('yyyy/MM/dd').format(DateTime.now());
    currentTime = DateFormat('HH:mm:ss').format(DateTime.now());

    // タイマーで1秒ごとに時刻を更新
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // タイマーの解放
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ホーム画面'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              currentDate, // 日付表示
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10),
            Text(
              currentTime, // 時刻表示
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 30), // 少し余白を作って画面が重ならないようにする
          ],
        ),
      ),
    );
  }
}
