import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

class TaskStorage {
  static const String _fileName = "tasks.csv";

  // タスクを CSV に保存する（メモを含む）
  static Future<void> saveTasks(List<Map<String, dynamic>> tasks) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$_fileName');

    List<List<dynamic>> csvData = [
      ["start", "end", "task", "start_time", "completed", "repeat", "memo"],
    ];

    for (var task in tasks) {
      csvData.add([
        task["start"],
        task["end"],
        task["task"],
        task["start_time"],
        task["completed"].toString(),
        task["repeat"],
        task["memo"] ?? "",
      ]);
    }

    String csvString = const ListToCsvConverter().convert(csvData);
    await file.writeAsString(csvString);
  }

  // CSV からタスクを読み込む（メモを含む）
  static Future<List<Map<String, dynamic>>> loadTasks() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$_fileName');

    if (!await file.exists()) return [];

    String csvContent = await file.readAsString();
    List<List<dynamic>> rows = const CsvToListConverter().convert(csvContent);

    List<Map<String, dynamic>> loadedTasks = [];

    for (var row in rows.skip(1)) { // ヘッダーをスキップ
      loadedTasks.add({
        "start": row[0],
        "end": row[1],
        "task": row[2],
        "start_time": row[3],
        "completed": row[4] == "true",
        "repeat": row.length > 5 ? row[5] : "なし",
        "memo": row.length > 6 ? row[6] : "", // メモを正しく読み込む
      });
    }

    return loadedTasks;
  }


// タスクを削除する
  static Future<void> deleteTask(int index) async {
    List<Map<String, dynamic>> tasks = await loadTasks();
    if (index >= 0 && index < tasks.length) {
      tasks.removeAt(index);
      await saveTasks(tasks); // 削除後に CSV を更新
    }
  }

  // タスクを編集する
  static Future<void> editTask(int index, Map<String, dynamic> updatedTask) async {
    List<Map<String, dynamic>> tasks = await loadTasks();
    if (index >= 0 && index < tasks.length) {
      tasks[index] = updatedTask;
      await saveTasks(tasks); // 編集後に CSV を更新
    }
  }
}
