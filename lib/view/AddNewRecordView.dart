import 'package:click_app/tools/DataInstance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddNewRecordView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddNewRecordState();
}

class _AddNewRecordState extends State<AddNewRecordView> {
  String _taskName;
  String _moduleName;
  String _beginTime;
  String _endTime;
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("新任务的新记录添加"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: () => _saveRecord(),),
        ],
      ),
      body: ListView(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              labelText: "任务名称",
              hintText: "新任务的名称",
              prefixIcon: Icon(Icons.theaters),
            ),
            onChanged: (value) {
              setState(() {
                _taskName = value;
              });
            },
          ),

          TextField(
            decoration: InputDecoration(
              labelText: "模块名称",
              hintText: "新模块的名称",
              prefixIcon: Icon(Icons.view_module),
            ),
            onChanged: (value) {
              setState(() {
                _moduleName= value;
              });
            },
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

  _saveRecord() {
    DateTime begin = DateTime.parse(_beginTime);
    DateTime end = DateTime.parse(_endTime);
    print("Save record::" + _beginTime + "--" + _endTime + "::" + end.difference(begin).inSeconds.toString());

    Map<String, dynamic> log = new Map();
    log["taskName"] = this._taskName;
    log["moduleName"] = this._moduleName;
    log["second"] = end.difference(begin).inSeconds;
    log["begin"] = this._beginTime;
    log["end"] = this._endTime;
    DataInstance.getInstance().statistics.add(log);

    Navigator.of(context).pop();
  }

}