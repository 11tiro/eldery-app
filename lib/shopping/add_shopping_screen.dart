import 'package:flutter/material.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'shopping_data.dart'; // 商品のカテゴリ情報などを管理しているファイル
import 'production_list_screen.dart';
import 'global_data.dart';

class AddShoppingScreen extends StatefulWidget {
  final DateTime? preSelectedDate;
  AddShoppingScreen({this.preSelectedDate});

  @override
  _AddShoppingScreenState createState() => _AddShoppingScreenState();
}

class _AddShoppingScreenState extends State<AddShoppingScreen> {
  List<Map<String, dynamic>> _shoppingList = [];
  List<Map<String, dynamic>> _filteredShoppingList = []; // 検索結果用リスト
  List<Map<String, dynamic>> _allItems = []; // ✅ すべての商品リストを保持
  TextEditingController _titleController = TextEditingController();
  TextEditingController _searchController = TextEditingController(); // 検索用コントローラ
  DateTime? _selectedDate;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadShoppingList(); // 商品データをロード
    _allItems = _getAllItems(); // 全商品をロード
    _filteredShoppingList = List.from(_shoppingList); // 初期値は全商品を表示
    _searchController.addListener(_filterShoppingList); // 検索入力時の処理を登録
    if (widget.preSelectedDate != null) {
      _selectedDate = widget.preSelectedDate;
    }
  }

  // 商品データを `_shoppingList` にセット
  void _loadShoppingList() {
    setState(() {
      _shoppingList = []; // 初期状態では空リスト
      _filteredShoppingList = []; // 初期状態では検索リストも空
    });
  }

  // 全商品のリストを取得
  List<Map<String, dynamic>> _getAllItems() {
    List<Map<String, dynamic>> allItems = [];
    shoppingCategories.forEach((category, data) {
      List<Map<String, dynamic>> categoryItems = (data['items'] as List<dynamic>).cast<Map<String, dynamic>>();
      allItems.addAll(categoryItems);
    });
    return allItems;
  }

  // カテゴリ選択後に画面を遷移
  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });

    // カテゴリの商品リストを取得
    var categoryItems = shoppingCategories[category]!['items'] as List<dynamic>;
    List<Map<String, dynamic>> products = categoryItems.map((item) => item as Map<String, dynamic>).toList();

    // カテゴリの商品画面に遷移
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductListScreen(
          category: category,
          products: products,
          onAddItem: (item) {
            // ユーザーが明示的に選択した商品だけをリストに追加
            setState(() {
              if (!_shoppingList.contains(item)) {
                _shoppingList.add(item);
              }
            });
          },
        ),
      ),
    );
  }

  Future<void> _saveShoppingListToCSV() async {
    if (_shoppingList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('買い物リストに商品がありません')),
      );
      return;
    }

    String title = _titleController.text.trim().isNotEmpty
        ? _titleController.text.trim()
        : "タイトル未設定"; // タイトルが空の場合のデフォルト

    String dateString = _selectedDate != null
        ? _selectedDate!.toLocal().toString().split(" ")[0]
        : DateTime.now().toLocal().toString().split(" ")[0];

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/shopping_list_${dateString}.csv');

    List<List<String>> csvData = [];

    // 既存のリストを読み込んで、新しいデータを追記する
    if (await file.exists()) {
      String existingData = await file.readAsString();
      List<List<dynamic>> existingCsvList = CsvToListConverter().convert(existingData);

      // ヘッダーがすでにある場合、重複しないように削除
      if (existingCsvList.isNotEmpty && existingCsvList[0][0] == 'タイトル') {
        existingCsvList.removeAt(0);
      }

      // **ここで型変換を行う**
      csvData.addAll(existingCsvList.map((row) => row.map((cell) => cell.toString()).toList()));
    }

    // **新しいデータを String に変換**
    csvData.addAll(
      _shoppingList.map((item) => [
        title,
        item['name']?.toString() ?? "不明",
        dateString,
        (item['checked'] ?? false).toString(),
      ]).toList(),
    );


    // CSVに保存
    try {
      await file.writeAsString(const ListToCsvConverter().convert([
        ['タイトル', '商品名', '日付', 'チェック'], // ヘッダーを追加
        ...csvData, // **変換後のデータを渡す**
      ]));

      print('保存完了: ${file.path}');

      await loadShoppingLists(); // CSVを再ロード
      Navigator.pop(context);
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('CSVファイルを保存しました')),
      );
    } catch (e) {
      print('保存エラー: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('CSVファイルの保存に失敗しました')),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // 検索処理の修正
  void _filterShoppingList() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredShoppingList = [];
      } else {
        _filteredShoppingList = _allItems
            .where((item) => item['name'].toString().toLowerCase().contains(query))
            .toList();
      }
    });
  }

  // 商品を削除
  void _deleteItem(int index) {
    setState(() {
      _shoppingList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '買い物リスト${_selectedDate != null ? " - ${_selectedDate!.toLocal().toString().split(" ")[0]}" : ""}',
        ),
      ),
      body: Column(
        children: [
          // タイトル入力フィールド
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'リストのタイトル（任意）',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          // 検索バー
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: '商品を検索',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Divider(),
          // 追加された商品リストを表示
          Expanded(
            flex: 2,
            child: _shoppingList.isEmpty
                ? Center(child: Text('現在リストに商品はありません'))
                : ListView.builder(
              itemCount: _shoppingList.length,
              itemBuilder: (context, index) {
                var item = _shoppingList[index];
                return ListTile(
                  leading: Image.asset(
                    'assets/images/${item['image'] ?? 'default.png'}',
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                  title: Text(item['name']),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteItem(index),
                  ),
                );
              },
            ),
          ),
          Divider(),
          // 検索結果の表示
          if (_searchController.text.isNotEmpty)
            Expanded(
              flex: 2,
              child: _filteredShoppingList.isEmpty
                  ? Center(child: Text('該当する商品が見つかりません'))
                  : ListView.builder(
                      itemCount: _filteredShoppingList.length,
                      itemBuilder: (context, index) {
                        var item = _filteredShoppingList[index];
                          return ListTile(
                            leading: Image.asset(
                              'assets/images/${item['image'] ?? 'default.png'}',
                              width: 40,
                              height: 40,
                              fit: BoxFit.contain,
                            ),
                            title: Text(item['name']),
                            trailing: IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  if (!_shoppingList.contains(item)) {
                                    _shoppingList.add(item);
                                  }
                                });
                              },
                            ),
                          );
                        },
                      ),
            ),
          Divider(),
          // カテゴリ表示
          Expanded(
            flex: 3,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 150,
              ),
              itemCount: shoppingCategories.keys.length,
              itemBuilder: (context, index) {
                String category = shoppingCategories.keys.elementAt(index);
                String imagePath =
                    'assets/images/${shoppingCategories[category]?['image'] ?? 'default.png'}';

                return GestureDetector(
                  onTap: () {
                    _onCategorySelected(category);
                  },
                  child: Card(
                    elevation: 3.0,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          imagePath,
                          width: 60,
                          height: 60,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          category,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(),
          // 保存ボタン
          Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton.icon(
              icon: Icon(Icons.save),
              label: Text('保存'),
              onPressed: _saveShoppingListToCSV,
            ),
          ),
        ],
      ),
    );
  }

}
