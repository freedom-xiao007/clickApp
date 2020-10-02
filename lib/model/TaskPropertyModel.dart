import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class TaskPropertyModel {
  List<dynamic> tasks = new List();
  String className = "TaskPropertyModel";

  TaskPropertyModel() {
    initData();
  }

  void initData() async {
    print("Start read taskProperty.json");

    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/TaskProperty.json');
    if (file.existsSync()) {
      tasks = json.decode(file.readAsStringSync());
    }

    if (tasks.length == 0) {
      print("Task property file is empty");
      return;
    }
    print("Read end, task list:");
    tasks.forEach((element) {
      print(element);
    });
  }

  void add(Map<String, dynamic> task) {
    tasks.add(task);
    save();
  }

  void save() async {
    print("Starting write file.");
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/TaskProperty.json');
    file.writeAsString(json.encode(tasks));
    print("Write file end.");
  }

  int size() {
    return tasks.length;
  }

  String getName(int index) {
    return tasks[index]["name"].toString();
  }

  bool isComplete(int index) {
    return tasks[index]["isComplete"].toString() == "true";
  }

  void changeState(int index) {
    if (tasks[index]["isComplete"].toString() == "true") {
      tasks[index]["isComplete"] = "false";
    }
    else {
      tasks[index]["isComplete"] = "true";
    }
    save();
  }

  void deleteTask(int index) {
    tasks.removeAt(index);
    save();
  }

  bool show(int index) {
    if (tasks[index]["isDaily"]) {
      return true;
    }

    int week = new DateTime.now().weekday;
    if (tasks[index]["cycleTime"][week-1]) {
      return true;
    }
    return false;
  }
}
