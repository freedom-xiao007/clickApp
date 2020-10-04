import 'package:click_app/tools/DataInstance.dart';
import 'package:click_app/view/AddNewRecordView.dart';
import 'package:click_app/view/AddOldRecordView.dart';
import 'package:click_app/view/StatisticsChartsView.dart';
import 'package:flutter/material.dart';

class TaskStatisticsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TaskStatisticsState();
}

class _TaskStatisticsState extends State<TaskStatisticsView> {
  @override
  Widget build(BuildContext context) {
  return new DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text("数据统计显示"),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.add_circle), onPressed: _addNewStatistics,),
            IconButton(icon: Icon(Icons.add_circle_outline), onPressed: _addOldStatistics,),
            IconButton(icon: Icon(Icons.clear_all), onPressed: _RemoveAllStatistics,),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: <Widget>[
              Tab(text: "日",),
              Tab(text: "周",),
              Tab(text: "月",),
              Tab(text: "年",),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(child: new StatisticsChartsView(type: "day"),),
            Center(child: new StatisticsChartsView(type: "week"),),
            Center(child: new StatisticsChartsView(type: "month"),),
            Center(child: new StatisticsChartsView(type: "year"),),
          ],
        ),
      ));
  }

  void _addOldStatistics() {
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => AddOldRecordView()),
    );
  }

  void _addNewStatistics() {
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => AddNewRecordView()),
    );
  }


  void _RemoveAllStatistics() {
    DataInstance.getInstance().statistics.removeAll();
  }
}

