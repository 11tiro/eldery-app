import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:elderly/cud_color_data.dart';

class SettingsScreen extends StatefulWidget {
  final Function(String) changeTheme;
  final String currentTheme;

  SettingsScreen({required this.changeTheme, required this.currentTheme});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String _selectedTheme;
  bool _highContrast = false;
  double _tapSensitivity = 1.0; // 初期値（1.0=通常のタップ感度）

  @override
  void initState() {
    super.initState();
    _selectedTheme = widget.currentTheme;
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _highContrast = prefs.getBool('highContrast') ?? false;
      _tapSensitivity = prefs.getDouble('tapSensitivity') ?? 1.0;
    });
  }

  void _saveTheme(String newTheme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedTheme', newTheme);
    widget.changeTheme(newTheme);
    setState(() {
      _selectedTheme = newTheme;
    });
  }

  void _toggleHighContrast(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('highContrast', value);
    setState(() {
      _highContrast = value;
    });
  }

  void _changeTapSensitivity(double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('tapSensitivity', value);
    setState(() {
      _tapSensitivity = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('設定画面'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // テーマ変更
            Text('テーマを選択', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: CUDColorData.themes.containsKey(_selectedTheme) ? _selectedTheme : CUDColorData.themes.keys.first,
              items: CUDColorData.themes.keys.map((String key) {
                return DropdownMenuItem<String>(
                  value: key,
                  child: Text(key),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  _saveTheme(newValue);
                }
              },
            ),
            SizedBox(height: 20),

            // 高コントラストモードの切り替え
            SwitchListTile(
              title: Text('高コントラストモード'),
              subtitle: Text('文字やボタンのコントラストを強調します'),
              value: _highContrast,
              onChanged: _toggleHighContrast,
            ),

            SizedBox(height: 20),

            // タップ感度の調整
            Text('タップ感度の調整', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Slider(
              value: _tapSensitivity,
              min: 0.5,
              max: 2.0,
              divisions: 3,
              label: _tapSensitivity.toStringAsFixed(1),
              onChanged: _changeTapSensitivity,
            ),
            Text(
              '感度: ${_tapSensitivity.toStringAsFixed(1)} (1.0 = 標準, 2.0 = 誤タップ防止)',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
