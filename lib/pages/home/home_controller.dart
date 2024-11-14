import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class HomeController extends GetxController {
  final isLoading = true.obs;
  final deviceModel = ''.obs;
  final totalStorage = ''.obs;
  final batteryLevel = ''.obs;

  final _battery = Battery();

  @override
  void onInit() {
    super.onInit();
    _loadDeviceInfo();
    _monitorBattery();
  }

  Future<void> _loadDeviceInfo() async {
    try {
      isLoading.value = true;
      final deviceInfo = DeviceInfoPlugin();

      if (GetPlatform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;

        // 完整的设备型号映射
        final deviceName = _getiOSDeviceName(iosInfo.utsname.machine ?? '');
        deviceModel.value = deviceName;

        // 存储信息
        final storage = await _getStorageSpace();
        totalStorage.value = storage;
      } else if (GetPlatform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceModel.value = '${androidInfo.manufacturer} ${androidInfo.model}';

        // 获取内存和存储信息
        final processInfo = await Process.run('cat', ['/proc/meminfo']);
        if (processInfo.exitCode == 0) {
          final output = processInfo.stdout as String;
          final match = RegExp(r'MemTotal:\s+(\d+)').firstMatch(output);
          if (match != null) {
            final totalRamGb =
                (int.parse(match.group(1)!) / (1024 * 1024)).toStringAsFixed(1);
            final storage = await _getStorageSpace();
            totalStorage.value = '$totalRamGb GB + $storage';
          }
        }
      }
    } catch (e) {
      debugPrint('获取设备信息失败: $e');
      deviceModel.value = 'Unknown';
      totalStorage.value = 'Unknown';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _monitorBattery() async {
    try {
      // 获取初始电量并设置
      final level = await _battery.batteryLevel;
      batteryLevel.value = '$level%';

      // 监听电量变化
      _battery.onBatteryStateChanged.listen((BatteryState state) async {
        final level = await _battery.batteryLevel;
        batteryLevel.value = '$level%';
      });
    } catch (e) {
      debugPrint('获取电池信息失败: $e');
      batteryLevel.value = 'Unknown';
    }
  }

  Future<String> _getStorageSpace() async {
    try {
      if (GetPlatform.isIOS) {
        final directory = await getApplicationDocumentsDirectory();
        final stat = await directory.parent.parent.statSync();
        final totalSpace = stat.size;
        final totalGb = (totalSpace / (1024 * 1024 * 1024)).toStringAsFixed(0);
        return '$totalGb GB';
      } else {
        // Android存储信息
        final processInfo = await Process.run('df', ['/data']);
        if (processInfo.exitCode == 0) {
          final output = processInfo.stdout as String;
          final lines = output.split('\n');
          if (lines.length > 1) {
            final parts = lines[1].split(RegExp(r'\s+'));
            if (parts.length > 1) {
              final totalKb = int.tryParse(parts[1]) ?? 0;
              final totalGb = (totalKb / (1024 * 1024)).toStringAsFixed(0);
              return '$totalGb GB';
            }
          }
        }
        return 'Unknown';
      }
    } catch (e) {
      debugPrint('获取存储空间失败: $e');
      return 'Unknown';
    }
  }

  String _getiOSDeviceName(String identifier) {
    final deviceNames = {
      'iPhone14,2': 'iPhone 13 Pro',
      'iPhone14,3': 'iPhone 13 Pro Max',
      'iPhone14,4': 'iPhone 13 Mini',
      'iPhone14,5': 'iPhone 13',
      'iPhone15,2': 'iPhone 14 Pro',
      'iPhone15,3': 'iPhone 14 Pro Max',
      'iPhone15,4': 'iPhone 14',
      'iPhone15,5': 'iPhone 14 Plus',
      'iPhone16,1': 'iPhone 15 Pro',
      'iPhone16,2': 'iPhone 15 Pro Max',
      'iPhone16,3': 'iPhone 15',
      'iPhone16,4': 'iPhone 15 Plus',
      'iPhone17,1': 'iPhone 16',
      'iPhone17,2': 'iPhone 16 Pro Max',
      'iPhone17,3': 'iPhone 16 Pro',
      'iPhone17,4': 'iPhone 16 Plus',
    };
    return deviceNames[identifier] ?? identifier;
  }

  String getDeviceModel() => deviceModel.value;
  String getTotalStorage() => totalStorage.value;
  String getBatteryLevel() => batteryLevel.value;

  void startCheck() {
    Get.toNamed('/check');
  }
}
