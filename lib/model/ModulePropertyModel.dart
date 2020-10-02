import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';


enum Modules {Other, Worker, Learn, Exercise}

class ModulePropertyModel {
  List<Map<String, String>> modules = new List();

  ModulePropertyModel() {
    Map<String, String> defaultModule = new Map();
    defaultModule["name"] = "默认未知模块";
    modules.add(defaultModule);
    initData();
  }

  void initData() async {
    print("Start read moduleProperty.json");

    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/moduleProperty.json');
    if (file.existsSync()) {
      file.readAsLinesSync().forEach((element) {
         modules.add(json.decode(element));
      });
    }

    if (modules.length == 0) {
      print("Module property file is empty");
      return;
    }
    print("Read end, module list:");
    modules.forEach((element) {
      print(element);
    });

  }

  List<String> getModules() {
    List<String> moduleNames = new List();
//    modules.forEach((module) {
//      moduleNames.add(module["name"]);
//    });
    moduleNames.add("工作");
    moduleNames.add("学习");
    moduleNames.add("锻炼");
    moduleNames.add("其他");
    moduleNames.add("娱乐");
    return moduleNames;
  }

}