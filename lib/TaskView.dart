import 'package:click_app/AddNewTask.dart';
import 'package:click_app/DailyTackList.dart';
import 'package:click_app/DataInstance.dart';
import 'package:click_app/model/DailyTask.dart';
import 'package:flutter/material.dart';

/// 任务列表展示页面
class TasksView extends StatefulWidget {
  @override
  createState() => new TasksViewState();
}

class TasksViewState extends State<TasksView> {
  @override
  Widget build(BuildContext context) {
    // 初始化打卡任务数据
    if (!DataInstance
        .getInstance()
        .init) {
      DailyTask.readDataFile().then((value) =>
      {
        DataInstance.getInstance().initData(value),
        _refreshPage(),
      });
    }
    print("Data:" + DataInstance
        .getInstance()
        .data
        .toString());

    return new DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: new AppBar(
            title: new Text('目标打卡'),
            actions: <Widget>[
              new IconButton(
                  icon: new Icon(Icons.refresh), onPressed: _refreshPage),
              new IconButton(icon: new Icon(Icons.add), onPressed: _addTask),
            ],
            bottom: new TabBar(
              isScrollable: true,
              tabs: <Widget>[
                Tab(text: '每日任务'),
                Tab(text: '每周任务'),
                Tab(text: '心愿清单'),
              ],
            ),
          ),
          body: new TabBarView(
            children: <Widget>[
              Center(child: new DailyTaskListView()),
              Center(child: new DailyTaskListView()),
              Center(child: new DailyTaskListView()),
            ],
          ),
        )
    );
  }

  /// 跳转到任务添加页面
  void _addTask() {
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => AddNewTask()),
    );
  }

  /// 刷新页面
  void _refreshPage() {
    setState(() {});
  }
}