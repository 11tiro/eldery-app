import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:elderly/task_storage.dart';
import 'all_tasks_screen.dart';
import 'package:elderly/cud_color_data.dart';

class ElderlyTaskScreen extends StatefulWidget {
  const ElderlyTaskScreen({super.key});

  @override
  _ElderlyTaskScreenState createState() => _ElderlyTaskScreenState();
}

class _ElderlyTaskScreenState extends State<ElderlyTaskScreen> {
  stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  String _text = "音声認識を開始するにはボタンを押してください";
  String _finalText = "";
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _startTime;
  DateTime? _endTime;
  DateTime? _taskStartTime;
  String _selectedRepeat = "なし"; // デフォルトの繰り返し設定
  List<Map<String, dynamic>> _tasks = []; // タスクリスト

  @override
  void initState() {
    super.initState();
    _initializeSpeechRecognition();
    initializeDateFormatting('ja_JP', null);
    _loadTasks().then((_) {
      _checkAndAddRecurringTasks();
    });
  }

  Future<void> _loadTasks() async {
    _tasks = await TaskStorage.loadTasks();
    setState(() {});
  }

  void _initializeSpeechRecognition() async {
    bool available = await _speechToText.initialize();
    if (!available) {
      setState(() {
        _text = "音声認識が使用できません";
      });
    }
  }

  // タスクを取得
  Future<List<Map<String, dynamic>>> _getTasksForSelectedDay() async {
    _tasks = await TaskStorage.loadTasks();
    return _tasks.where((task) {
      DateTime taskDate = DateTime.parse(task["start_time"]);
      return taskDate.year == _selectedDay.year &&
          taskDate.month == _selectedDay.month &&
          taskDate.day == _selectedDay.day;
    }).toList();
  }

  void _startListening() async {
    setState(() {
      _isListening = true;
      _text = "音声認識中...";
      _startTime = DateTime.now();
      _finalText = "";
    });

    _speechToText.listen(
      onResult: (result) {
        setState(() {
          _text = result.recognizedWords;
        });

        if (result.finalResult) {
          _finalText = result.recognizedWords;
          _stopListening();
        }
      },
      listenFor: Duration(seconds: 30),
      pauseFor: Duration(seconds: 5),
      localeId: "ja-JP",
    );
  }

  void _stopListening() async {
    setState(() {
      _isListening = false;
      _endTime = DateTime.now();
    });
    _speechToText.stop();

    if (_finalText.isNotEmpty) {
      _showEditDialog(_finalText); // 音声認識後に編集ダイアログを表示
    }
  }

  void _showEditDialog(String initialText) async {
    TextEditingController textController = TextEditingController(text: initialText);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("タスクを確認・編集"),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(labelText: "タスク内容"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("キャンセル"),
            ),
            TextButton(
              onPressed: () async {
                String editedText = textController.text.trim();
                if (editedText.isNotEmpty) {
                  await _showStartTimePicker(editedText);
                }
                Navigator.pop(context);
              },
              child: Text("保存"),
            ),
          ],
        );
      },
    );
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
                task["memo"].isNotEmpty ? "メモ: ${task["memo"]}" : "メモなし",
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


  // 開始時刻を選択するメソッド
  Future<void> _showStartTimePicker(String taskText) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );

    if (pickedDate == null) return;

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    DateTime startTime = DateTime(
        pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);

    setState(() {
      _taskStartTime = startTime;
    });

    await _showRepeatOptions(taskText, startTime);
  }

  Future<void> _showRepeatOptions(String taskText, DateTime startTime) async {
    String? selectedOption = await showDialog<String>(
      context: context,
      builder: (context) {
        String tempRepeat = _selectedRepeat;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text("繰り返し設定"),
              content: DropdownButton<String>(
                value: tempRepeat,
                items: ["なし", "毎日", "毎週", "毎月"]
                    .map((repeatOption) => DropdownMenuItem(
                  value: repeatOption,
                  child: Text(repeatOption),
                )).toList(),
                onChanged: (value) {
                  setDialogState(() {
                    tempRepeat = value!;
                  });
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: Text("キャンセル"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, tempRepeat),
                  child: Text("保存"),
                ),
              ],
            );
          },
        );
      },
    );

    if (selectedOption != null) {
      setState(() {
        _selectedRepeat = selectedOption;
      });

      await _saveTask(taskText, startTime, _selectedRepeat);
    }
  }

  // 繰り返しタスクを追加する
  void _checkAndAddRecurringTasks() async {
    DateTime now = DateTime.now();
    DateTime endPeriod = now.add(Duration(days: 30)); // 未来30日分を生成
    List<Map<String, dynamic>> newTasks = [];

    for (var task in _tasks) {
      String repeat = task["repeat"] ?? "なし";
      DateTime taskStartTime = DateTime.parse(task["start_time"]);

      while (taskStartTime.isBefore(endPeriod)) {
        // すでにこの日付のタスクが保存されているか確認
        bool alreadyExists = _tasks.any((existingTask) =>
        existingTask["task"] == task["task"] &&
            existingTask["start_time"] == taskStartTime.toIso8601String());

        if (!alreadyExists) {
          newTasks.add({
            "start": now.toIso8601String(),
            "end": now.toIso8601String(),
            "task": task["task"],
            "start_time": taskStartTime.toIso8601String(),
            "completed": false,
            "repeat": repeat,
          });
        }

        // 次の繰り返し日を計算
        if (repeat == "毎日") {
          taskStartTime = taskStartTime.add(Duration(days: 1));
        } else if (repeat == "毎週") {
          taskStartTime = taskStartTime.add(Duration(days: 7));
        } else if (repeat == "毎月") {
          taskStartTime = DateTime(taskStartTime.year, taskStartTime.month + 1, taskStartTime.day);
        } else {
          break; // 繰り返しなしの場合はループを抜ける
        }
      }
    }

    if (newTasks.isNotEmpty) {
      _tasks.addAll(newTasks);
      await TaskStorage.saveTasks(_tasks);
      setState(() {});
    }
  }

  Future<void> _saveTask(String taskText, DateTime startTime, String repeat, {String memo = ""}) async {
    List<Map<String, dynamic>> newTasks = [];

    DateTime taskDate = startTime;
    for (int i = 0; i < 30; i++) {
      if (repeat == "なし" && i > 0) break;

      bool alreadyExists = _tasks.any((existingTask) =>
      existingTask["task"] == taskText &&
          existingTask["start_time"] == taskDate.toIso8601String());

      if (!alreadyExists) {
        newTasks.add({
          "task": taskText,
          "start_time": taskDate.toIso8601String(),
          "completed": false,
          "repeat": repeat,
          "memo": memo, // メモを保存
        });
      }

      if (repeat == "毎日") {
        taskDate = taskDate.add(Duration(days: 1));
      } else if (repeat == "毎週") {
        taskDate = taskDate.add(Duration(days: 7));
      } else if (repeat == "毎月") {
        taskDate = DateTime(taskDate.year, taskDate.month + 1, taskDate.day);
      } else {
        break;
      }
    }

    _tasks.addAll(newTasks);
    await TaskStorage.saveTasks(_tasks);
    setState(() {});
  }

  // タスクを削除するメソッド
  Future<void> _deleteTask(int index) async {
    List<Map<String, dynamic>> selectedDayTasks = await _getTasksForSelectedDay();
    if (index < 0 || index >= selectedDayTasks.length) return;

    int originalIndex = _tasks.indexOf(selectedDayTasks[index]); // 元リストのインデックス取得
    if (originalIndex != -1) {
      await TaskStorage.deleteTask(originalIndex); // CSVから削除
    }

    List<Map<String, dynamic>> updatedTasks = await _getTasksForSelectedDay();
    setState(() {
      _tasks = updatedTasks; // 最新のデータを反映
    });
  }

    @override
    void didChangeDependencies() {
      super.didChangeDependencies();
      _reloadTasks(); // ここでタスクを再読み込み
    }

  Future<void> _reloadTasks() async {
    _tasks = await TaskStorage.loadTasks();
    setState(() {});
  }

  // 日付をフォーマットするメソッド
  String _formatDate(String isoDate) {
    DateTime date = DateTime.parse(isoDate);
    return DateFormat('yyyy年MM月dd日 HH:mm').format(date); // "YYYY年MM月DD日 HH:mm" 形式
  }

  // タスクを編集するメソッド
  Future<void> _editTask(int index) async {
    List<Map<String, dynamic>> selectedDayTasks = await _getTasksForSelectedDay();
    if (index < 0 || index >= selectedDayTasks.length) return;

    int originalIndex = _tasks.indexOf(selectedDayTasks[index]); // 元リストのインデックス取得
    if (originalIndex == -1) return;

    Map<String, dynamic> task = Map.from(selectedDayTasks[index]); // タスクデータをコピー

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

  @override
  Widget build(BuildContext context) {
    final colors = CUDColorData.themes["高齢者向け"]!;
    return Scaffold(
      appBar: AppBar(
        title: Text("タスク管理", style: TextStyle(color: colors["text"])),
        backgroundColor: colors["primary"],
      ),
      body: Column(
        children: [
          // 選択した日のタスクを表示
          Expanded(
            flex: 1,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _getTasksForSelectedDay(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator()); // ロード中
                } else if (snapshot.hasError) {
                  return Center(child: Text("エラーが発生しました: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("タスクがありません"));
                }

                List<Map<String, dynamic>> tasks = snapshot.data!;

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    var task = tasks[index];
                    return ListTile(
                      title: Text(task["task"]),
                      subtitle: Text("開始時刻: ${DateFormat('yyyy/MM/dd HH:mm').format(DateTime.parse(task["start_time"]))}"),
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
                );
              },
            ),
          ),

          Expanded(
            flex: 2, // カレンダーの高さを広げる
            child: TableCalendar(
              locale: 'ja_JP',
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _selectedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) async {
                List<Map<String, dynamic>> updatedTasks = await _getTasksForSelectedDay();
                setState(() {
                  _selectedDay = selectedDay;
                  _tasks = updatedTasks; // 最新のタスクリストを更新
                });
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: colors["button"],
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: colors["primary"],
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),
          ),

          const SizedBox(height: 10),
          Text(
            _text,
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          IconButton(
            icon: Icon(_isListening ? Icons.stop : Icons.mic, size: 50),
            onPressed: () {
              if (_isListening) {
                _stopListening();
              } else {
                _startListening();
              }
            },
          ),
          // すべてのタスクを表示するボタン
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllTasksScreen(tasks: _tasks)),
              );
            },
            child: const Text("すべてのタスクを表示"),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
