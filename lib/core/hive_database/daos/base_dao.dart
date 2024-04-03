
import 'package:drote/core/hive_database/entities/base_entity.dart';
import 'package:drote/core/utils/logger_utils.dart';
import 'package:drote/global/locator.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../hive_database.dart';


abstract class BaseDao<T extends BaseEntity> {
  @protected
  late Box<T> box;
  BaseDao() {
    box = locator<HiveDatabase>().getMyBox<T>();
  }

  Future<void> insert(T entity) async {
    try {
      await box.put(entity.id, entity);
    } catch (e) {
      LoggerUtils().logException(e);
    }
  }

  Future<void> insertAll(List<T> entities) async {
    try {
      Map<dynamic, T> data =
          { for (var e in entities) e.id : e };
      await box.putAll(data);
    } catch (e) {
      LoggerUtils().logException(e);
    }
  }

  T findById(String id) {
    return box.get(id)!;
  }

  List<T> getAll() {
    return box.values.toList();
  }

  Future<void> update(String id, T entity) async {
    await updateEntity(entity);
  }

  Future<void> updateEntity(T entity) async {
    if (box.containsKey(entity.id)) {
      await box.put(entity.id, entity);
    }
  }

  Future<void> updateAll(List<T> entities) async {
    Map<dynamic, T> data =
        { for (var e in entities) e.id : e };
    await box.putAll(data);
  }

  Future<void> delete(String id) async {
    if (box.containsKey(id)) {
      await box.delete(id);
    }
  }

  Future<void> deleteAll(List<String> ids) async {
    await box.deleteAll(ids);
  }

  Future<void> clear() async {
    await box.clear();
  }
}
