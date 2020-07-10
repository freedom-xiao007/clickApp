import 'dart:convert';

import 'package:click_app/DataInstance.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

/// 任务新增页面
class AddNewTask extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  TextEditingController _name = new TextEditingController();
  List<String> _cycleList = new List();
  bool _isRepeat = false;
  TextEditingController _minRepeat = new TextEditingController();
  bool _one = false;
  bool _two = false;
  bool _three = false;
  bool _four = false;
  bool _five = false;
  bool _six = false;
  bool _seven = false;

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
              decoration: InputDecoration(labelText: "请输入任务名称"),
            ),
            Text("请选择任务一周内执行时间:周一、二、三、四、五、六、七"),
            Wrap(children: <Widget>[
              Checkbox(
                value: _one,
                onChanged: (bool value) {
                  if(value) {
                    _cycleList.add("1");
                  }
                  else {
                    _cycleList.remove("1");
                  }
                  setState(() {
                    _one = value;
                  });
                },
              ),
              Checkbox(
                value: _two,
                onChanged: (bool value) {
                  if(value) {
                    _cycleList.add("2");
                  }
                  else {
                    _cycleList.remove("2");
                  }
                  print(_cycleList.toString());
                  setState(() {
                    _one = value;
                  });
                },
              ),
              Checkbox(
                value: _three,
                onChanged: (bool value) {
                  if(value) {
                    _cycleList.add("3");
                  }
                  else {
                    _cycleList.remove("3");
                  }
                  print(_cycleList.toString());
                  setState(() {
                    _three = value;
                  });
                },
              ),
              Checkbox(
                value: _four,
                onChanged: (bool value) {
                  if(value) {
                    _cycleList.add("4");
                  }
                  else {
                    _cycleList.remove("4");
                  }
                  print(_cycleList.toString());
                  setState(() {
                    _four = value;
                  });
                },
              ),
              Checkbox(
                value: _five,
                onChanged: (bool value) {
                  if(value) {
                    _cycleList.add("5");
                  }
                  else {
                    _cycleList.remove("5");
                  }
                  print(_cycleList.toString());
                  setState(() {
                    _five = value;
                  });
                },
              ),
              Checkbox(
                value: _six,
                onChanged: (bool value) {
                  if(value) {
                    _cycleList.add("6");
                  }
                  else {
                    _cycleList.remove("6");
                  }
                  print(_cycleList.toString());
                  setState(() {
                    _six = value;
                  });
                },
              ),
              Checkbox(
                value: _seven,
                onChanged: (bool value) {
                  if(value) {
                    _cycleList.add("7");
                  }
                  else {
                    _cycleList.remove("7");
                  }
                  print(_cycleList.toString());
                  setState(() {
                    _seven = value;
                  });
                },
              ),
            ]),
            ListTile(
              title: const Text("请选择是否周期性任务："),
              trailing : Switch(
                value: _isRepeat,
                onChanged: (value) {
                  setState(() {
                    _isRepeat = value;
                  });
                },
              ),
            ),
            TextField(
              controller: _minRepeat,
              decoration: InputDecoration(labelText: "当时周期内可重复的任务时，最少完成的次数"),
            ),
            Builder(
              builder: (ctx) {
                return Column(
                  children: <Widget>[
                    RaisedButton(
                      child: Text("添加任务"),
                      onPressed: () {
                        Map<String, String> newTask = new Map();
                        newTask['name'] = _name.text.toString();
                        newTask['cycle'] = _cycleList.toString();
                        newTask['isRepeat'] = _isRepeat.toString();
                        newTask['minRepeat'] = _minRepeat.text.toString();

                        DateTime date = new DateTime.now();
                        Map<String, String> dateLog = new Map();
                        dateLog['isComplete'] = '0';
                        dateLog['time'] = '0';
                        String dateString = date.year.toString() +
                            "-" +
                            date.month.toString() +
                            "-" +
                            date.day.toString();
                        Map<String, String> log = new Map();
                        log[dateString] = json.encode(dateLog);
                        newTask['log'] = json.encode(log);

                        DataInstance.getInstance()
                            .data
                            .add(json.encode(newTask));
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
      )),
    );
  }
}
