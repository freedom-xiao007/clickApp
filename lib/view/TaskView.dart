import 'package:click_app/tools/DataInstance.dart';
import 'package:click_app/view/AddTaskView.dart';
import 'package:flutter/material.dart';

import 'TaskListView.dart';

/// 任务列表展示页面
class TaskView extends StatefulWidget {
  @override
  createState() => new TaskViewState();
}

class TaskViewState extends State<TaskView> {
  @override
  Widget build(BuildContext context) {
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
                  Tab(text: "每日任务"),
                  Tab(text: '每周任务'),
                  Tab(text: '心愿清单'),
              ],
            ),
          ),
          body: new TabBarView(
            children: <Widget>[
              Center(child: new TaskListView()),
              Center(child: new TaskListView()),
              Center(child: new TaskListView()),
            ],
          ),
        )
    );
  }

  /// 跳转到任务添加页面
  void _addTask() {
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => AddTaskView()),
    );
  }

  /// 刷新页面
  void _refreshPage() {
    setState(() {});
  }
}