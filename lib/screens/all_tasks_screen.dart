import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:elderly/task_storage.dart';

class AllTasksScreen extends StatefulWidget {
  final List<Map<String, dynamic>> tasks;

  const AllTasksScreen({super.key, required this.tasks});

  @override
  _AllTasksScreenState createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends State<AllTasksScreen> {
  late List<Map<String, dynamic>> _tasks;
  late List<Map<String, dynamic>> _filteredTasks;
  String _sortOrder = "日付が早い順";
  TextEditingController _searchController = TextEditingController();
  String? _selectedYear = "未選択";
  String? _selectedMonth = "未選択";
  String? _selectedDay = "未選択";

  @override
  void initState() {
    super.initState();
    _tasks = List.from(widget.tasks);
    _filteredTasks = List.from(_tasks); // 🔹 初期値はすべてのタスク
    _sortTasks(); // 🔹 初回は昇順にソート
  }

  // タスクを並び替える
  void _sortTasks() {
    setState(() {
      if (_sortOrder == "日付が早い順") {
        _filteredTasks.sort((a, b) => DateTime.parse(a["start_time"]).compareTo(DateTime.parse(b["start_time"])));
      } else if (_sortOrder == "日付が遅い順") {
        _filteredTasks.sort((a, b) => DateTime.parse(b["start_time"]).compareTo(DateTime.parse(a["start_time"])));
      } else if (_sortOrder == "タスク名（昇順）") {
        _filteredTasks.sort((a, b) => a["task"].compareTo(b["task"]));
      } else if (_sortOrder == "タスク名（降順）") {
        _filteredTasks.sort((a, b) => b["task"].compareTo(a["task"]));
      }
    });
  }

  // タスクをフィルタリングする
  void _filterTasks() {
    setState(() {
      _filteredTasks = _tasks.where((task) {
        DateTime taskDate = DateTime.parse(task["start_time"]);
        String taskName = task["task"].toLowerCase();
        String searchQuery = _searchController.text.toLowerCase();

        bool yearMatch = _selectedYear == "未選択" || _selectedYear == taskDate.year.toString();
        bool monthMatch = _selectedMonth == "未選択" || _selectedMonth == DateFormat('MM').format(taskDate);
        bool dayMatch = _selectedDay == "未選択" || _selectedDay == DateFormat('dd').format(taskDate);
        bool nameMatch = searchQuery.isEmpty || taskName.contains(searchQuery);

        return yearMatch && monthMatch && dayMatch && nameMatch;
      }).toList();

      _sortTasks(); // 🔹 ソートを適用
    });
  }

  void _showTaskDetails(Map<String, dynamic> task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(task["task"]),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("開始時刻: ${DateFormat('yyyy/MM/dd HH:mm').format(DateTime.parse(task["start_time"]))}"),
              const SizedBox(height: 10),
              Text(
                task.containsKey("memo") && task["memo"].isNotEmpty
                    ? "メモ: ${task["memo"]}"
                    : "メモなし",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("閉じる"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTask(int index) async {
    int originalIndex = _tasks.indexOf(_filteredTasks[index]); // 元のリストでのインデックスを取得
    if (originalIndex != -1) {
      await TaskStorage.deleteTask(originalIndex); // CSVから削除
    }

    _tasks = await TaskStorage.loadTasks(); // 最新のタスクデータを再取得
    _filteredTasks = List.from(_tasks); // フィルタを適用し直す

    await _reloadTasks(); // 最新のデータを取得してUIを更新
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reloadTasks(); // 画面に戻ったときにタスクを再読み込み
  }

  Future<void> _reloadTasks() async {
    _tasks = await TaskStorage.loadTasks();
    _filteredTasks = List.from(_tasks);
    setState(() {});
  }


  Future<void> _editTask(int index) async {
    int originalIndex = _tasks.indexOf(_filteredTasks[index]); // 元リストのインデックス取得
    if (originalIndex == -1) return;

    Map<String, dynamic> task = Map.from(_filteredTasks[index]); // 現在のタスクデータをコピー

    TextEditingController taskController = TextEditingController(text: task["task"]);
    TextEditingController memoController = TextEditingController(text: task.containsKey("memo") ? task["memo"] : "");

    DateTime selectedTime = DateTime.parse(task["start_time"]);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("タスクを編集"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: taskController,
                decoration: InputDecoration(labelText: "タスク名"),
              ),
              TextField(
                controller: memoController,
                decoration: InputDecoration(labelText: "メモ（オプション）"),
              ),
              const SizedBox(height: 10),
              Text("開始時刻: ${DateFormat('yyyy/MM/dd HH:mm').format(selectedTime)}"),
              ElevatedButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedTime,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (pickedDate != null) {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(selectedTime),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        selectedTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      });
                    }
                  }
                },
                child: Text("時間を変更"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("キャンセル"),
            ),
            TextButton(
              onPressed: () async {
                task["task"] = taskController.text;
                task["memo"] = memoController.text;
                task["start_time"] = selectedTime.toIso8601String();

                _tasks[originalIndex] = task;
                await TaskStorage.saveTasks(_tasks); // 修正後のタスクを CSV に保存
                await _reloadTasks(); // UI 更新
                Navigator.pop(context);
              },
              child: Text("保存"),
            ),
          ],
        );
      },
    );
  }

  // 選択肢のリストを生成（未選択を追加）
  List<String> _getUniqueValues(String format) {
    List<String> values = _tasks
        .map((task) => DateFormat(format).format(DateTime.parse(task["start_time"])))
        .toSet()
        .toList();
    values.sort();
    return ["未選択", ...values]; // 先頭に「未選択」を追加
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("すべてのタスク"),
        actions: [
          // 並び順の選択メニュー
          DropdownButton<String>(
            value: _sortOrder,
            items: [
              "日付が早い順",
              "日付が遅い順",
              "タスク名（昇順）",
              "タスク名（降順）"
            ].map((order) => DropdownMenuItem(
              value: order,
              child: Text(order),
            )).toList(),
            onChanged: (value) {
              setState(() {
                _sortOrder = value!;
                _sortTasks(); // 選択に応じてソート
              });
            },
          ),
        ],
      ),

      body: Column(
        children: [
          // 年・月・日の選択
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedYear,
                    hint: const Text("年"),
                    isExpanded: true,
                    items: _getUniqueValues('yyyy').map((year) => DropdownMenuItem(
                      value: year,
                      child: Text(year == "未選択" ? "年を選択" : "$year年"),
                    )).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedYear = value;
                        _filterTasks();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedMonth,
                    hint: const Text("月"),
                    isExpanded: true,
                    items: _getUniqueValues('MM').map((month) => DropdownMenuItem(
                      value: month,
                      child: Text(month == "未選択" ? "月を選択" : "$month月"),
                    )).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedMonth = value;
                        _filterTasks();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedDay,
                    hint: const Text("日"),
                    isExpanded: true,
                    items: _getUniqueValues('dd').map((day) => DropdownMenuItem(
                      value: day,
                      child: Text(day == "未選択" ? "日を選択" : "$day日"),
                    )).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDay = value;
                        _filterTasks();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          /// 🔹 フィルターをリセット
          TextButton(
            onPressed: () {
              setState(() {
                _selectedYear = "未選択";
                _selectedMonth = "未選択";
                _selectedDay = "未選択";
                _searchController.clear();
                _filteredTasks = List.from(_tasks);
              });
            },
            child: const Text("フィルターをリセット"),
          ),

          /// 🔹 タスクリスト
          Expanded(
            child: _filteredTasks.isEmpty
                ? const Center(child: Text("該当するタスクがありません"))
                : ListView.builder(
              itemCount: _filteredTasks.length,
              itemBuilder: (context, index) {
                var task = _filteredTasks[index];
                return ListTile(
                  title: Text(task["task"]),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("開始時刻: ${DateFormat('yyyy/MM/dd HH:mm').format(DateTime.parse(task["start_time"]))}"),
                      if (task.containsKey("memo") && task["memo"].isNotEmpty)
                        Text("メモ: ${task["memo"]}", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  onTap: () => _showTaskDetails(task), // タップで詳細表示
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editTask(index), // タスク編集ボタン
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteTask(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
