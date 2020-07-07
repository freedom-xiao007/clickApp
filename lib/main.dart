import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// 文件数据读取持有单例
class DataInstance {
  factory DataInstance() => getInstance();
  static DataInstance _instance;

  List<String> data = new List();
  bool init = false;

  DataInstance._();

  static DataInstance getInstance() {
    if(_instance == null) {
      _instance = DataInstance._();
    }
    return _instance;
  }

  void initData(List<dynamic> list) {
    data = list;
    init = true;
  }

  /// 存储数据到文件中
  void saveData() async {
    print("Starting write file.");
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/data.json');
    if(data.length == 0) {
      file.writeAsString("");
      return;
    }
    for(int i=0; i<data.length; i++) {
      file.writeAsString(data[i] + "\n");
    }
  }
}

/// 主函数
void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '目标打卡',
      home: new TasksView(),
    );
  }
}

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
      List<String> list = file.readAsLinesSync();
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
    if(!task.containsKey('complete')) {
      task['complete'] = '1';
    }
    else if(task['complete'] == '1') {
      task['complete'] = '0';
    }
    else if(task['complete'] == '0') {
      task['complete'] = '1';
    }
    print("Switch state:" + json.encode(task));
    DataInstance.getInstance().data.replaceRange(index, index+1, [json.encode(task)]);
    DataInstance.getInstance().saveData();
    setState(() {});
  }

  String _getTaskName(String data) {
    Map<String, dynamic> task = json.decode(data);
    if(task.containsKey('name')) {
      return task['name'];
    }
    else {
      return '任务名称未定义';
    }
  }
}

/// 任务新增页面
class AddNewTask extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  TextEditingController  _name = new TextEditingController ();
  TextEditingController  _cycle = new TextEditingController ();
  TextEditingController  _isRepeat = new TextEditingController ();
  TextEditingController  _minRepeat = new TextEditingController ();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('新增任务'),
      ),
      body: new Center(
        //child: new Text(wordPair.asPascalCase),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextField(
                  autofocus: true,
                  controller: _name,
                  decoration: InputDecoration(
                      labelText: "请输入任务名称"
                  ),
                ),
                TextField(
                  controller: _cycle,
                  decoration: InputDecoration(
                      labelText: "请输入任务周期"
                  ),
                ),
                TextField(
                  controller: _isRepeat,
                  decoration: InputDecoration(
                      labelText: "是否是周期内可重复的任务，0不是，1是"
                  ),
                ),
                TextField(
                  controller: _minRepeat,
                  decoration: InputDecoration(
                      labelText: "当时周期内可重复的任务时，最少完成的次数"
                  ),
                ),
                Builder(builder: (ctx) {
                  return Column(
                    children: <Widget>[
                      RaisedButton(
                        child: Text("添加任务"),
                        onPressed: () {
                          Map<String, String> newTask = new Map();
                          newTask['name'] = _name.text.toString();
                          newTask['cycle'] = _cycle.text.toString();
                          newTask['isRepeat'] = _isRepeat.text.toString();
                          newTask['minRepeat'] = _minRepeat.text.toString();
                          DataInstance.getInstance().data.add(json.encode(newTask));
                          DataInstance.getInstance().saveData();
                          Navigator.push(
                            context,
                            new MaterialPageRoute(builder: (context) => TasksView()),
                          );
                        },
                      ),
                    ],
                  );
                },
                ),
              ],
            ),
          )
      ),
    );
  }
}

/// 任务修改页面
class ModifyTask extends StatefulWidget {
  final String task;

  ModifyTask({Key key, @required this.task}):super(key:key);

  @override
  State<StatefulWidget> createState() => _ModifyTaskState(oldTask: task);
}

class _ModifyTaskState extends State<ModifyTask> {
  final String oldTask;
  TextEditingController  _name = new TextEditingController ();
  TextEditingController  _cycle = new TextEditingController ();
  TextEditingController  _isRepeat = new TextEditingController ();
  TextEditingController  _minRepeat = new TextEditingController ();

  _ModifyTaskState({Key key, @required this.oldTask}) : super();

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> taskMap = json.decode(oldTask);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('修改任务'),
      ),
      body: new Center(
        //child: new Text(wordPair.asPascalCase),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextField(
                  autofocus: true,
                  controller: _name,
                  decoration: InputDecoration(
                      labelText: "请输入任务名称"
                  ),
                ),
                TextField(
                  controller: _cycle,
                  decoration: InputDecoration(
                      labelText: "请输入任务周期"
                  ),
                ),
                TextField(
                  controller: _isRepeat,
                  decoration: InputDecoration(
                      labelText: "是否是周期内可重复的任务，0不是，1是"
                  ),
                ),
                TextField(
                  controller: _minRepeat,
                  decoration: InputDecoration(
                      labelText: "当时周期内可重复的任务时，最少完成的次数"
                  ),
                ),
                Builder(builder: (ctx) {
                  return Column(
                    children: <Widget>[
                      RaisedButton(
                        child: Text("确认修改"),
                        onPressed: () {
                          Map<String, dynamic> newTask = json.decode(oldTask);
                          newTask['name'] = _name.text.toString();
                          newTask['cycle'] = _cycle.text.toString();
                          newTask['isRepeat'] = _isRepeat.text.toString();
                          newTask['minRepeat'] = _minRepeat.text.toString();
                          DataInstance.getInstance().data.remove(oldTask);
                          DataInstance.getInstance().data.add(json.encode(newTask));
                          DataInstance.getInstance().saveData();
                          Navigator.push(
                            context,
                            new MaterialPageRoute(builder: (context) => TasksView()),
                          );
                        },
                      ),
                    ],
                  );
                },
                ),
              ],
            ),
          )
      ),
    );
  }
}
