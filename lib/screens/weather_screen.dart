import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'regions.dart';  // 都道府県の気象台コードを定義したファイル

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String _forecastText = "都道府県を選択し、ボタンを押してください。";
  String _selectedRegion = "東京都";  // 初期値
  String _weatherCondition = 'clear'; // 天気状態
  String _laundryAdvice = "情報なし"; // 洗濯情報

  Future<void> _fetchWeather() async {
    if (!regionCodes.containsKey(_selectedRegion)) {
      setState(() {
        _forecastText = "選択した地域の天気情報が取得できません。";
      });
      return;
    }

    String regionCode = regionCodes[_selectedRegion]!;

    var forecastUrl = Uri.parse('https://www.jma.go.jp/bosai/forecast/data/forecast/$regionCode.json');
    var forecastRequest = await http.get(forecastUrl);
    if (forecastRequest.statusCode != 200) {
      setState(() {
        _forecastText = "天気詳細の取得に失敗しました";
      });
      return;
    }
    var forecastJson = const Utf8Decoder().convert(forecastRequest.bodyBytes);
    var forecastList = jsonDecode(forecastJson) as List;

    if (forecastList.isEmpty) {
      setState(() {
        _forecastText = "天気情報が見つかりませんでした";
      });
      return;
    }

    var weatherData = forecastList[0]['timeSeries'][0]['areas'][0];
    String weatherToday = weatherData['weathers'][0];

    // 天気状態を設定（背景変更＆洗濯指数のため）
    if (weatherToday.contains('晴')) {
      _weatherCondition = 'clear';
      _laundryAdvice = "洗濯日和！すぐ乾きます！"; // ☀️ 晴れ
    } else if (weatherToday.contains('曇')) {
      _weatherCondition = 'cloud';
      _laundryAdvice = "乾きにくいので部屋干し推奨"; // ⛅ 曇り
    } else if (weatherToday.contains('雨')) {
      _weatherCondition = 'rain';
      _laundryAdvice = "部屋干し or 乾燥機を使いましょう"; // 🌧️ 雨
    } else if (weatherToday.contains('雪')) {
      _weatherCondition = 'snow';
      _laundryAdvice = "外干しは厳しいです。部屋干しを推奨"; // ❄️ 雪
    } else {
      _weatherCondition = 'cloud';
      _laundryAdvice = "天気が不安定なので注意"; // その他の天気
    }

    setState(() {
      _forecastText =
      "【$_selectedRegion の天気】\n"
          "今日の天気: $weatherToday\n"
          "洗濯情報: $_laundryAdvice\n";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('天気予報')),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_getBackgroundImage()), // 背景画像
            fit: BoxFit.cover, // 全画面に適用
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  DropdownButton<String>(
                    value: _selectedRegion,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRegion = newValue!;
                      });
                    },
                    items: regionCodes.keys.map((String key) {
                      return DropdownMenuItem<String>(
                        value: key,
                        child: Text(key),
                      );
                    }).toList(),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    child: const Text('天気情報取得'),
                    onPressed: _fetchWeather,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        _forecastText,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 天気に応じた背景画像を取得
  String _getBackgroundImage() {
    if (_weatherCondition == 'clear') {
      return "assets/images/clear.png"; // 晴れ
    } else if (_weatherCondition == 'rain') {
      return "assets/images/rain.png"; // 雨
    } else if (_weatherCondition == 'snow') {
      return "assets/images/snow.png"; // 雪
    } else {
      return "assets/images/cloud.png"; // 曇り
    }
  }
}
