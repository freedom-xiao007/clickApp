import 'package:click_app/DataInstance.dart';
import 'package:click_app/TaskLog.dart';
import 'package:click_app/TaskModify.dart';
import 'package:click_app/model/DailyTask.dart';
import 'package:flutter/material.dart';

class DailyTaskListView extends StatefulWidget {
  @override
  createState() => new DailyTaskListState();
}

class DailyTaskListState extends State<DailyTaskListView>{
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: DataInstance.getInstance().data.length,
        itemBuilder: (context, index) {
          return new ListTile(
            title: new Text(DailyTask.getTaskName(DataInstance
                .getInstance()
                .data[index])),
            trailing: Wrap(
              children: <Widget>[
                !DataInstance.getInstance().show(index) ? new IconButton(
                    icon: new Icon(Icons.pause)) : new IconButton(
                    icon: new Icon(
                      !DailyTask.isComplete(DataInstance
                          .getInstance()
                          .data[index]) ? Icons.cancel : Icons.check,
                      color: !DailyTask.isComplete(DataInstance
                          .getInstance()
                          .data[index]) ? Colors.red : Colors.green,
                    ), onPressed: () => _switchState(index)),
                new IconButton(icon: new Icon(Icons.delete),
                    onPressed: () => _deleteTask(index)),
                new IconButton(icon: new Icon(Icons.mode_edit),
                    onPressed: () => _modifyTask(index)),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) =>
                    TaskLog(task: DataInstance
                        .getInstance()
                        .data[index])),
              );
            },
          );
        }
    );
  }

  _switchState(int index) {
    DailyTask.changeState(index);
    setState(() {});
  }

  /// 删除任务
  void _deleteTask(int index) {
    DailyTask.deleteTask(index);
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
}