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
    dir = (await getApplicationDocumentsDirectory()).path;
    file = new File('$dir/data.json');
  }

  /// 存储数据到文件中
  void saveData() async {
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
//          new IconButton(icon: new Icon(Icons.save), onPressed: DataInstance.getInstance().saveData),
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

                          DateTime date = new DateTime.now();
                          Map<String, String> dateLog = new Map();
                          dateLog['isComplete'] = '0';
                          dateLog['time'] = '0';
                          String dateString = date.year.toString() + "-" + date.month.toString() + "-" + date.day.toString();
                          Map<String, String> log = new Map();
                          log[dateString] = json.encode(dateLog);
                          newTask['log'] = json.encode(log);

                          DataInstance.getInstance().data.add(json.encode(newTask));
                          DataInstance.getInstance().saveData();

                          Navigator.of(context).pop();
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


class TaskLog extends StatelessWidget {
  final String task;

  TaskLog({Key key, @required this.task}) : super();

  @override
  Widget build(BuildContext context) {
    List<DataRow> dataRows = _getLogs(task);

    return Scaffold(
        appBar: new AppBar(
          title: new Text('目标打卡'),
        ),
        body: new DataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Text(
                '日期',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                '是否完成',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                '次数',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
          rows: dataRows
        )
    );
  }

  List<DataRow> _getLogs(String task) {
    List<DataRow> list = new List();

    Map<String, dynamic> taskMap = json.decode(task);
    Map<String, dynamic> logMap = json.decode(taskMap['log']);

    logMap.forEach((key, value) {
      Map<String, dynamic> log = json.decode(value);

      String date = key.toString();
      String isComplete = "未完成";
      if(log['isComplete'] == '1') {
        isComplete = "完成";
      }
      String count = log['time'].toString();

      list.add(DataRow(
        cells: [
          DataCell(Text('$date')),
          DataCell(Text('$isComplete')),
          DataCell(Text('$count')),
        ]
      ));
    });

    return list;
  }
}

