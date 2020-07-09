import 'dart:convert';
import 'dart:io';

import 'package:click_app/AddNewTask.dart';
import 'package:click_app/DataInstance.dart';
import 'package:click_app/TaskLog.dart';
import 'package:click_app/TaskModify.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// 任务列表展示页面
class TasksView extends StatefulWidget {
  @override
  createState() => new TasksViewState();
}

class TasksViewState extends State<TasksView>{
  @override
  Widget build(BuildContext context) {
    // 初始化打卡任务数据
    if(!DataInstance.getInstance().init) {
      _readDataFile().then((value) => {
        DataInstance.getInstance().initData(value),
        _refreshPage(),
      });
    }
    print("Data:" + DataInstance.getInstance().data.toString());

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('目标打卡'),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.refresh), onPressed: _refreshPage),
          new IconButton(icon: new Icon(Icons.save), onPressed: DataInstance.getInstance().saveData),
          new IconButton(icon: new Icon(Icons.add), onPressed: _addTask),
        ],
      ),
      body: new Center(
        child: new ListView.builder(
            itemCount: DataInstance.getInstance().data.length,
            itemBuilder: (context, index) {
              return new ListTile(
                title: new Text(_getTaskName(DataInstance.getInstance().data[index])),
                trailing: Wrap(
                  children: <Widget>[
                    new IconButton(icon: new Icon(
                      !_isComplete(DataInstance.getInstance().data[index]) ? Icons.cancel : Icons.check,
                      color: !_isComplete(DataInstance.getInstance().data[index]) ? Colors.red : Colors.green,
                    ), onPressed: () => _switchState(index)),
                    new IconButton(icon: new Icon(Icons.delete), onPressed: () => _deleteTask(index)),
                    new IconButton(icon: new Icon(Icons.mode_edit), onPressed:() => _modifyTask(index)),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) => TaskLog(task: DataInstance.getInstance().data[index])),
                  );
                },
              );
            }),
      ),
    );
  }

  /// 初始化读取文件内容
  Future<List<String>> _readDataFile() async {
    print("Starting read file.");
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/data.json');
    if(file.exists() != null) {
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

  /// 判断任务是否完成
  bool _isComplete(String item) {
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

  /// 跳转到任务添加页面
  void _addTask() {
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => AddNewTask()),
    );
  }

  /// 删除任务
  void _deleteTask(int index) {
    DataInstance.getInstance().data.removeAt(index);
    print("Delete task:" + index.toString() + "::" + DataInstance.getInstance().data.toString());
    DataInstance.getInstance().saveData();
    setState(() {});
  }

  /// 刷新页面
  void _refreshPage() {
    setState(() {});
  }

  /// 跳转到任务修改页面
  void _modifyTask(int index) {
    Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => ModifyTask(task: DataInstance.getInstance().data[index]),
        )
    );
  }

  /// 任务完成打开状态切换
  void _switchState(int index) {
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
    setState(() {});
  }

  String _getTaskName(String data) {
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

  /// 启动时检测当天任务状态是否重置，并进行更新操作
  List<String> _updateTaskStatus(List<String> list) {
    List<String> tasks = new List();
    DateTime date = new DateTime.now();
    String dateString = date.year.toString() + "-" + date.month.toString() + "-" + date.day.toString();

    list.forEach((element) {
      Map<String, dynamic> task = json.decode(element);
      Map<String, dynamic> log = json.decode(task['log']);

      if(!log.containsKey(dateString)) {
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