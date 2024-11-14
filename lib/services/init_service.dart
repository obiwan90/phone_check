import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../controllers/theme_controller.dart';
import '../models/report_model.dart';
import 'report_storage_service.dart';

class InitService extends GetxService {
  Future<InitService> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // 初始化Hive
    await Hive.initFlutter();

    // 注册适配器
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ReportAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(CheckResultAdapter());
    }

    // 注册服务
    final reportStorage = ReportStorageService();
    await reportStorage.init();
    Get.put(reportStorage, permanent: true);

    // 注册控制器
    Get.put(ThemeController(), permanent: true);

    return this;
  }

  static Future<void> initServices() async {
    try {
      await Get.putAsync(() => InitService().init());
      debugPrint('所有服务初始化完成');
    } catch (e) {
      debugPrint('服务初始化错误: $e');
    }
  }
}

// 需要生成的适配器
class ReportAdapter extends TypeAdapter<Report> {
  @override
  final typeId = 0;

  @override
  Report read(BinaryReader reader) {
    return Report(
      id: reader.read(),
      deviceModel: reader.read(),
      score: reader.read(),
      scoreLevel: reader.read(),
      createdAt: reader.read(),
      checkResults: Map<String, dynamic>.from(reader.read()),
      suggestions: List<String>.from(reader.read()),
      categoryScores: Map<String, int>.from(reader.read()),
    );
  }

  @override
  void write(BinaryWriter writer, Report obj) {
    writer.write(obj.id);
    writer.write(obj.deviceModel);
    writer.write(obj.score);
    writer.write(obj.scoreLevel);
    writer.write(obj.createdAt);
    writer.write(obj.checkResults);
    writer.write(obj.suggestions);
    writer.write(obj.categoryScores);
  }
}

class CheckResultAdapter extends TypeAdapter<CheckResult> {
  @override
  final typeId = 1;

  @override
  CheckResult read(BinaryReader reader) {
    return CheckResult(
      status: reader.read(),
      info: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, CheckResult obj) {
    writer.write(obj.status);
    writer.write(obj.info);
  }
}
