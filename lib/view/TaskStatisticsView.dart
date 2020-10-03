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
}

