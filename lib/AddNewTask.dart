import 'dart:convert';

import 'package:click_app/DataInstance.dart';
import 'package:flutter/material.dart';


/// 任务新增页面
class AddNewTask extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  TextEditingController  _name = new TextEditingController ();
  TextEditingController  _cycle = new TextEditingController ();
//  List<String> _cycle = new List();
  TextEditingController  _isRepeat = new TextEditingController ();
  TextEditingController  _minRepeat = new TextEditingController ();
//  bool one = false;
//  bool two = false;
//  bool three = false;
//  bool four = false;
//  bool five = false;
//  bool six = false;
//  bool seven = false;

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