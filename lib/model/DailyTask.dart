import 'dart:convert';
import 'dart:io';

import 'package:click_app/DataInstance.dart';
import 'package:path_provider/path_provider.dart';

/// 每日任务函数操作类
class DailyTask {
  /// 判断任务是否完成
  static bool isComplete(String item) {
    Map<String, dynamic> map;
    try {
      map = json.decode(item);
    }
    catch(Exception){
      DataInstance.getInstance().data.remove(item);
      return false;
    }
    if(map.containsKey("complete") && map['complete'] == "1") {
      print(item + ":complete");
      return true;
    }
    print(item + ":don't complete");
    return false;

  }

  static String getTaskName(String data) {
    Map<String, dynamic> task;
    try {
      task = json.decode(data);
    }
    catch(Exception) {
      DataInstance.getInstance().data.remove(data);
      return '任务存储错误，请刷新页面';
    }
    if(task.containsKey('name')) {
      return task['name'];
    }
    else {
      return '任务名称未定义';
    }
  }

  /// 任务完成打开状态切换
  static void changeState(int index) {
    Map<String, dynamic> task = json.decode(DataInstance.getInstance().data[index]);
    String isComplete = '0';
    if(!task.containsKey('complete')) {
      isComplete = '1';
    }
    else if(task['complete'] == '1') {
      isComplete = '0';
    }
    else if(task['complete'] == '0') {
      isComplete = '1';
    }
    task['complete'] = isComplete;

    DateTime date = new DateTime.now();
    String dateString = date.year.toString() + "-" + date.month.toString() + "-" + date.day.toString();
    Map<String, dynamic> log = json.decode(task['log']);
    if(log.containsKey(dateString)) {
      Map<String, dynamic> dateLog = json.decode(log[dateString]);
      dateLog['isComplete'] = isComplete;
      dateLog['time'] = '1';
      log[dateString] = json.encode(dateLog);
    }
    else {
      Map<String, String> dateLog = new Map();
      dateLog['isComplete'] = isComplete;
      dateLog['time'] = '1';
      log[dateString] = json.encode(dateLog);
    }
    task['log'] = json.encode(log);

    print("Switch state:" + json.encode(task));
    DataInstance.getInstance().data.replaceRange(index, index+1, [json.encode(task)]);
    DataInstance.getInstance().saveData();
  }

  /// 删除任务
  static void deleteTask(int index) {
    DataInstance.getInstance().data.removeAt(index);
    print("Delete task:" + index.toString() + "::" + DataInstance.getInstance().data.toString());
    DataInstance.getInstance().saveData();
  }

  /// 判断每日任务当天是否显示
  static bool show(int index) {
    String week = new DateTime.now().weekday.toString();
    print(week);
    Map<String, dynamic> task = json.decode(DataInstance.getInstance().data[index]);
    List<dynamic> cycle = new List();
    try {
      cycle = json.decode(task['cycle']);
      for(int i=0; i<cycle.length; i++) {
        if(cycle[i].toString() == week) {
          return true;
        }
      }
      return false;
    }
    catch(Exception) {
      return true;
    }
  }

  /// 初始化读取文件内容
  static Future<List<String>> readDataFile() async {
    print("Starting read file.");
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/data.json');
    if (file.exists() != null) {
      List<String> list = _updateTaskStatus(file.readAsLinesSync());
      print("file contents:" + list.toString());
      return list;
    }
    else {
      print("File is empty.");
      List<String> list = new List();
      return list;
    }
  }

  /// 启动时检测当天任务状态是否重置，并进行更新操作
  static List<String> _updateTaskStatus(List<String> list) {
    List<String> tasks = new List();
    DateTime date = new DateTime.now();
    String dateString = date.year.toString() + "-" + date.month.toString() +
        "-" + date.day.toString();

    list.forEach((element) {
      Map<String, dynamic> task = json.decode(element);
      Map<String, dynamic> log = json.decode(task['log']);

      if (!log.containsKey(dateString)) {
        Map<String, String> dateLog = new Map();
        dateLog['isComplete'] = '0';
        dateLog['time'] = '0';
        log[dateString] = json.encode(dateLog);

        task['log'] = json.encode(log);
        task['complete'] = '0';
        tasks.add(json.encode(task));
      }
      else {
        tasks.add(element);
      }
    });

    return tasks;
  }
}