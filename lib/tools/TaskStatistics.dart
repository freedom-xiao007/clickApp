import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class TaskStatistics {

  static void add(Map<String, dynamic> log) async {
    List<dynamic> logs = new List();
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/TaskStatics.json');
    if (file.existsSync()) {
      logs= json.decode(file.readAsStringSync());
    }
    logs.add(log);
    file.writeAsStringSync(json.encode(logs));

    show();
  }

  static void show() async {
    List<dynamic> logs = new List();
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/TaskStatics.json');
    if (file.existsSync()) {
      logs = json.decode(file.readAsStringSync());
    }

    logs.forEach((log) {
      print(log.toString());
    });
  }
}