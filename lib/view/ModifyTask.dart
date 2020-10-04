import 'package:click_app/tools/DataInstance.dart';
import 'package:flutter/material.dart';

/// 任务修改页面
class ModifyTask extends StatefulWidget {
  final int taskIndex;
  final String taskType;

  ModifyTask({Key key, @required this.taskIndex, @required this.taskType}):super(key:key);

  @override
  State<StatefulWidget> createState() => _ModifyTaskState(taskIndex: taskIndex, taskType: taskType);
}

class _ModifyTaskState extends State<ModifyTask> {
  final int taskIndex;
  final String taskType;

  List<bool> _cycleTime = [false, false, false, false, false, false, false];
  String _moduleName;
  String _taskType;
  String _taskName;

  _ModifyTaskState({Key key, @required this.taskIndex, @required this.taskType}) : super();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('修改任务'),
      ),
      body: new Center(
        child: ListView(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: "如需修改，请输入任务名称",
                hintText: DataInstance.getInstance().task.getName(taskIndex, taskType),
                prefixIcon: Icon(Icons.tab),
              ),
              onChanged: (value) {
                setState(() {
                  _taskName = value;
                });
              },
            ),

            Divider(
              color: Colors.grey,
              height: 25,
              thickness: 5,
            ),
            Text("daily类型任务，请选择执行时间，周一到周日：", textAlign: TextAlign.center,),
            Row(
              children: [
                for (var i = 0; i < 7; i += 1)
                  Checkbox(
                    onChanged: (bool value) {
                      setState(() {
                        _cycleTime[i] = value;
                      });
                    },
                    value: _cycleTime[i],
                  ),
              ],
            ),

            Row(
              children: <Widget>[
                Text("请选择任务所属模块:"),
                DropdownButton(
                  items: _buildModuleDropdownMenu(),
                  value: DataInstance.getInstance().task.getModuleByTaskName(DataInstance.getInstance().task.getName(taskIndex, taskType)),
                  onChanged: (value) {
                    setState(() {
                      _moduleName = value;
                      print(_moduleName);
                    });
                  },
                ),
              ],
            ),

            Row(
              children: <Widget>[
                Text("请选择任务所属类型: 每日、每周、临时"),
                DropdownButton(
                  items: _buildTypeDropdownMenu(),
                  value: taskType,
                  onChanged: (value) {
                    setState(() {
                      _taskType = value;
                    });
                  },
                ),
              ],
            ),

            Row(
              children: <Widget>[
                RaisedButton(
                  onPressed: () => _modifyTask(),
                  child: Text("修改任务"),
                ),
                RaisedButton(
                  onPressed: () => _deleteTask(),
                  child: Text("删除任务"),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem> _buildModuleDropdownMenu() {
    List<String> moduleNames = DataInstance.getInstance().module.getModules();
    List<DropdownMenuItem> menu = new List();
    moduleNames.forEach((name) {
      menu.add(DropdownMenuItem(value: name.toString(), child: Text(name.toString()),));
    });
    return menu;
  }

  List<DropdownMenuItem> _buildTypeDropdownMenu() {
    List<String> taskTypes = DataInstance.getInstance().task.getTypes();
    List<DropdownMenuItem> menu = new List();
    taskTypes.forEach((name) {
      menu.add(DropdownMenuItem(value: name.toString(), child: Text(name.toString()),));
    });
    return menu;
  }

  _modifyTask() {
    if (_taskName == null) {
      _taskName = DataInstance.getInstance().task.getName(taskIndex, taskType);
    }
    if (_moduleName == null) {
      _moduleName = DataInstance.getInstance().task.getModuleByTaskName(_taskName);
    }
    if (_taskType == null) {
      _taskType = taskType;
    }

    Map<String, dynamic> newTask = new Map();
    newTask['name'] = _taskName;
    newTask['cycleTime'] = _cycleTime;
    newTask["moduleName"] = _moduleName;
    print(_taskType + " Modify to:" + newTask.toString());
    DataInstance.getInstance().task.add(newTask, _taskType);

    _deleteTask();
  }

  _deleteTask() {
    DataInstance.getInstance().task.deleteTask(taskIndex, taskType);
    Navigator.of(context).pop();
  }

}