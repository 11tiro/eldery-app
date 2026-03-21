import 'package:flutter/material.dart';
import 'global_data.dart';

class DailyShoppingScreen extends StatefulWidget {
  final String date;
  final List<Map<String, dynamic>> items;
  final Function()? onListEmpty;

  DailyShoppingScreen({required this.date, required this.items, this.onListEmpty});

  @override
  _DailyShoppingScreenState createState() => _DailyShoppingScreenState();
}

class _DailyShoppingScreenState extends State<DailyShoppingScreen> {
  void _confirmDeleteItem(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("削除確認"),
          content: Text("${widget.items[index]['name']} を削除しますか？"),
          actions: [
            TextButton(
              child: Text("キャンセル"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("削除"),
              onPressed: () async {
                setState(() {
                  widget.items.removeAt(index);
                });

                if (widget.items.isEmpty) {
                  // CSVごと削除
                  await deleteShoppingListCSV(widget.date);
                  widget.onListEmpty?.call();
                  Navigator.of(context).pop(); // 画面を閉じる
                } else {
                  // CSVを更新
                  await saveShoppingListToCSV();
                }

                Navigator.of(context).pop(); // ダイアログを閉じる
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.date} の買い物リスト"),
      ),
      body: widget.items.isEmpty
          ? Center(child: Text("買い物リストがありません"))
          : ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          var item = widget.items[index];
          return ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text(item['name']),
            subtitle: Text("日付: ${item['date']}"),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _confirmDeleteItem(index);
              },
            ),
          );
        },
      ),
    );
  }
}
