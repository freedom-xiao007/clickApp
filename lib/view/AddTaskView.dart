import 'package:click_app/tools/DataInstance.dart';
import 'package:flutter/material.dart';

/// 任务新增页面
class AddTaskView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  TextEditingController _name = new TextEditingController();
  List<bool> _cycleTime = [false, false, false, false, false, false, false];
  List<String> taskTypes = DataInstance.getInstance().task.getTypes();
  int _selectType;
  List<String> moduleNames = DataInstance.getInstance().module.getModules();
  int _selectModule;

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

            for (var i = 0; i < moduleNames.length; i++)
              ListTile(
                title: Text(moduleNames[i]),
                leading: Radio(
                  value: i,
                  groupValue: _selectModule,
                  onChanged: (i) {
                    print(i);
                    setState(() {
                      _selectModule = i;
                    });
                  },
                ),
              ),

            for (var i = 0; i < taskTypes.length; i++)
              ListTile(
                title: Text(taskTypes[i]),
                leading: Radio(
                  value: i,
                  groupValue: _selectType,
                  onChanged: (i) {
                    print(i);
                    setState(() {
                       _selectType = i;
                    });
                  },
                ),
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
                        newTask["moduleName"] = moduleNames[_selectModule];
                        DataInstance.getInstance().task.add(newTask, taskTypes[_selectType]);

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
