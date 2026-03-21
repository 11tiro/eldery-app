import 'package:flutter/material.dart';
import 'add_shopping_screen.dart';
import 'daily_shopping_screen.dart';
import 'global_data.dart';

class ShoppingScreen extends StatefulWidget {
  @override
  _ShoppingScreenState createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  @override
  void initState() {
    super.initState();
    // 初期化時にデータをロード
    loadShoppingLists().then((_) {
      setState(() {}); // データロード後に画面を更新
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> dates = savedShoppingLists.keys.toList();
    dates.sort(); // 日付順にソート

    return Scaffold(
      appBar: AppBar(
        title: Text("買い物リスト"),
      ),
      body: dates.isEmpty
          ? Center(child: Text("買い物リストはありません"))
          : ListView.builder(
        itemCount: dates.length,
        itemBuilder: (context, index) {
          String date = dates[index];
          List<Map<String, dynamic>> items = savedShoppingLists[date]!;

          return ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text(items[0]['title'] ?? "タイトルなし"),
            subtitle: Text("日付: ${items[0]['date'] ?? "日付不明"} - ${items.length} 件"),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                bool? confirmDelete = await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("リスト削除"),
                      content: Text("${items[0]['title']} のリストを削除しますか？"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text("キャンセル"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text("削除"),
                        ),
                      ],
                    );
                  },
                );

                if (confirmDelete == true) {
                  await deleteShoppingListCSV(items[0]['date']); // CSV削除
                  savedShoppingLists.remove(items[0]['date']); // メモリ上のデータ削除
                  await saveShoppingListToCSV(); // CSVファイルの更新
                  await loadShoppingLists(); // 最新のデータをロード
                  setState(() {}); // UI更新
                }
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DailyShoppingScreen(
                    date: items[0]['date'],
                    items: items,
                    onListEmpty: () async {
                      await deleteShoppingListCSV(date); // CSVを削除
                      setState(() {
                        savedShoppingLists.remove(date); // リストを削除
                      });
                      await loadShoppingLists(); // 最新データをロード
                    },
                  ),
                ),
              ).then((_) {
                setState(() {}); // 画面戻り後にリストを更新
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text("買い物リスト追加"),
        onPressed: () async {
          DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (picked != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddShoppingScreen(
                  preSelectedDate: picked,
                ),
              ),
            ).then((_) {
              setState(() {}); // 画面戻り後に更新
            });
          }
        },
      ),
    );
  }
}
