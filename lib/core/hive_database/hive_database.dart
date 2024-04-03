import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'hive_constants.dart';

class HiveDatabase {
  HiveDatabase();

  Future<void> init() async {
    var path = '';
    if (kIsWeb) {
      path = '/assets/hive';
    } else {
      var appFolder = await getApplicationDocumentsDirectory();
      path = appFolder.path;
    }
    var hivePath = '$path/hive';

    Hive.init(hivePath);
    _registerAdapters();
    await _initBoxes();
  }

  Box<T> getMyBox<T>() {
    return Hive.box<T>(HiveBoxMap.hiveBoxMap[T]?.boxName ?? '');
  }

  Future<void> _initBoxes() async {
    for (var key in HiveBoxMap.hiveBoxMap.keys) {
      await HiveBoxMap.hiveBoxMap[key]?.openBoxFunction();
    }
  }

  void _registerAdapters() {
    for (var key in HiveBoxMap.hiveBoxMap.keys) {
      HiveBoxMap.hiveBoxMap[key]?.registerAdapterFunction();
    }
  }
}
