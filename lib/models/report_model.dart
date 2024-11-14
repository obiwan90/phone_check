import 'package:hive/hive.dart';

part 'report_model.g.dart';

@HiveType(typeId: 0)
class Report {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String deviceModel;

  @HiveField(2)
  final int score;

  @HiveField(3)
  final String scoreLevel;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final Map<String, dynamic> checkResults;

  @HiveField(6)
  final List<String> suggestions;

  @HiveField(7)
  final Map<String, int> categoryScores;

  Report({
    required this.id,
    required this.deviceModel,
    required this.score,
    required this.scoreLevel,
    required this.createdAt,
    required this.checkResults,
    required this.suggestions,
    required this.categoryScores,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] as String,
      deviceModel: json['deviceModel'] as String,
      score: json['score'] as int,
      scoreLevel: json['scoreLevel'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      checkResults: Map<String, dynamic>.from(json['checkResults'] as Map),
      suggestions: List<String>.from(json['suggestions'] as List),
      categoryScores: Map<String, int>.from(json['categoryScores'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deviceModel': deviceModel,
      'score': score,
      'scoreLevel': scoreLevel,
      'createdAt': createdAt.toIso8601String(),
      'checkResults': checkResults,
      'suggestions': suggestions,
      'categoryScores': categoryScores,
    };
  }
}

@HiveType(typeId: 1)
class CheckResult {
  @HiveField(0)
  final String status;

  @HiveField(1)
  final String info;

  CheckResult({
    required this.status,
    required this.info,
  });

  factory CheckResult.fromJson(Map<String, dynamic> json) {
    return CheckResult(
      status: json['status'] as String,
      info: json['info'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'info': info,
    };
  }
}
