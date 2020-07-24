import 'dart:convert';

import 'package:click_app/DataInstance.dart';

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
}