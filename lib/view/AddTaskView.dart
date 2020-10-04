import 'package:click_app/tools/DataInstance.dart';
import 'package:flutter/material.dart';

/// 任务新增页面
class AddTaskView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  List<bool> _cycleTime = [false, false, false, false, false, false, false];
  String _moduleName;
  String _taskType;
  String _taskName;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('新增任务'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 40),
        child: ListView(
          children: <Widget>[
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                labelText: "请输入任务名称",
                hintText: "新任务名称",
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
            Text("如果是daily类型任务，请选择执行时间，周一到周日：", textAlign: TextAlign.center,),
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
                  value: _moduleName,
                  onChanged: (value) {
                    setState(() {
                      _moduleName = value;
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
                  value: _taskType,
                  onChanged: (value) {
                    setState(() {
                      _taskType = value;
                    });
                  },
                ),
              ],
            ),

            Align(
              alignment: Alignment.centerRight,
              child: RaisedButton(
                onPressed: () => _addNewTask(),
                child: Text("添加任务"),
              ),
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

  _addNewTask() {
    Map<String, dynamic> newTask = new Map();
    newTask['name'] = _taskName;
    newTask['cycleTime'] = _cycleTime;
    newTask["moduleName"] = _moduleName;
    DataInstance.getInstance().task.add(newTask, _taskType);

    Navigator.of(context).pop();
  }

}
