import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class TaskStatistics {

  static void add(Map<String, dynamic> log) async {
    DateTime date = DateTime.now();
    String today = date.year.toString() + "-" + date.month.toString() + "-" + date.day.toString();

    Map<String, dynamic> logs = new Map();
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/TaskStatics.json');
    if (file.existsSync()) {
      logs= json.decode(file.readAsStringSync());
    }
    if (!logs.containsKey(today)) {
      logs[today] = new List<dynamic>();
    }
    logs[today].add(log);
    file.writeAsStringSync(json.encode(logs));

    show();
  }

  static void show() async {
    Map<String, dynamic> logs = new Map();
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/TaskStatics.json');
    if (file.existsSync()) {
      logs = json.decode(file.readAsStringSync());
    }

    logs.forEach((k, v) {
      print(k.toString() + "::" + v.toString());
    });
  }
}