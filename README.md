# 目标打卡APP
***
*flutter学习试手，顺便记录下过程中的问题和感悟*

*花了两天时间写了个大概，接下来边用边改吧*

## 界面
&ensp;&ensp;&ensp;&ensp;基本界面如下：

![page.png](./page.png)

## 基本功能
### 已完成
- 任务新增：完成
- 任务修改：完成
- 任务显示：完成
- 任务打卡：完成
- 任务日志显示：完成
- 任务完成状态重置：完成
- 任务周期设置完善,具体到周几做：完成

### 未完成
- 与系统的日历联动：未完成
- 删除任务时提示确认
- 任务列表展示转卡片展示尝试
- 路由返回时触发刷新
- 周任务的相关增加：进行中
- 临时任务的相关增加：进行中
- 任务提醒功能：没一个小时提醒 / 定点提醒

#### 2020.9.26新增需求
- 任务模块划分：锻炼健身、自我学习提升、工作
- 可以新增任务模块
- 支持在任务模块下增加任务
- 在任务模块下有开始计时和结束计时功能，新增提示休息功能，如工作45，休息5（可自定义）统计累计耗时
- 新增每日、每周、每月、每年、所有历史数据统计

## 数据结构相关（目前版本先采用本地存储)
### 云端数据库存储格式
#### 打卡任务属性定义:task
```json5
{
  "name": "任务名称",
  "cycle": "任务周期，int型，1为一天，2为两天",
  "isRepeat": "是否是周期内可重复的任务，0不是，1是",
  "frequency": "周期内完成的次数，当是周期内可以重复的任务时有效",
  "minRepeat": "当时周期内可重复的任务时，最少完成的次数",
  "moduleId": "所属模块ID",
  "date": "最后进行更新日期",
  "isComplete": "是否完成"
}
```

#### 任务模块相关:module
```json
{
  "name": "模块名称",
  "sustained": "一周期持续时间",
  "suspend": "休息时间",
}
```

#### 任务打卡日志：taskLog
```json
{
  "taskId": "任务id",
  "log": [
    {"date": "日期", "isComplete": "0|1", "frequency": "number", "second":  "花费时间分钟"} 
  ],
}
```

#### 任务统计：taskStatistics
```json
{
  "date": "日期",
  "log": [{"isComplete": "0|1", "frequency": "number", "taskName": "任务名称", "second":  "花费时间分钟"}]
}
```

#### 模块计时统计：moduleStatistics
```json
{
  "date": "日期",
  "timeConsuming": [
    {"moduleName": "模块名称", "second":  "花费时间分钟"}
  ]
}
```

### 本地存储数据格式
#### 打卡任务属性定义:taskProperty.log
```json
[
  {
    "name": "任务名称",
    "cycle": "任务周期，int型，1为一天，2为两天",
    "isRepeat": "是否是周期内可重复的任务，0不是，1是",
    "frequency": "周期内完成的次数，当是周期内可以重复的任务时有效",
    "minRepeat": "当时周期内可重复的任务时，最少完成的次数",
    "moduleId": "所属模块ID",
    "date": "最后进行更新日期",
    "isComplete": "是否完成"
  }
]
```

#### 任务模块相关:module.log
```json
[
  {
    "name": "模块名称",
    "sustained": "一周期持续时间",
    "suspend": "休息时间",
  }
]
```

#### 任务打卡日志：taskLog.log
```json
{
  "任务id": [
    {"date": "日期", "isComplete": "0|1", "frequency": "number", "second":  "花费时间分钟"} 
  ]
}
```

#### 任务统计：taskStatistics.log
```json
{
  "日期": [
    {"isComplete": "0|1", "frequency": "number", "taskName": "任务名称", "second":  "花费时间分钟"}
  ]
}
```

#### 模块计时统计：moduleStatistics.log
```json
{
  "日期": [
    {"moduleName": "模块名称", "second":  "花费时间分钟"}
  ]
}
```

## 错误与修复
- Failed to install the following Android SDK packages as some licences have not been accepted.
    - 使用命令：flutter doctor --android-licenses

## 参考链接
- [官方教程](https://flutterchina.club/setup-windows/#%E8%8E%B7%E5%8F%96flutter-sdk)
- 安装依赖：点击链接进入依赖组件官网，选择Installing，里面有完整的安装语句
- 界面刷新（重绘）：调用有状态主键setState函数
- [Flutter 中的单例模式](https://juejin.im/post/5c83d5ac5188257de66337a9)
- [导航到一个新页面和返回](https://flutter.cn/docs/cookbook/navigation/navigation-basics)
- [3.7 输入框及表单](https://book.flutterchina.club/chapter3/input_and_form.html)
- [Flutter：界面刷新和生命周期](https://juejin.im/post/5ca81c80e51d4509f8232e9b)
- [读写文件](https://flutterchina.club/reading-writing-files/)
- [给新页面传值](https://flutterchina.club/cookbook/navigation/passing-data/)
- [Placing two trailing icons in ListTile](https://stackoverflow.com/questions/54548853/placing-two-trailing-icons-in-listtile)
- [Tips to use Timer in Dart and Flutter](https://fluttermaster.com/tips-to-use-timer-in-dart-and-flutter/)
- [Flutter widget index](https://flutter.dev/docs/reference/widgets)
- [表单：Form class](https://api.flutter.dev/flutter/widgets/Form-class.html)
- [文本：Text class](https://api.flutter.dev/flutter/widgets/Text-class.html)
- [单选：Radio<T> class](https://api.flutter.dev/flutter/material/Radio-class.html)
