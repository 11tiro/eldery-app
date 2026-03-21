import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'shopping/shopping_screen.dart';
import 'screens/camera_screen.dart';
import 'screens/weather_screen.dart';
import 'screens/elderly_task_screen.dart';
import 'screens/settings_screen.dart';
import 'cud_color_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String selectedTheme = prefs.getString('selectedTheme') ?? '高齢者向け';
  bool highContrast = prefs.getBool('highContrast') ?? false;

  runApp(HomeApp(selectedTheme: selectedTheme, highContrast: highContrast));
}

class HomeApp extends StatefulWidget {
  final String selectedTheme;
  final bool highContrast;

  HomeApp({required this.selectedTheme, required this.highContrast});

  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  late String _currentTheme;
  bool _highContrast = false;

  @override
  void initState() {
    super.initState();
    _currentTheme = widget.selectedTheme;
    _highContrast = widget.highContrast;
  }

  void _changeTheme(String newTheme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedTheme', newTheme);
    setState(() {
      _currentTheme = newTheme;
    });
  }

  void _toggleHighContrast(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('highContrast', value);
    setState(() {
      _highContrast = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = _highContrast
        ? CUDColorData.highContrastTheme // 高コントラスト用のテーマ
        : CUDColorData.themes[_currentTheme] ?? CUDColorData.themes['高齢者向け'];

    return MaterialApp(
      title: '在宅サポートアプリ',
      theme: ThemeData(
        primaryColor: themeColors?["primary"] ?? Colors.blue,
        scaffoldBackgroundColor: themeColors?["background"] ?? Colors.white,
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: themeColors?["text"] ?? Colors.black),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: themeColors?["primary"] ?? Colors.blue,
          foregroundColor: themeColors?["text"] ?? Colors.white,
        ),
      ),
      home: HomeScreen(changeTheme: _changeTheme, currentTheme: _currentTheme),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final Function(String) changeTheme;
  final String currentTheme;
  HomeScreen({required this.changeTheme, required this.currentTheme});

  @override
  Widget build(BuildContext context) {
    final themeColors = CUDColorData.themes[currentTheme] ?? CUDColorData.themes['高齢者向け'];
    return Scaffold(
      appBar: AppBar(
          title: Text("在宅サポートアプリ", style: TextStyle(color: themeColors?["text"] ?? Colors.white))
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [themeColors?["primary"] ?? Colors.blue, themeColors?["background"] ?? Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: GridView.count(
          padding: EdgeInsets.all(16),
          crossAxisCount: 2,
          children: [
            _buildFeatureButton(context, "買い物リスト", Icons.shopping_cart, themeColors?["button"] ?? Colors.green, ShoppingScreen()),
            _buildFeatureButton(context, "カメラ", Icons.camera_alt, themeColors?["button"] ?? Colors.green, CameraScreen()),
            _buildFeatureButton(context, "天気予報", Icons.wb_sunny, themeColors?["button"] ?? Colors.green, WeatherScreen()),
            _buildFeatureButton(context, "タスク管理", Icons.task, themeColors?["button"] ?? Colors.green, ElderlyTaskScreen()),
            _buildFeatureButton(context, "設定", Icons.settings, themeColors?["button"] ?? Colors.green, SettingsScreen(changeTheme: changeTheme, currentTheme: currentTheme)),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureButton(BuildContext context, String title, IconData icon, Color color, Widget screen) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      ),
      child: Card(
        color: color,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 60, color: Colors.white),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
