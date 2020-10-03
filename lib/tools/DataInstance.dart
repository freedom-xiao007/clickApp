import 'package:click_app/model/ModulePropertyModel.dart';
import 'package:click_app/model/TaskPropertyModel.dart';
import 'package:click_app/tools/TaskStatistics.dart';

/// 文件数据读取持有单例
class DataInstance {
  factory DataInstance() => getInstance();
  static DataInstance _instance;

  DataInstance._();

  static DataInstance getInstance() {
    if(_instance == null) {
      _instance = DataInstance._();
    }
    return _instance;
  }

  TaskPropertyModel task = new TaskPropertyModel();
  ModulePropertyModel module = new ModulePropertyModel();
  TaskStatistics statistics = new TaskStatistics();
}