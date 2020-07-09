import 'dart:convert';

import 'package:click_app/DataInstance.dart';
import 'package:click_app/TaskView.dart';
import 'package:flutter/material.dart';

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