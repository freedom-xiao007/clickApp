import 'package:click_app/tools/DataInstance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddOldRecordView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddOldRecordState();
}

class _AddOldRecordState extends State<AddOldRecordView> {
  String _taskName;
  String _beginTime;
  String _endTime;
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("已有任务的新记录添加"),
      ),
      body: ListView(
        children: <Widget>[
          Row (
            children: <Widget>[
              Text("请选择任务名称:"),
              DropdownButton(
                items: _buildDropdownMenu(),
                value: _taskName,
                onChanged: (value) {
                  setState(() {
                    _taskName = value;
                  });
                },
              ),
              RaisedButton(
                onPressed: () => _saveRecord(),
                child: Text("添加保存"),
              )
            ],
          ),

          Text("开始时间选择"),
          CupertinoTimerPicker(
            initialTimerDuration: Duration(hours: now.hour,minutes: now.minute,seconds: now.second),
            onTimerDurationChanged: (Duration duration) {
              setState(() {
                DateTime today = new DateTime(now.year, now.month, now.day);
                _beginTime = today.add(duration).toString();
                print(_beginTime);
              });
            },
          ),

          Text("结束时间选择"),
          CupertinoTimerPicker(
            initialTimerDuration: Duration(hours: now.hour,minutes: now.minute,seconds: now.second),
            onTimerDurationChanged: (Duration duration) {
              setState(() {
                DateTime today = new DateTime(now.year, now.month, now.day);
                _endTime = today.add(duration).toString();
                print(_endTime);
              });
            },
          ),

        ],
      ),
    );
  }

  List<DropdownMenuItem> _buildDropdownMenu() {
    List<String> taskNames = DataInstance.getInstance().task.getAllName();
    List<DropdownMenuItem> menu = new List();
    taskNames.forEach((name) {
      menu.add(DropdownMenuItem(value: name, child: Text(name),));
    });
    return menu;
  }

  _saveRecord() {
    DateTime begin = DateTime.parse(_beginTime);
    DateTime end = DateTime.parse(_endTime);
    print("Save record::" + _beginTime + "--" + _endTime + "::" + end.difference(begin).inSeconds.toString());

    Map<String, dynamic> log = new Map();
    log["taskName"] = this._taskName;
    log["moduleName"] = DataInstance.getInstance().task.getModuleByTaskName(this._taskName);
    log["second"] = end.difference(begin).inSeconds;
    log["begin"] = this._beginTime;
    log["end"] = this._endTime;
    DataInstance.getInstance().statistics.add(log);

    Navigator.of(context).pop();
  }

}