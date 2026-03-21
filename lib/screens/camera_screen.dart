import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';
import 'package:elderly/color_data.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  int _selectedCameraIndex = 0;
  int _selectedFilter = 0; // 0: フィルターなし, 1: フィルター1, 2: フィルター2
  double _zoomLevel = 1.0;
  double _minZoom = 1.0;
  double _maxZoom = 1.0;
  GlobalKey _globalKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isZoomingIn = false;
  bool _isZoomingOut = false;
  bool _isFilterOn = false; // フィルターのON/OFF

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    var status = await Permission.camera.request();
    if (!status.isGranted) {
      print("カメラ権限がありません");
      return;
    }

    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        print("カメラが利用できません");
        return;
      }

      _controller = CameraController(
        _cameras![_selectedCameraIndex],
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _controller!.initialize();
      _minZoom = await _controller!.getMinZoomLevel();
      _maxZoom = await _controller!.getMaxZoomLevel();

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print("カメラの初期化に失敗しました: $e");
    }
  }

  void _switchCamera() async {
    if (_cameras == null || _cameras!.isEmpty) return;

    // 別のカメラに切り替える
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;

    // 現在のカメラを破棄
    if (_controller != null) {
      await _controller!.dispose();
    }

    // 新しいカメラをセットアップ
    _controller = CameraController(
      _cameras![_selectedCameraIndex],
      ResolutionPreset.medium,
      enableAudio: false,  // 音声を無効にする (不要なら true)
    );

    try {
      await _controller!.initialize();
      _minZoom = await _controller!.getMinZoomLevel();
      _maxZoom = await _controller!.getMaxZoomLevel();

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print("カメラの切り替えに失敗しました: $e");
    }
  }

  // フィルターを切り替える
  void _toggleFilter() {
    setState(() {
      _selectedFilter = (_selectedFilter + 1) % 3; // 0 → 1 → 2 → 0 のループ
    });
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    double newZoom = (_zoomLevel * details.scale).clamp(_minZoom, _maxZoom);
    if (newZoom != _zoomLevel) {
      _zoomLevel = newZoom;
      _controller?.setZoomLevel(_zoomLevel);
    }
  }

  void _onZoomIn() {
    setState(() {
      _zoomLevel = (_zoomLevel + 0.1).clamp(_minZoom, _maxZoom);
      _controller?.setZoomLevel(_zoomLevel);
    });
  }

  void _onZoomOut() {
    setState(() {
      _zoomLevel = (_zoomLevel - 0.1).clamp(_minZoom, _maxZoom);
      _controller?.setZoomLevel(_zoomLevel);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: Text("カメラ画面")),
      body: Column(
        children: [
          // カメラプレビューを上部に配置
          Expanded(
            child: GestureDetector(
              onScaleUpdate: _onScaleUpdate,
              onTapUp: (details) async {
                if (_controller == null || !_controller!.value.isInitialized) return;

                // タップ位置の色を取得
                RenderRepaintBoundary boundary =
                _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
                Offset localPosition = boundary.globalToLocal(details.globalPosition);

                Color? color = await _getFilteredColorAtTap(localPosition);
                if (color != null) {
                  String colorName = _getColorName(color);
                  _showColorOverlay(details.globalPosition, colorName, color);
                }
              },
              child: RepaintBoundary(
                key: _globalKey,
                child: _selectedFilter == 1
                    ? BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 0.1, sigmaY: 0.1),
                  child: ColorFiltered(
                    colorFilter: _getCustomFilter1(),
                    child: CameraPreview(_controller!),
                  ),
                )
                    : _selectedFilter == 2
                    ? BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 0.3, sigmaY: 0.3),
                  child: ColorFiltered(
                    colorFilter: _getCustomFilter2(),
                    child: CameraPreview(_controller!),
                  ),
                )
                    : CameraPreview(_controller!), // フィルターがオフの場合
              ),
            ),
          ),

          // ボタンをカメラの下に配置
          Container(
            padding: EdgeInsets.all(8), // 余白を小さくする
            color: Colors.grey[200],
            child: SingleChildScrollView( // スクロール可能にする
              scrollDirection: Axis.horizontal, // 横スクロールを許可
              child: Wrap( // 自動折り返しを有効化
                spacing: 12, // ボタン間の間隔
                runSpacing: 12, // 折り返したときの間隔
                alignment: WrapAlignment.center, // ボタンを中央に配置
                children: [
                  ElevatedButton.icon(
                    onPressed: _switchCamera,
                    icon: Icon(Icons.switch_camera, size: 30), // アイコンサイズ調整
                    label: Text("カメラ切替", style: TextStyle(fontSize: 18)), // フォントサイズ調整
                  ),
                  ElevatedButton.icon(
                    onPressed: _toggleFilter,
                    icon: Icon(Icons.filter_alt, size: 30),
                    label: Text(
                      _selectedFilter == 0 ? "フィルター1"
                          : _selectedFilter == 1 ? "フィルター2"
                          : "フィルターOFF",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _onZoomIn,
                    icon: Icon(Icons.zoom_in, size: 30),
                    label: Text("ズームイン", style: TextStyle(fontSize: 18)),
                  ),
                  ElevatedButton.icon(
                    onPressed: _onZoomOut,
                    icon: Icon(Icons.zoom_out, size: 30),
                    label: Text("ズームアウト", style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ColorFilter _getCustomFilter1() {
    return ColorFilter.matrix([
      1.7, 0.0, 0.0, 0.0, -25.5,
      0.0, 1.7, 0.0, 0.0, -25.5,
      0.0, 0.0, 1.7, 0.0, -25.5,
      0.0, 0.0, 0.0, 1.0, 0.0,
    ]);
  }

  ColorFilter _getCustomFilter2() {
    return ColorFilter.matrix([
      1.04, 0.00, 0.00, 0.00, 0.0,
      0.00, 1.12, 0.00, 0.00, 0.0,
      0.00, 0.00, 2.20, 0.00, 0.0,
      0.00, 0.00, 0.00, 1.08, -53.55,
    ]);
  }

// フィルターが適用された領域の色を取得
  Future<Color?> _getFilteredColorAtTap(Offset position) async {
    RenderRepaintBoundary boundary =
    _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) return null;

    Uint8List bytes = byteData.buffer.asUint8List();
    int index = ((position.dy.toInt() * image.width) + position.dx.toInt()) * 4;
    return Color.fromARGB(255, bytes[index], bytes[index + 1], bytes[index + 2]);
  }



  String _getColorName(Color color) {
    double minDistance = double.infinity;
    String closestColor = "不明";
    String primaryColor = "不明";

    // 主要な色を判定
    for (var entry in primaryColors.entries) {
      double distance = _colorDistance(color, entry.value);
      if (distance < minDistance) {
        minDistance = distance;
        primaryColor = entry.key;
      }
    }

    // 詳細な色を判定
    minDistance = double.infinity;
    String closestDetailColor = "不明";
    for (var entry in ColorData.colorMap.entries) {
      double distance = _colorDistance(color, entry.value);
      if (distance < minDistance) {
        minDistance = distance;
        closestDetailColor = entry.key;
      }
    }
    return "カテゴリ：$primaryColor（$closestDetailColor）";
  }

  void _showColorOverlay(Offset position, String colorName, Color color) {
    _overlayEntry?.remove();

    // 主要な色と詳細な色を分ける
    List<String> colorParts = colorName.split("（");
    String mainColor = colorParts[0]; // 主要な色
    String detailColor = colorParts.length > 1 ? colorParts[1].replaceAll("）", "") : ""; // 詳細な色

    // 似ている色を取得
    List<String> similarColors = _findSimilarColors(color);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx,
        top: position.dy,
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 色を表示するボックス
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 詳細な色（大きく、太字）
                        if (detailColor.isNotEmpty)
                          Text(
                            detailColor,
                            style: TextStyle(
                              fontSize: 20, // **大きくする**
                              fontWeight: FontWeight.bold, // **太字にする**
                            ),
                          ),
                        // 主要な色（小さく、補足的に）
                        Text(
                          mainColor,
                          style: TextStyle(
                            fontSize: 14, // **小さくする**
                            color: Colors.grey, // **補足的にグレー**
                          ),
                        ),
                        // 似ている色（小さく）
                        if (similarColors.isNotEmpty)
                          Text(
                            "似た色: ${similarColors.join("、")}",
                            style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    // 一定時間後に削除
    Future.delayed(Duration(seconds: 3), () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _controller?.dispose();
    _controller = null; // **明示的に null にする**
    super.dispose();
  }

  List<String> _findSimilarColors(Color color) {
    List<MapEntry<String, Color>> colorEntries = ColorData.colorMap.entries.toList();

    // 色の距離が近い順にソート
    colorEntries.sort((a, b) => _colorDistance(color, a.value).compareTo(_colorDistance(color, b.value)));

    // 上位3つの似ている色を取得（主要な色は除外）
    List<String> similarColors = [];
    for (int i = 0; i < colorEntries.length && similarColors.length < 3; i++) {
      if (!primaryColors.containsKey(colorEntries[i].key)) {
        similarColors.add(colorEntries[i].key);
      }
    }

    return similarColors;
  }

  // ユークリッド距離を使って色の近さを計算
  double _colorDistance(Color c1, Color c2) {
    return ((c1.red - c2.red) * (c1.red - c2.red) +
        (c1.green - c2.green) * (c1.green - c2.green) +
        (c1.blue - c2.blue) * (c1.blue - c2.blue))
        .toDouble();
  }

  Map<String, Color> primaryColors = {
    "赤": Colors.red,
    "青": Colors.blue,
    "黄": Colors.yellow,
    "緑": Colors.green,
    "紫": Colors.purple,
    "橙": Colors.orange,
    "黒": Colors.black,
    "白": Colors.white,
    "灰色": Colors.grey,
    "ピンク": Colors.pink,
    "茶色": Colors.brown,
    "水色": Colors.lightBlue,
    "ライム": Colors.lime,
    "ネイビー": Colors.indigo,
    "ターコイズ": Colors.teal,
    "その他": Colors.blueGrey,  // その他のカテゴリを追加
  };
}
