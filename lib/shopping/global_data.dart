import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

Map<String, List<Map<String, dynamic>>> savedShoppingLists = {}; // グローバル変数

Future<void> loadShoppingLists() async {
  final directory = await getApplicationDocumentsDirectory();
  List<FileSystemEntity> files = directory.listSync(); // フォルダ内のすべてのファイルを取得

  savedShoppingLists.clear(); // 古いデータをクリア

  for (var file in files) {
    if (file is File && file.path.contains('shopping_list_')) { // "shopping_list_" を含むファイルのみ対象
      try {
        String csvData = await file.readAsString();
        List<List<dynamic>> csvList = CsvToListConverter().convert(csvData);

        if (file is File && file.path.contains('shopping_list_')) {
          try {
            String csvData = await file.readAsString();
            List<List<dynamic>> csvList = CsvToListConverter().convert(csvData);

            if (csvList.isNotEmpty) {
              // ファイル名からタイトルを取得
              String fileName = file.path.split('/').last;
              String title = fileName
                  .replaceFirst('shopping_list_', '') // プレフィックスを除去
                  .replaceFirst('.csv', ''); // サフィックスを除去

              String date = csvList[1][2]?.toString() ?? "日付不明"; // 日付を取得

              if (!savedShoppingLists.containsKey(date)) {
                savedShoppingLists[date] = [];
              }

              for (var row in csvList.skip(1)) {
                savedShoppingLists[date]!.add({
                  'title': title, // 抽出したタイトルを保存
                  'name': row[1] ?? "不明",
                  'date': row[2] ?? "日付不明",
                  'checked': row[3] == 'true',
                });
              }
            }
          } catch (e) {
            print("エラー: ${file.path} の読み込みに失敗しました: $e");
          }
        }

      } catch (e) {
        print("エラー: ${file.path} の読み込みに失敗しました: $e");
        print("デバッグ: 現在のデータ: $savedShoppingLists");
      }
    }
  }

  print("CSVデータ読み込み完了: $savedShoppingLists");
}

Future<void> saveShoppingListToCSV() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/shopping_lists.csv');
  List<List<String>> csvData = [
    ['name', 'date', 'checked'], // ヘッダー
  ];

  savedShoppingLists.forEach((date, items) {
    if (items.isNotEmpty) { // データが空でない場合のみ保存
      for (var item in items) {
        csvData.add([
          item['name'] ?? "不明",
          date,
          (item['checked'] ?? false).toString(), // チェック状態を文字列として保存
        ]);
      }
    }
  });

  String csvString = const ListToCsvConverter().convert(csvData);
  await file.writeAsString(csvString); // ファイルに保存
  print("CSV保存完了: $csvString");
}

Future<void> deleteShoppingListCSV(String date) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/shopping_list_$date.csv');

  try {
    if (await file.exists()) {
      await file.delete(); // CSVファイルを削除
      print("削除成功: ${file.path}");
    } else {
      print("削除失敗: ${file.path} が見つかりません");
    }
  } catch (e) {
    print("エラー: ${file.path} の削除中に問題が発生しました: $e");
  }
}
