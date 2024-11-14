// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReportAdapter extends TypeAdapter<Report> {
  @override
  final int typeId = 0;

  @override
  Report read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Report(
      id: fields[0] as String,
      deviceModel: fields[1] as String,
      score: fields[2] as int,
      scoreLevel: fields[3] as String,
      createdAt: fields[4] as DateTime,
      checkResults: (fields[5] as Map).cast<String, dynamic>(),
      suggestions: (fields[6] as List).cast<String>(),
      categoryScores: (fields[7] as Map).cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, Report obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.deviceModel)
      ..writeByte(2)
      ..write(obj.score)
      ..writeByte(3)
      ..write(obj.scoreLevel)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.checkResults)
      ..writeByte(6)
      ..write(obj.suggestions)
      ..writeByte(7)
      ..write(obj.categoryScores);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CheckResultAdapter extends TypeAdapter<CheckResult> {
  @override
  final int typeId = 1;

  @override
  CheckResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CheckResult(
      status: fields[0] as String,
      info: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CheckResult obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.status)
      ..writeByte(1)
      ..write(obj.info);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CheckResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
