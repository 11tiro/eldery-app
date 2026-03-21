import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  final String weatherCondition; // 天気状態を追加

  const Background({
    Key? key,
    required this.child,
    required this.weatherCondition, // 追加
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 天気に応じた背景画像を選択
    String imagePath;
    switch (weatherCondition) {
      case 'clear':
        imagePath = 'assets/sunny.jpg'; // 晴れの背景画像
        break;
      case 'rain':
        imagePath = 'assets/rainy.jpg'; // 雨の背景画像
        break;
      case 'snow':
        imagePath = 'assets/snowy.jpg'; // 雪の背景画像
        break;
      case 'cloud':
      default:
        imagePath = 'assets/cloudy.jpg'; // 曇りの背景画像
        break;
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
