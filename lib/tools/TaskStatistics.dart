import 'dart:convert';
import 'dart:io';

import 'package:click_app/model/TaskStatisticsModel.dart';
import 'package:path_provider/path_provider.dart';

class TaskStatistics {
  TaskStatistics() {
   init();
  }

  String dir;
  File file;

  void init() async {
    print("初始化文件模块");
    dir = (await getApplicationDocumentsDirectory()).path;
    file = new File('$dir/TaskStatics.json');
    print("初始化结束");
  }

  void add(Map<String, dynamic> log) {
    DateTime date = DateTime.now();
    String today = date.year.toString() + "-" + date.month.toString() + "-" + date.day.toString();

    Map<String, dynamic> logs = new Map();
    logs= json.decode(file.readAsStringSync());

    if (!logs.containsKey(today)) {
      logs[today] = new List<dynamic>();
    }
    logs[today].add(log);
    file.writeAsStringSync(json.encode(logs));
  }

  List<String> show() {
    List<String> records = new List();

    Map<String, dynamic> logs = new Map();
    logs = json.decode(file.readAsStringSync());

    logs.forEach((k, v) {
      print(k.toString() + "::" + v.toString());
      records.add(v.toString());
    });

    return records;
  }

  List<TaskStatisticsModel> getData(String type) {
    DateTime today = DateTime.now();
    DateTime pre = getPreTime(today, type);

    Map<String, int> statistics = new Map();
    Map<String, dynamic> records = json.decode(file.readAsStringSync());
    records.forEach((key, value) {
      List<String> split = key.split("-");
      DateTime date = new DateTime(int.parse(split[0]), int.parse(split[1]), int.parse(split[2]));
      if (date.compareTo(today) < 1 && date.compareTo(pre) > -1) {
        List<dynamic> record = value;
        record.forEach((element) {
          statistics.update(element["moduleName"], (value) => (value + element["second"]), ifAbsent: ()=>(element["second"]));
        });
      }
    });

    List<TaskStatisticsModel> modelList = new List();
    statistics.forEach((key, value) {
      print(key + "::" + value.toString());
      modelList.add(TaskStatisticsModel(key, (value % 60)));
    });
    return modelList;
  }

  List<List<String>> getRecord(String type) {
    DateTime today = DateTime.now();
    DateTime pre = getPreTime(today, type);

    List<List<String>> records = new List();
    Map<String, dynamic> logs = json.decode(file.readAsStringSync());
    logs.forEach((key, value) {
      List<String> split = key.split("-");
      DateTime date = new DateTime(int.parse(split[0]), int.parse(split[1]), int.parse(split[2]));
      if (date.compareTo(today) < 1 && date.compareTo(pre) > -1) {
        List<dynamic> record = value;
        record.forEach((element) {
          List<String> temp = new List();
          temp.add(element["taskName"].toString());
          temp.add(element["begin"].toString().split(".")[0]);
          temp.add(element["end"].toString().split(".")[0]);
          temp.add((element["second"] % 60).toString());
          records.add(temp);
        });
      }
    });

    return records;
  }

  DateTime getPreTime(DateTime today, String type) {
    DateTime pre = new DateTime(today.year, today.month, today.day);
    if (type == "week") {
      pre = pre.add(new Duration(days: -7));
    }
    else if (type == "month") {
      pre = pre.add(new Duration(days: -30));
    }
    else if (type == "year") {
      pre = pre.add(new Duration(days: -365));
    }
    return pre;
  }
}