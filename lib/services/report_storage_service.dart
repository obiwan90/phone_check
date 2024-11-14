import 'package:hive_flutter/hive_flutter.dart';
import '../models/report_model.dart';

class ReportStorageService {
  static const String reportBoxName = 'reports';
  late Box<Report> _reportBox;

  Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ReportAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(CheckResultAdapter());
    }

    _reportBox = await Hive.openBox<Report>(reportBoxName);
  }

  Future<void> saveReport(Report report) async {
    await _reportBox.put(report.id, report);
  }

  List<Report> getAllReports() {
    return _reportBox.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> deleteReport(String id) async {
    await _reportBox.delete(id);
  }

  Future<void> deleteAllReports() async {
    await _reportBox.clear();
  }

  Report? getReport(String id) {
    return _reportBox.get(id);
  }

  Stream<List<Report>> watchReports() {
    return _reportBox.watch().map((_) => getAllReports());
  }

  bool get hasReports => _reportBox.isNotEmpty;

  int get reportCount => _reportBox.length;
}
