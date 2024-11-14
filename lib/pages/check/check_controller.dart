import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../../models/report_model.dart';
import '../report/report_controller.dart';

class CheckController extends GetxController {
  final steps = [
    '屏幕显示检测',
    '摄像头检测',
    '扬声器检测',
    '传感器检测',
    '电池状态检测',
    '网络连接检测',
    '存储空间检测',
    '定位功能检测',
    'WiFi功能检测',
    '蓝牙功能检测',
  ];

  final currentStep = 0.obs;
  final isChecking = true.obs;
  final scrollController = ScrollController();
  final showResult = false.obs;
  final stepResults = <bool>[].obs;
  Timer? _checkTimer;

  @override
  void onInit() {
    super.onInit();
    startCheck();
  }

  @override
  void onClose() {
    scrollController.dispose();
    _checkTimer?.cancel();
    super.onClose();
  }

  Future<void> startCheck() async {
    isChecking.value = true;
    showResult.value = false;
    currentStep.value = 0;
    stepResults.clear();

    for (var i = 0; i < steps.length; i++) {
      // 模拟检测过程
      await Future.delayed(const Duration(seconds: 2));
      if (!isChecking.value) return; // 如果暂停了就退出

      // 模拟随机检测结果（实际应该根据真实检测结果）
      final isSuccess = i != 3 && i != 7; // 模拟第4项和第8项检测失败
      stepResults.add(isSuccess);
      currentStep.value = i + 1;

      // 滚动到当前检测项，但保持最后两项可见
      if (scrollController.hasClients && i < steps.length - 2) {
        final itemHeight = 88.0; // 列表项实际高度
        final maxScroll = scrollController.position.maxScrollExtent;
        final targetScroll = (i * itemHeight).clamp(0.0, maxScroll);

        scrollController.animateTo(
          targetScroll,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }

      // 如果是最后一步，显示检测结果
      if (i == steps.length - 1) {
        await Future.delayed(const Duration(seconds: 1));
        showResult.value = true;
        isChecking.value = false;

        // 保存检测报告
        final reportController = Get.find<ReportController>();
        final successCount = stepResults.where((result) => result).length;
        final score = (successCount / steps.length * 100).round();

        final checkResults = <String, dynamic>{};
        final suggestions = <String>[];

        // 计算分类得分
        final categoryScores = <String, int>{
          '硬件检测': _calculateCategoryScore(0, 3), // 屏幕、摄像头、扬声器、传感器
          '电池状态': _calculateCategoryScore(4, 4), // 电池
          '网络连接': _calculateCategoryScore(5, 7), // 网络、存储、定位
          '无线功能': _calculateCategoryScore(8, 9), // WiFi、蓝牙
        };

        // 填充检测结果
        for (var i = 0; i < steps.length; i++) {
          final isSuccess = stepResults[i];
          checkResults[steps[i]] = {
            'status': isSuccess ? 'good' : 'error',
            'info': isSuccess ? '${steps[i]}正常' : '${steps[i]}异常',
          };
          if (!isSuccess) {
            suggestions.add('建议检查${steps[i].replaceAll('检测', '')}');
          }
        }

        final report = Report(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          deviceModel: 'iPhone', // TODO: 获取真实设备型号
          score: score,
          scoreLevel: _getScoreLevel(score),
          createdAt: DateTime.now(),
          checkResults: checkResults,
          suggestions: suggestions,
          categoryScores: categoryScores,
        );

        await reportController.saveReport(report);

        // 等待用户查看结果后再跳转
        await Future.delayed(const Duration(seconds: 2));
        Get.offNamed('/report');
      }
    }
  }

  int _calculateCategoryScore(int start, int end) {
    final categorySteps = end - start + 1;
    final successCount =
        stepResults.sublist(start, end + 1).where((result) => result).length;
    return (successCount / categorySteps * 100).round();
  }

  String _getScoreLevel(int score) {
    if (score >= 90) return '优秀';
    if (score >= 80) return '良好';
    if (score >= 70) return '一般';
    return '需要改进';
  }

  void pauseCheck() {
    _checkTimer?.cancel();
    isChecking.value = false;
  }

  void resumeCheck() {
    isChecking.value = true;
    _continueCheck();
  }

  void _continueCheck() {
    // 从当前步骤继续检测
    if (currentStep.value < steps.length) {
      startCheck();
    }
  }

  bool isStepSuccess(int index) {
    return index < stepResults.length ? stepResults[index] : false;
  }

  String getStepDescription(int index) {
    switch (index) {
      case 0:
        return '正在检查屏幕显示质量...';
      case 1:
        return '正在测试摄像头功能...';
      case 2:
        return '正在检查扬声器音质...';
      case 3:
        return '正在测试设备传感器...';
      case 4:
        return '正在检查电池健康状况...';
      case 5:
        return '正在测试网络连接状态...';
      case 6:
        return '正在检查存储空间使用情况...';
      case 7:
        return '正在测试GPS定位功能...';
      case 8:
        return '正在检查WiFi模块...';
      case 9:
        return '正在测试蓝牙功能...';
      default:
        return '正在进行检测...';
    }
  }

  String getStepDetails(int index) {
    if (index < stepResults.length && !stepResults[index]) {
      return '${steps[index]}异常';
    }
    switch (index) {
      case 0:
        return '检查屏幕亮度、色彩和触控响应';
      case 1:
        return '测试前后摄像头的成像质量';
      case 2:
        return '检查扬声器音量和音质表现';
      case 3:
        return '测试加速度计、陀螺仪等传感器';
      case 4:
        return '检查电池健康度和充电性能';
      case 5:
        return '测试移动网络信号强度和稳定性';
      case 6:
        return '分析存储空间使用情况和读写速度';
      case 7:
        return '检查GPS定位精度和响应速度';
      case 8:
        return '测试WiFi信号强度和连接稳定性';
      case 9:
        return '检查蓝牙配对和传输性能';
      default:
        return '';
    }
  }

  int getSuccessCount() {
    return stepResults.where((result) => result).length;
  }
}
