import 'package:click_app/tools/DataInstance.dart';
import 'package:click_app/tools/TaskTimer.dart';
import 'package:flutter/material.dart';

class TaskListView extends StatefulWidget {
  @override
  createState() => new TaskListState();
}

class TaskListState extends State<TaskListView> {
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: DataInstance.getInstance().task.size(),
        itemBuilder: (context, index) {
          return new ListTile(
            title: new Text(DataInstance.getInstance().task.getName(index)),
            trailing: Wrap(
              children: <Widget>[
                !DataInstance.getInstance().task.show(index)
                    ? new IconButton(icon: new Icon(Icons.close))
                    : new IconButton(
                        icon: new Icon(
                          !DataInstance.getInstance().task.isComplete(index)
                              ? Icons.cancel
                              : Icons.check,
                          color: !DataInstance.getInstance().task.isComplete(index)
                              ? Colors.red
                              : Colors.green,
                        ),
                        onPressed: () => _switchState(index)),
                new IconButton(icon: new Icon(Icons.timer), onPressed: () => _startTask(index)),
                new IconButton(icon: new Icon(Icons.stop), onPressed: () => _stopTask(index)),
              ],
            ),
//            onTap: () {
//              Navigator.push(
//                context,
//                new MaterialPageRoute(
//                    builder: (context) =>
//                        TaskLog(task: DataInstance.getInstance().task.getName(index))),
//              );
//            },
          );
        });
  }

  _switchState(int index) {
    DataInstance.getInstance().task.changeState(index);
    setState(() {});
  }

  /// 删除任务
  void _deleteTask(int index) {
    DataInstance.getInstance().task.deleteTask(index);
    setState(() {});
  }

  /// 跳转到任务修改页面
  void _modifyTask(int index) {
    Navigator.push(
        context,
        new MaterialPageRoute(
//          builder: (context) =>
//              ModifyTask(task: DataInstance.getInstance().task.getName(index)),
        )
    );
  }

  _startTask(int index) {
    TaskTimer.getInstance().start(DataInstance.getInstance().task.getName(index),
    DataInstance.getInstance().task.getModule(index));
  }

  _stopTask(int index) {
    TaskTimer.getInstance().stop();
  }
}
