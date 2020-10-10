import 'package:click_app/model/TaskStatisticsModel.dart';
import 'package:click_app/tools/DataInstance.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StatisticsChartsView extends StatelessWidget {
  final String type;
  StatisticsChartsView({@required this.type}) : super();

  List<List<String>> record;

  @override
  Widget build(BuildContext context) {
    record = DataInstance.getInstance().statistics.getRecord(type);

    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: TabBar(
              labelColor: Colors.black,
              isScrollable: true,
              tabs: <Widget>[
                Tab(text: "柱状图",),
                Tab(text: "饼图",),
                Tab(text: "详细记录",),
              ],
            ),
          ),

          body: TabBarView(
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text("时间使用情况柱状图（分钟）"),
                      SizedBox(height: 20,),
                      Expanded(
                        child: charts.BarChart(
                          _getData(type),
                          animate: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text("时间使用情况柱状图（分钟）"),
                      SizedBox(height: 20,),
                      Expanded(
                        child: charts.PieChart(
                          _getData(type),
                          animate: true,
                          defaultRenderer: new charts.ArcRendererConfig(
                            arcWidth: 60,
                            arcRendererDecorators: [new charts.ArcLabelDecorator()])
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: double.maxFinite,
                    child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 1,
                      itemBuilder: (BuildContext context, int index) {
//                      return InkWell (
//                        onTap: () {
//                          print(context);
//                        },
//                        child: Text("test"),
//                      );
                      return DataTable(
                        columns: const <DataColumn>[
                          DataColumn(label: Text("任务")),
                          DataColumn(label: Text("持续时间(分钟)")),
                          DataColumn(label: Text("开始时间")),
                          DataColumn(label: Text("结束时间")),
                        ],
                        rows: <DataRow>[
                          for (int i=0; i<record.length; i++)
                            DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(record[i][0])),
                                  DataCell(Text(record[i][3])),
                                  DataCell(Text(record[i][1])),
                                  DataCell(Text(record[i][2])),
                                ],
                              onSelectChanged: (value) {
                                  print(value);
                                  print(record[i]);
                                  _deleteDialog(context, record[i][4],
                                      record[i][5]);
                              },
                            ),
                        ],
                      );
                    }
                    )
                  );
                }
              )
            ],
          ),
        ));
  }

  List<charts.Series<TaskStatisticsModel, String>> _getData(String type) {
    final data = DataInstance.getInstance().statistics.getData(type);

    return [
      new charts.Series<TaskStatisticsModel, String>(
        id: 'statistics',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TaskStatisticsModel model, _) => model.moduleName,
        measureFn: (TaskStatisticsModel model, _) => model.time,
        data: data,
        labelAccessorFn: (TaskStatisticsModel model, _) => '${model.moduleName}: ${model.percentage}%',
      )
    ];
  }

  void _deleteDialog(BuildContext context, String date, String index) async {
    bool delete = await _showDeleteConfirmDialog(context);
    if (delete == null) {
      print("取消删除");
    }
    else{
      DataInstance.getInstance().statistics.deleteAt(int.parse(index), date);
      print("确认删除");
    }
  }

  Future<bool> _showDeleteConfirmDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("提示"),
          content: Text("是否删除此条记录"),
          actions: <Widget>[
            FlatButton(
              onPressed: () { Navigator.of(context).pop(); },
              child: Text("取消"),
            ),
            FlatButton(
              onPressed: () { Navigator.of(context).pop(true); },
              child: Text("删除"),
            ),
          ],
        );
      }
    );
  }

}
