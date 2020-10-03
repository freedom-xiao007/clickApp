import 'dart:async';

import 'package:click_app/tools/DataInstance.dart';
import 'package:click_app/tools/TaskStatistics.dart';


class TaskTimer {
  factory TaskTimer() => getInstance();
  static TaskTimer _instance;

  TaskTimer._();

  static TaskTimer getInstance() {
    if(_instance == null) {
      _instance = TaskTimer._();
    }
    return _instance;
  }

  Timer timer;
  static const timeout = const Duration(seconds: 1);
  int second = 0;
  String task;
  String module;
  bool timerPause = false;
  DateTime begin;

  void start(String task, String module) {
    if (timer != null && timer.isActive) {
      saveStatisticsLog();
      timer.cancel();
    }

    this.task = task;
    this.module = module;
    second = 0;
    begin = DateTime.now();
    timer = new Timer.periodic(timeout, (timer) {
      handleTimeout();
    });
  }

  void handleTimeout() {
    second += 1;
    print("任务:" + task + "已经进行了：：" + Duration(seconds: second).toString().split('.').first.padLeft(8, "0"));
  }

  void stop() {
    if (timer != null && timer.isActive) {
      saveStatisticsLog();
      timer.cancel();
    }
  }

  String getTaskStatus() {
    if (timer == null || !timer.isActive) {
      return "无任务进行中";
    }
    return task + "    正在进行中：：        " + Duration(seconds: second).toString().split('.').first.padLeft(8, "0");
  }

  void saveStatisticsLog() {
    DateTime date = DateTime.now();
    Map<String, dynamic> log = new Map();
    log["taskName"] = this.task;
    log["moduleName"] = this.module;
    log["second"] = this.second;
    log["begin"] = this.begin.toString();
    log["end"] = date.toString();
    TaskStatistics.add(log);
  }
}