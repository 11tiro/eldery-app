import 'package:flutter/material.dart';

class CUDColorData {
  // CUD推奨のアクセントカラー（高彩度）
  static final Map<String, Color> accentColors = {
    "赤": Color(0xFFE60012),
    "オレンジ": Color(0xFFF39800),
    "黄色": Color(0xFFFFD900),
    "緑": Color(0xFF007B43),
    "青": Color(0xFF005BAC),
    "空色": Color(0xFFA0D8EF),
    "紫": Color(0xFF920783),
    "ピンク": Color(0xFFE95295),
    "茶色": Color(0xFF63452A),
  };

  // CUD推奨のベースカラー（高明度）
  static final Map<String, Color> baseColors = {
    "ライトレッド": Color(0xFFFFE4E1),
    "ライトオレンジ": Color(0xFFFFD1A5),
    "ライトイエロー": Color(0xFFFFFFC2),
    "ライトグリーン": Color(0xFFD6F5D6),
    "ライトブルー": Color(0xFFD7E8FF),
    "ライトパープル": Color(0xFFF3E8FF),
    "ライトピンク": Color(0xFFFDE6F5),
    "ライトブラウン": Color(0xFFEDE1D4),
  };

  // CUD推奨の無彩色（グレー）
  static final Map<String, Color> neutralColors = {
    "ニュートラルグレー": Color(0xFFA8A8A8),
    "ウォームグレー": Color(0xFFB3ADA0),
    "クールグレー": Color(0xFFC2CCD0),
  };

  static final Map<String, Color> highContrastTheme = {
    "primary": Colors.black,
    "background": Colors.white,
    "text": Colors.yellow,
    "button": Colors.red,
  };

  // カラーユニバーサルデザインを考慮したテーマ
  static final Map<String, Map<String, Color>> themes = {
    "白黒コントラスト": {
      "primary": baseColors["ライトレッド"]!,
      "background": neutralColors["クールグレー"]!,
      "text": baseColors["ライトブルー"]!,
      "button": accentColors["赤"]!,
      "icon": accentColors["黄色"]!,
    },
    "黄色と黒": {
      "primary": accentColors["黄色"]!,
      "background": baseColors["ライトレッド"]!,
      "text": accentColors["ピンク"]!,
      "button": baseColors["ライトグリーン"]!,
    },
    "高齢者向け": {
      "primary": accentColors["青"]!,
      "background": baseColors["ライトイエロー"]!,
      "text": neutralColors["ニュートラルグレー"]!,
      "button": accentColors["オレンジ"]!,
      "icon": accentColors["赤"]!,
    },
    "空色と白": {
      "primary": accentColors["空色"]!,
      "background": baseColors["ライトピンク"]!,
      "text": baseColors["ライトブルー"]!,
      "button": accentColors["ピンク"]!,
      "icon": accentColors["紫"]!,
    },
    "紫と黄色": {
      "primary": accentColors["紫"]!,
      "background": baseColors["ライトイエロー"]!,
      "text": baseColors["ライトオレンジ"]!,
      "button": accentColors["黄色"]!,
      "icon": accentColors["緑"]!,
    },
    "赤と緑": {
      "primary": accentColors["赤"]!,
      "background": baseColors["ライトグリーン"]!,
      "text": neutralColors["ウォームグレー"]!,
      "button": accentColors["緑"]!,
      "icon": accentColors["茶色"]!,
    },
    "黄色×青色": {
      "primary": accentColors["黄色"]!,
      "background": accentColors["青"]!,
      "text": Colors.white,
      "button": accentColors["オレンジ"]!,
      "icon": Colors.black,
    },
    "白色×赤色": {
      "primary": Colors.white,
      "background": accentColors["赤"]!,
      "text": Colors.black,
      "button": neutralColors["ニュートラルグレー"]!,
      "icon": accentColors["青"]!,
    },
  };
}
