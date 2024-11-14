import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../models/report_model.dart';
import '../../services/report_storage_service.dart';

class ReportController extends GetxController {
  late final ReportStorageService _storage;

  final overallScore = 0.obs;
  final checkResults = <String, Map<String, String>>{}.obs;
  final reports = <Report>[].obs;
  final deviceModel = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initStorage();
    loadReports();

    // 监听报告变化
    ever(reports, (_) {
      if (reports.isNotEmpty) {
        final latest = reports.first;
        overallScore.value = latest.score;
        checkResults.value = Map.from(latest.checkResults);
        deviceModel.value = latest.deviceModel;
      }
    });
  }

  void _initStorage() {
    try {
      _storage = Get.find<ReportStorageService>();
    } catch (e) {
      debugPrint('初始化存储服务失败: $e');
      rethrow;
    }
  }

  String getDeviceModel() {
    if (reports.isEmpty) return '';
    return reports.first.deviceModel;
  }

  void loadReports() {
    try {
      reports.value = _storage.getAllReports();
      if (reports.isNotEmpty) {
        deviceModel.value = reports.first.deviceModel;
      }
    } catch (e) {
      debugPrint('加载报告失败: $e');
      reports.value = [];
    }
  }

  Future<void> saveReport(Report report) async {
    try {
      await _storage.saveReport(report);
      loadReports();
    } catch (e) {
      debugPrint('保存报告失败: $e');
    }
  }

  Future<void> deleteReport(String id) async {
    try {
      await _storage.deleteReport(id);
      loadReports();
    } catch (e) {
      debugPrint('删除报告失败: $e');
    }
  }

  Future<void> deleteAllReports() async {
    try {
      await _storage.deleteAllReports();
      loadReports();
    } catch (e) {
      debugPrint('删除所有报告失败: $e');
    }
  }

  String getScoreLevel() {
    if (overallScore.value >= 90) return '优秀';
    if (overallScore.value >= 80) return '良好';
    if (overallScore.value >= 70) return '一般';
    return '需要改进';
  }

  List<String> getOptimizationSuggestions() {
    final suggestions = <String>[];

    checkResults.forEach((key, value) {
      final status = value['status'] ?? 'error';
      if (status != 'good') {
        String suggestion = '';
        switch (key) {
          case '电池状态':
            suggestion = '建议优化应用的电池使用，减少后台运行的程序数量';
            break;
          case '存储空间':
            suggestion = '建议清理不必要的文件和应用，保持足够的存储空间';
            break;
          case '内存使用':
            suggestion = '建议关闭不必要的后台应用，提高系统运行效率';
            break;
          case '系统性能':
            suggestion = '建议更新系统至最新版本，并定期清理系统缓存';
            break;
        }
        if (suggestion.isNotEmpty) {
          suggestions.add(suggestion);
        }
      }
    });

    if (suggestions.isEmpty) {
      suggestions.add('您的设备状态良好，请继续保持');
    }

    return suggestions;
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy年MM月dd日 HH:mm').format(date);
  }

  String getReportTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}天前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}小时前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟前';
    } else {
      return '刚刚';
    }
  }

  bool hasReports() {
    return reports.isNotEmpty;
  }

  int getReportCount() {
    return reports.length;
  }

  Report? getReport(String id) {
    return _storage.getReport(id);
  }

  void showDeleteConfirmDialog(String id) {
    Get.defaultDialog(
      title: '删除报告',
      middleText: '确定要删除这份报告吗？',
      textConfirm: '确定',
      textCancel: '取消',
      confirmTextColor: Colors.white,
      onConfirm: () {
        deleteReport(id);
        Get.back();
      },
      onCancel: () => Get.back(),
    );
  }

  void showDeleteAllConfirmDialog() {
    Get.defaultDialog(
      title: '删除所有报告',
      middleText: '确定要删除所有报告吗？此操作无法撤销。',
      textConfirm: '确定',
      textCancel: '取消',
      confirmTextColor: Colors.white,
      onConfirm: () {
        deleteAllReports();
        Get.back();
      },
      onCancel: () => Get.back(),
    );
  }
}
