import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class TaskPropertyModel {
  Map<String, dynamic> tasks = new Map();
  String className = "TaskPropertyModel";

  TaskPropertyModel() {
    tasks["daily"] = new List<dynamic>();
    tasks["week"] = new List<dynamic>();
    tasks["temp"] = new List<dynamic>();
    initData();
  }

  void initData() async {
    print("Start read taskProperty.json");

    List<dynamic> l = new List();
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
    tasks.forEach((k, v) {
      print(k.toString() + "::" + v.toString());
    });
  }

  void add(Map<String, dynamic> task, String type) {
    tasks[type].add(task);
    save();
  }

  void save() async {
    print("Starting write file.");
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/TaskProperty.json');
    file.writeAsString(json.encode(tasks));
    print("Write file end.");
  }

  int size(String type) {
    return tasks[type].length;
  }

  String getName(int index, String type) {
    return tasks[type][index]["name"].toString();
  }

  bool isComplete(int index, String type) {
    DateTime date = DateTime.now();
    String today = date.year.toString() + "-" + date.month.toString() + "-" + date.day.toString();
    return tasks[type][index]["isComplete"].toString() == "true" && tasks[type][index]["lastCompleteDate"] == today;
  }

  void changeState(int index, String type) {
    DateTime date = DateTime.now();
    String today = date.year.toString() + "-" + date.month.toString() + "-" + date.day.toString();
    if (tasks[type][index]["isComplete"].toString() == "true") {
      tasks[type][index]["isComplete"] = "false";
      tasks[type][index]["lastCompleteDate"] = today;
    }
    else {
      tasks[type][index]["isComplete"] = "true";
      tasks[type][index]["lastCompleteDate"] = today;
    }
    save();
  }

  void deleteTask(int index, String type) {
    tasks[type].removeAt(index);
    save();
  }

  bool show(int index, String type) {
    int week = new DateTime.now().weekday;
    if (type == "daily" && tasks[type][index]["cycleTime"][week-1]) {
      return true;
    }
    return false;
  }

  String getModule(int index, String type) {
    if (tasks[type][index].containsKey("moduleName")) {
      return tasks[type][index]["moduleName"].toString();
    }
    return "其他";
  }

  String getModuleByTaskName(String taskName) {
    String moduleName = "其他";
    tasks.forEach((key, value) {
      List<dynamic> l = value;
      l.forEach((element) {
        if (element["name"].toString().compareTo(taskName) == 0) {
          moduleName = element["moduleName"];
        }
      });
    });
    print("WARRING: Can't find module name of " + taskName);
    return moduleName;
  }

  List<String> getTypes() {
    List<String> types = new List();
    types.add("daily");
    types.add("week");
    types.add("temp");
    return types;
  }

  List<String> getAllName() {
    List<String> names = new List();
    tasks.forEach((key, value) {
      List<dynamic> l = value;
      l.forEach((element) {
        names.add(element["name"]);
      });
    });
    return names;
  }

}
