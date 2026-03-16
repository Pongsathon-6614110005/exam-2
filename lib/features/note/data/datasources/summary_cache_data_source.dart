import 'package:hive_flutter/hive_flutter.dart';

abstract class SummaryCacheDataSource {
  Future<String?> getSummary(String key);
  Future<void> saveSummary(String key, String summary);
}

class SummaryCacheDataSourceImpl implements SummaryCacheDataSource {
  final Box<String> box;

  SummaryCacheDataSourceImpl(this.box);

  @override
  Future<String?> getSummary(String key) async {
    return box.get(key);
  }

  @override
  Future<void> saveSummary(String key, String summary) async {
    await box.put(key, summary);
  }
}
