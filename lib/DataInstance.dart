import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// 文件数据读取持有单例
class DataInstance {
  factory DataInstance() => getInstance();
  static DataInstance _instance;

  List<String> data = new List();
  List<String> allData = new List();
  List<String> showData = new List();
  bool init = false;
  String dir;
  File file;

  DataInstance._();

  static DataInstance getInstance() {
    if(_instance == null) {
      _instance = DataInstance._();
    }
    return _instance;
  }

  void initData(List<dynamic> list) async {
    data = list;
    init = true;
  }

  /// 存储数据到文件中
  void saveData() async {
    dir = (await getApplicationDocumentsDirectory()).path;
    file = new File('$dir/data.json');
    print("Starting write file.");
    if(data.length == 0) {
      file.writeAsString("");
      return;
    }
    String contents = "";
    for(int i=0; i<data.length; i++) {
      contents += data[i] + "\n";
    }
    file.writeAsString(contents);
    print("Write file end.");
  }

  bool show(int index) {
    String week = new DateTime.now().weekday.toString();
    print(week);
    Map<String, dynamic> task = json.decode(data[index]);
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
}