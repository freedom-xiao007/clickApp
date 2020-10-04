import 'package:click_app/tools/DataInstance.dart';
import 'package:click_app/tools/TaskTimer.dart';
import 'package:click_app/view/ModifyTask.dart';
import 'package:flutter/material.dart';

class TaskListView extends StatefulWidget {
  final String taskType;

  TaskListView({Key key, @required this.taskType}):super(key:key);

  @override
  createState() => new TaskListState(taskType: taskType);
}

class TaskListState extends State<TaskListView> {
  final String taskType;
  TaskListState({Key key, @required this.taskType}):super();

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: DataInstance.getInstance().task.size(taskType),
        itemBuilder: (context, index) {
          return new ListTile(
            title: new Text(DataInstance.getInstance().task.getName(index, taskType)),
            trailing: Wrap(
              children: <Widget>[
                !DataInstance.getInstance().task.show(index, taskType)
                    ? new IconButton(icon: new Icon(Icons.close))
                    : new IconButton(
                        icon: new Icon(
                          !DataInstance.getInstance().task.isComplete(index, taskType)
                              ? Icons.cancel
                              : Icons.check,
                          color: !DataInstance.getInstance().task.isComplete(index, taskType)
                              ? Colors.red
                              : Colors.green,
                        ),
                        onPressed: () => _switchState(index)),
                new IconButton(icon: new Icon(Icons.timer), onPressed: () => _startTask(index)),
                new IconButton(icon: new Icon(Icons.stop), onPressed: () => _stopTask(index)),
              ],
            ),

            onTap: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) =>
                        ModifyTask(taskIndex: index, taskType: taskType)),
              );
            },

          );
        });
  }

  _switchState(int index) {
    DataInstance.getInstance().task.changeState(index, taskType);
    setState(() {});
  }

  /// 删除任务
  void _deleteTask(int index) {
    DataInstance.getInstance().task.deleteTask(index, taskType);
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
    TaskTimer.getInstance().start(DataInstance.getInstance().task.getName(index, taskType),
    DataInstance.getInstance().task.getModule(index, taskType));
  }

  _stopTask(int index) {
    TaskTimer.getInstance().stop();
  }
}
