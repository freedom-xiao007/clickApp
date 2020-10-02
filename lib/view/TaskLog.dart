import 'dart:convert';

import 'package:flutter/material.dart';

class TaskLog extends StatelessWidget {
  final String task;

  TaskLog({Key key, @required this.task}) : super();

  @override
  Widget build(BuildContext context) {
    List<DataRow> dataRows = _getLogs(task);

    return Scaffold(
        appBar: new AppBar(
          title: new Text('目标打卡'),
        ),
        body: new DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label: Text(
                  '日期',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  '是否完成',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  '次数',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
            rows: dataRows
        )
    );
  }

  List<DataRow> _getLogs(String task) {
    List<DataRow> list = new List();

    Map<String, dynamic> taskMap = json.decode(task);
    Map<String, dynamic> logMap = json.decode(taskMap['log']);

    logMap.forEach((key, value) {
      Map<String, dynamic> log = json.decode(value);

      String date = key.toString();
      String isComplete = "未完成";
      if(log['isComplete'] == '1') {
        isComplete = "完成";
      }
      String count = log['time'].toString();

      list.add(DataRow(
          cells: [
            DataCell(Text('$date')),
            DataCell(Text('$isComplete')),
            DataCell(Text('$count')),
          ]
      ));
    });

    return list;
  }
}