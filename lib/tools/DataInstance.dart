import 'dart:io';

import 'package:click_app/model/ModulePropertyModel.dart';
import 'package:click_app/model/TaskPropertyModel.dart';
import 'package:path_provider/path_provider.dart';

/// 文件数据读取持有单例
class DataInstance {
  factory DataInstance() => getInstance();
  static DataInstance _instance;

  TaskPropertyModel task = new TaskPropertyModel();
  ModulePropertyModel module = new ModulePropertyModel();

  DataInstance._();

  static DataInstance getInstance() {
    if(_instance == null) {
      _instance = DataInstance._();
    }
    return _instance;
  }
}