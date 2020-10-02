import 'dart:convert';

import 'package:click_app/tools/DataInstance.dart';
import 'package:flutter/material.dart';

/// 任务新增页面
class AddTaskView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  TextEditingController _name = new TextEditingController();
  bool _isDaily = false;
  List<bool> _cycleTime = [false, false, false, false, false, false, false];
  List<String> moduleNames = DataInstance.getInstance().module.getModules();
  int selectModule = 0;

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
              controller: _name,
              decoration: InputDecoration(labelText: "请输入任务名称"),
            ),
            ListTile(
              title: const Text("请选择是否是每日任务："),
              trailing: Switch(
                value: _isDaily,
                onChanged: (value) {
                  setState(() {
                    _isDaily = value;
                  });
                },
              ),
            ),
            for (var i = 0; i < 7; i += 1)
              Row(
                children: [
                  Checkbox(
                    onChanged: (bool value) {
                      setState(() {
                        _cycleTime[i] = value;
                      });
                    },
                    value: _cycleTime[i],
                  ),
                  Text(
                    '星期 ${i + 1}',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: Colors.black),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            Builder(
              builder: (ctx) {
                return Column(
                  children: <Widget>[
                    RaisedButton(
                      child: Text("添加任务"),
                      onPressed: () {
                        Map<String, dynamic> newTask = new Map();
                        newTask['name'] = _name.text;
                        newTask['cycleTime'] = _cycleTime;
                        newTask['isDaily'] = _isDaily;
                        DataInstance.getInstance().task.add(newTask);

                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
