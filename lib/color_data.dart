import 'package:flutter/material.dart';

class ColorData {
  static final Map<String, Color> colorMap = {
    "白": Color(0xFFFFFFFF),
    "黒": Color(0xFF000000),

    "赤": Color(0xFFFF0000),
    "淡紅（たんこう）": Colors.red[50]!,      // Red 50 (#FFEBEE)
    "桜色（さくらいろ）": Colors.red[100]!,   // Red 100 (#FFCDD2)
    "桃色（ももいろ）": Colors.red[200]!,    // Red 200 (#EF9A9A)
    "珊瑚色（さんごいろ）": Colors.red[300]!, // Red 300 (#E57373)
    "紅梅色（こうばいいろ）": Colors.red[400]!, // Red 400 (#EF5350)
    "緋色（ひいろ）": Colors.red[500]!,      // Red 500 (#F44336)
    "赤紅（あかべに）": Colors.red[600]!,     // Red 600 (#E53935)
    "猩々緋（しょうじょうひ）": Colors.red[700]!, // Red 700 (#D32F2F)
    "紅（くれない）": Colors.red[800]!,      // Red 800 (#C62828)
    "真紅（しんく）": Colors.red[900]!,      // Red 900 (#B71C1C)
    "朱色（しゅいろ）": Colors.redAccent[100]!,  // Red A100 (#FF8A80)
    "紅緋（べにひ）": Colors.redAccent[200]!,   // Red A200 (#FF5252)
    "紅殻（べにがら）": Colors.redAccent[400]!, // Red A400 (#FF1744)
    "深紅（しんく）": Colors.redAccent[700]!,   // Red A700 (#D50000)


    "ピンクベージュ": Colors.pink[50]!,       // Pink 50 (#FCE4EC)
    "薄い桃色（うすいももいろ）": Colors.pink[100]!,   // Pink 100 (#F8BBD0)
    "ソフトピンク": Colors.pink[200]!,       // Pink 200 (#F48FB1)
    "鮮紅色（せんこうしょく）": Colors.pink[300]!,    // Pink 300 (#F06292)
    "ウォームピンク": Colors.pink[400]!,      // Pink 400 (#EC407A)
    "ピンク": Colors.pink[500]!,            // Pink 500 (#E91E63)
    "ビビッドピンク": Colors.pink[600]!,      // Pink 600 (#D81B60)
    "紅色（べにいろ）": Colors.pink[700]!,    // Pink 700 (#C2185B)
    "ダークローズ": Colors.pink[800]!,       // Pink 800 (#AD1457)
    "暗い赤": Colors.pink[900]!,            // Pink 900 (#880E4F)
    "コーラルピンク": Colors.pinkAccent[100]!,  // Pink A100 (#FF80AB)
    "チェリーピンク": Colors.pinkAccent[200]!,  // Pink A200 (#FF4081)
    "ネオンピンク": Colors.pinkAccent[400]!,   // Pink A400 (#F50057)
    "ディープマゼンタ": Colors.pinkAccent[700]!,   // Pink A700 (#C51162),

    "フクシャ": Color(0xFFFF00FF),
    "藤色（ふじいろ）": Colors.purple[50]!,     // Purple 50 (#F3E5F5)
    "薄藤（うすふじ）": Colors.purple[100]!,   // Purple 100 (#E1BEE7)
    "ラベンダー": Colors.purple[200]!,        // Purple 200 (#CE93D8)
    "紫苑色（しおんいろ）": Colors.purple[300]!, // Purple 300 (#BA68C8)
    "ライラック": Colors.purple[400]!,        // Purple 400 (#AB47BC)
    "紫（むらさき）": Colors.purple[500]!,     // Purple 500 (#9C27B0)
    "紅藤（べにふじ）": Colors.purple[600]!,  // Purple 600 (#8E24AA)
    "菫色（すみれいろ）": Colors.purple[700]!, // Purple 700 (#7B1FA2)
    "濃紫（こむらさき）": Colors.purple[800]!, // Purple 800 (#6A1B9A)
    "深紫（しんし）": Colors.purple[900]!,    // Purple 900 (#4A148C)
    "ライトバイオレット": Colors.purpleAccent[100]!, // Purple A100 (#EA80FC)
    "ビビッドパープル": Colors.purpleAccent[200]!,  // Purple A200 (#E040FB)
    "ネオンパープル": Colors.purpleAccent[400]!,   // Purple A400 (#D500F9)
    "深藤（しんふじ）": Colors.purpleAccent[700]!, // Purple A700 (#AA00FF)


    "紫": Color(0xFF800080),
    "淡藤色（たんふじいろ）": Colors.deepPurple[50]!,  // Deep Purple 50 (#EDE7F6)
    "薄藤色（うすふじいろ）": Colors.deepPurple[100]!, // Deep Purple 100 (#D1C4E9)
    "藤紫（ふじむらさき）": Colors.deepPurple[200]!,  // Deep Purple 200 (#B39DDB)
    "青紫（あおむらさき）": Colors.deepPurple[300]!,  // Deep Purple 300 (#9575CD)
    "菖蒲色（しょうぶいろ）": Colors.deepPurple[400]!, // Deep Purple 400 (#7E57C2)
    "ディープパープル": Colors.deepPurple[500]!,     // Deep Purple 500 (#673AB7)
    "濃菫色（こすみれいろ）": Colors.deepPurple[600]!, // Deep Purple 600 (#5E35B1)
    "紫紺（しこん）": Colors.deepPurple[700]!,       // Deep Purple 700 (#512DA8)
    "暗紫（あんし）": Colors.deepPurple[800]!,       // Deep Purple 800 (#4527A0)
    "黒紫（くろむらさき）": Colors.deepPurple[900]!, // Deep Purple 900 (#311B92)
    "ラベンダーパープル": Colors.deepPurpleAccent[100]!, // Deep Purple A100 (#B388FF)
    "ビビッドバイオレット": Colors.deepPurpleAccent[200]!, // Deep Purple A200 (#7C4DFF)
    "ネオンバイオレット": Colors.deepPurpleAccent[400]!, // Deep Purple A400 (#651FFF)
    "瑠璃紺（るりこん）": Colors.deepPurpleAccent[700]!,  // Deep Purple A700 (#6200EA)


    "ネイビー": Color(0xFF000080),
    "白菫色（しろすみれいろ）": Colors.indigo[50]!,  // Indigo 50 (#E8EAF6)
    "薄藍（うすあい）": Colors.indigo[100]!,      // Indigo 100 (#C5CAE9)
    "藤納戸（ふじなんど）": Colors.indigo[200]!,  // Indigo 200 (#9FA8DA)
    "青藤（あおふじ）": Colors.indigo[300]!,    // Indigo 300 (#7986CB)
    "竜胆色（りんどういろ）": Colors.indigo[400]!, // Indigo 400 (#5C6BC0)
    "インディゴ": Colors.indigo[500]!,        // Indigo 500 (#3F51B5)
    "濃藍（こいあい）": Colors.indigo[600]!,    // Indigo 600 (#3949AB)
    "深縹（ふかはなだ）": Colors.indigo[700]!,  // Indigo 700 (#303F9F)
    "藍色（あいいろ）": Colors.indigo[800]!,   // Indigo 800 (#283593)
    "濃紺（のうこん）": Colors.indigo[900]!,   // Indigo 900 (#1A237E)
    "ラベンダーブルー": Colors.indigoAccent[100]!,  // Indigo A100 (#8C9EFF)
    "ビビッドインディゴ": Colors.indigoAccent[200]!, // Indigo A200 (#536DFE)
    "ネオンブルー": Colors.indigoAccent[400]!,   // Indigo A400 (#3D5AFE)
    "ディープブルー": Colors.indigoAccent[700]!,  // Indigo A700 (#304FFE)


    "青": Color(0xFF0000FF),
    "白藍（しらあい）": Colors.blue[50]!,    // Blue 50 (#E3F2FD)
    "淡青色（たんせいしょく）": Colors.blue[100]!,   // Blue 100 (#BBDEFB)
    "空色（そらいろ）": Colors.blue[200]!,   // Blue 200 (#90CAF9)
    "縹色（はなだいろ）": Colors.blue[300]!,   // Blue 300 (#64B5F6)
    "瑠璃色（るりいろ）": Colors.blue[400]!, // Blue 400 (#42A5F5)
    "青（あお）": Colors.blue[500]!,        // Blue 500 (#2196F3)
    "千草色（千草色）": Colors.blue[600]!, // Blue 600 (#1E88E5)
    "紺碧色（こんぺきいろ）": Colors.blue[700]!, // Blue 700 (#1976D2)
    "紺青（こんじょう）": Colors.blue[800]!, // Blue 800 (#1565C0)
    "群青（ぐんじょう）": Colors.blue[900]!, // Blue 900 (#0D47A1)

    "淡水色（たんみずいろ）": Colors.lightBlue[50]!,  // Light Blue 50 (#E1F5FE)
    "薄水色（うすみずいろ）": Colors.lightBlue[100]!, // Light Blue 100 (#B3E5FC)
    "空波色（そらなみいろ）": Colors.lightBlue[200]!,    // Light Blue 200 (#81D4FA)
    "露草色（つゆくさいろ）": Colors.lightBlue[300]!, // Light Blue 300 (#4FC3F7)
    "浅碧色（せんぺきいろ）": Colors.lightBlue[400]!, // Light Blue 400 (#29B6F6)
    "ライトブルー": Colors.lightBlue[500]!,      // Light Blue 500 (#03A9F4)
    "空青色（そらあおいろ）": Colors.lightBlue[600]!, // Light Blue 600 (#039BE5)
    "薄縹（うすはなだ）": Colors.lightBlue[700]!, // Light Blue 700 (#0288D1)
    "薄花色（うすはないろ）": Colors.lightBlue[800]!, // Light Blue 800 (#0277BD)
    "濃縹（こいはなだ）": Colors.lightBlue[900]!,  // Light Blue 900 (#01579B)

    "アクア": Color(0xFF00FFFF),
    "ライトシアン": Colors.cyan[50]!,    // Cyan 50 (#E0F7FA)
    "氷清（ひょうせい）": Colors.cyan[100]!, // Cyan 100 (#B2EBF2)
    "水色（みずいろ）": Colors.cyan[200]!,    // Cyan 200 (#80DEEA)
    "天色（あまいろ）": Colors.cyan[300]!, // Cyan 300 (#4DD0E1)
    "月草色（つきくさいろ）": Colors.cyan[400]!,    // Cyan 400 (#26C6DA)
    "シアン": Colors.cyan[500]!,           // Cyan 500 (#00BCD4)
    "碧色（へきしょく）": Colors.cyan[600]!,  // Cyan 600 (#00ACC1)
    "青翡翠（あおひすい）": Colors.cyan[700]!,  // Cyan 700 (#0097A7)
    "ライトセルリアン": Colors.cyan[800]!,   // Cyan 800 (#00838F)
    "深碧（しんぺき）": Colors.cyan[900]!,    // Cyan 900 (#006064),

    "ティール": Color(0xFF008080),
    "淡碧（たんぺき）": Colors.teal[50]!,  // Teal 50 (#E0F2F1)
    "水縹（みずはなだ）": Colors.teal[100]!, // Teal 100 (#B2DFDB)
    "青磁色（せいじいろ）": Colors.teal[200]!,  // Teal 200 (#80CBC4)
    "青緑（あおみどり）": Colors.teal[300]!,  // Teal 300 (#4DB6AC)
    "ナイル青（ないるあお）": Colors.teal[400]!, // Teal 400 (#26A69A)
    "翠青（すいせい）": Colors.teal[500]!,         // Teal 500 (#009688)
    "青碧（せいへき）": Colors.teal[600]!,  // Teal 600 (#00897B)
    "パイングリーン": Colors.teal[700]!, // Teal 700 (#00796B)
    "ビリジアン": Colors.teal[800]!,      // Teal 800 (#00695C)
    "濃碧（のうへき）": Colors.teal[900]!,  // Teal 900 (#004D40)

    "緑": Color(0xFF008000),
    "淡萌葱（たんもえぎ）": Colors.green[50]!,   // Green 50 (#E8F5E9)
    "薄緑（うすみどり）": Colors.green[100]!,  // Green 100 (#C8E6C9)
    "若草色（わかくさいろ）": Colors.green[200]!, // Green 200 (#A5D6A7)
    "萌葱色（もえぎいろ）": Colors.green[300]!, // Green 300 (#81C784)
    "常磐色（ときわいろ）": Colors.green[400]!, // Green 400 (#66BB6A)
    "緑（みどり）": Colors.green[500]!,      // Green 500 (#4CAF50)
    "深緑（ふかみどり）": Colors.green[600]!, // Green 600 (#43A047)
    "千歳緑（ちとせみどり）": Colors.green[700]!, // Green 700 (#388E3C)
    "ディープビリジアン": Colors.green[800]!,     // Green 800 (#2E7D32)
    "濃緑（こいみどり）": Colors.green[900]!,  // Green 900 (#1B5E20)

    "ライム": Color(0xFF00FF00),
    "生成色（きなりいろ）": Colors.lightGreen[50]!,  // Light Green 50 (#F1F8E9)
    "薄萌黄（うすもえぎ）": Colors.lightGreen[100]!, // Light Green 100 (#DCEDC8)
    "若葉色（わかばいろ）": Colors.lightGreen[200]!, // Light Green 200 (#C5E1A5)
    "黄緑（きみどり）": Colors.lightGreen[300]!,  // Light Green 300 (#AED581)
    "苔色（こけいろ）": Colors.lightGreen[400]!,  // Light Green 400 (#9CCC65)
    "ライトグリーン": Colors.lightGreen[500]!,    // Light Green 500 (#8BC34A)
    "鶸萌黄(ひわもえぎ)": Colors.lightGreen[600]!, // Light Green 600 (#7CB342)
    "草色（くさいろ）": Colors.lightGreen[700]!, // Light Green 700 (#689F38)
    "常磐緑（ときわみどり）": Colors.lightGreen[800]!, // Light Green 800 (#558B2F)
    "濃黄緑（こいきみどり）": Colors.lightGreen[900]!,  // Light Green 900 (#33691E)

    "オリーブ": Color(0xFF808000),
    "淡黄緑（たんきみどり）": Colors.lime[50]!,  // Lime 50 (#F9FBE7)
    "黄白（きじろ）": Colors.lime[100]!,       // Lime 100 (#F0F4C3)
    "薄黄緑（うすきみどり）": Colors.lime[200]!,  // Lime 200 (#E6EE9C)
    "菜種色（なたねいろ）": Colors.lime[300]!,      // Lime 300 (#DCE775)
    "若芽色（わかめいろ）": Colors.lime[400]!,  // Lime 400 (#D4E157)
    "ライムグリーン": Colors.lime[500]!,       // Lime 500 (#CDDC39)
    "抹茶色（まっちゃいろ）": Colors.lime[600]!,  // Lime 600 (#C0CA33)
    "黄蘗色（きはだいろ）": Colors.lime[700]!,  // Lime 700 (#AFB42B)
    "オリーブグリーン": Colors.lime[800]!,     // Lime 800 (#9E9D24)
    "鶸色（ひわいろ）": Colors.lime[900]!,  // Lime 900 (#827717)

    "黄色": Color(0xFFFFFF00),
    "淡黄（たんこう）": Colors.yellow[50]!,  // Yellow 50 (#FFFDE7)
    "薄黄（うすき）": Colors.yellow[100]!,   // Yellow 100 (#FFF9C4)
    "パステルイエロー": Colors.yellow[200]!, // Yellow 200 (#FFF59D)
    "菜の花色（なのはないろ）": Colors.yellow[300]!, // Yellow 300 (#FFF176)
    "レモン色": Colors.yellow[400]!,     // Yellow 400 (#FFEE58)
    "黄（きいろ）": Colors.yellow[500]!, // Yellow 500 (#FFEB3B)
    "山吹色（やまぶきいろ）": Colors.yellow[600]!, // Yellow 600 (#FDD835)
    "鬱金色（うこんいろ）": Colors.yellow[700]!, // Yellow 700 (#FBC02D)
    "黄金色（こがねいろ）": Colors.yellow[800]!, // Yellow 800 (#F9A825)
    "黄土色（おうどいろ）": Colors.yellow[900]!,  // Yellow 900 (#F57F17)

    "ライトイエロー": Colors.amber[50]!,  // Amber 50 (#FFF8E1)
    "クリーム色": Colors.amber[100]!, // Amber 100 (#FFECB3)
    "メロンイエロー": Colors.amber[200]!, // Amber 200 (#FFE082)
    "蜜柑色（みかんいろ）": Colors.amber[300]!, // Amber 300 (#FFD54F)
    "金色（こんじき）": Colors.amber[400]!,   // Amber 400 (#FFCA28)
    "向日葵色（ひまわりいろ）": Colors.amber[500]!,    // Amber 500 (#FFC107)
    "マンゴー": Colors.amber[600]!,  // Amber 600 (#FFB300)
    "山吹茶（やまぶきちゃ）": Colors.amber[700]!, // Amber 700 (#FFA000)
    "ダークオレンジ": Colors.amber[800]!, // Amber 800 (#FF8F00)
    "ビビッドオレンジ）": Colors.amber[900]!,  // Amber 900 (#FF6F00)

    "練色（ねりいろ）": Colors.orange[50]!,  // Orange 50 (#FFF3E0)
    "薄橙（うすだいだい）": Colors.orange[100]!, // Orange 100 (#FFE0B2)
    "卵色（たまごいろ）": Colors.orange[200]!, // Orange 200 (#FFCC80)
    "雌黄（しおう）": Colors.orange[300]!, // Orange 300 (#FFB74D)
    "黄橙色（おうとうしょく）": Colors.orange[400]!, // Orange 400 (#FFA726)
    "橙（だいだい）": Colors.orange[500]!,    // Orange 500 (#FF9800)
    "深橙色（しんとうしょく）": Colors.orange[600]!, // Orange 600 (#FB8C00)
    "柿色（かきいろ）": Colors.orange[700]!,  // Orange 700 (#F57C00)
    "パーシモン": Colors.orange[800]!, // Orange 800 (#EF6C00)
    "紅柿（べにがき）": Colors.orange[900]!,  // Orange 900 (#E65100)

    "淡紅柿（たんべにがき）": Colors.deepOrange[50]!,  // Deep Orange 50 (#FBE9E7)
    "洗柿（あらいがき）": Colors.deepOrange[100]!, // Deep Orange 100 (#FFCCBC)
    "曙色（あけぼのいろ）": Colors.deepOrange[200]!,    // Deep Orange 200 (#FFAB91)
    "深朱色（しんしゅいろ）": Colors.deepOrange[300]!, // Deep Orange 300 (#FF8A65)
    "トマト": Colors.deepOrange[400]!, // Deep Orange 400 (#FF7043)
    "赤橙（あかだいだい）": Colors.deepOrange[500]!,   // Deep Orange 500 (#FF5722)
    "陽炎（かげろう）": Colors.deepOrange[600]!,   // Deep Orange 600 (#F4511E)
    "焔橙（ほむらだいだい）": Colors.deepOrange[700]!,   // Deep Orange 700 (#E64A19)
    "緋橙（ひだいだい）": Colors.deepOrange[800]!, // Deep Orange 800 (#D84315)
    "暁紅（ぎょうこう）": Colors.deepOrange[900]!,   // Deep Orange 900 (#BF360C)

    "淡褐色（たんかっしょく）": Colors.brown[50]!,  // Brown 50 (#EFEBE9)
    "薄茶（うすちゃ）": Colors.brown[100]!,       // Brown 100 (#D7CCC8)
    "シルバーピンク": Colors.brown[200]!,       // Brown 200 (#BCAAA4)
    "胡桃色（くるみいろ）": Colors.brown[300]!,   // Brown 300 (#A1887F)
    "灰赤（はいあか）": Colors.brown[400]!,   // Brown 400 (#8D6E63)
    "茶色（ちゃいろ）": Colors.brown[500]!,      // Brown 500 (#795548)
    "栗色（くりいろ）": Colors.brown[600]!,      // Brown 600 (#6D4C41)
    "檜皮色（ひわだいろ）": Colors.brown[700]!,  // Brown 700 (#5D4037)
    "海老茶（えびちゃ）": Colors.brown[800]!,    // Brown 800 (#4E342E)
    "黒茶（くろちゃ）": Colors.brown[900]!,      // Brown 900 (#3E2723)

    "銀色（ぎんいろ）": Color(0xFFC0C0C0),
    "灰色（はいいろ）": Color(0xFF808080),
    "白鼠（しろねず）": Colors.grey[50]!,   // Grey 50 (#FAFAFA)
    "薄鼠（うすねず）": Colors.grey[100]!,  // Grey 100 (#F5F5F5)
    "銀鼠（ぎんねず）": Colors.grey[200]!,  // Grey 200 (#EEEEEE)
    "灰白（かいはく）": Colors.grey[300]!,  // Grey 300 (#E0E0E0)
    "鉛色（なまりいろ）": Colors.grey[400]!, // Grey 400 (#BDBDBD)
    "錫色（すずいろ）": Colors.grey[500]!,      // Grey 500 (#9E9E9E)
    "薄墨色（うすずみいろ）": Colors.grey[600]!, // Grey 600 (#757575)
    "ねずみ色": Colors.grey[700]!,       // Grey 700 (#616161)
    "黒鼠（くろねず）": Colors.grey[800]!, // Grey 800 (#424242)
    "墨（すみ）": Colors.grey[900]!,      // Grey 900 (#212121)


    "淡青鼠（たんせいねず）": Colors.blueGrey[50]!,  // Blue Grey 50 (#ECEFF1)
    "薄青鼠（うすせいねず）": Colors.blueGrey[100]!, // Blue Grey 100 (#CFD8DC)
    "青鼠（あおねず）": Colors.blueGrey[200]!,    // Blue Grey 200 (#B0BEC5)
    "藍鼠（あいねず）": Colors.blueGrey[300]!,    // Blue Grey 300 (#90A4AE)
    "鉛青（なまりあお）": Colors.blueGrey[400]!, // Blue Grey 400 (#78909C)
    "青鈍（あおにび）": Colors.blueGrey[500]!,   // Blue Grey 500 (#607D8B)
    "濃青鼠（こいせいねず）": Colors.blueGrey[600]!, // Blue Grey 600 (#546E7A)
    "鈍色（にびいろ）": Colors.blueGrey[700]!,   // Blue Grey 700 (#455A64)
    "チャコール": Colors.blueGrey[800]!,   // Blue Grey 800 (#37474F)
    "墨青（ぼくせい）": Colors.blueGrey[900]!   // Blue Grey 900 (#263238)
  };
  static final Map<String, Map<String, Color>> themes = {
    "カラフル": {
      "primary": colorMap["橙（だいだい）"]!,
      "background": colorMap["白"]!,
      "text": colorMap["黒"]!,
    },
  };
}
