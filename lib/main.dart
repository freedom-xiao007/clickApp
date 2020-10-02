import 'package:click_app/view/TaskView.dart';
import 'package:flutter/material.dart';


/// 主函数
void main() {
  runApp(new MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '目标打卡',
      home: new TaskView(),

    );
  }
}
