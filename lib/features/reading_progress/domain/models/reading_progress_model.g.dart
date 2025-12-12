// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_progress_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReadingProgressModelAdapter extends TypeAdapter<ReadingProgressModel> {
  @override
  final int typeId = 1;

  @override
  ReadingProgressModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReadingProgressModel(
      userId: fields[0] as String,
      bookId: fields[1] as String,
      page: fields[2] as int,
      chapter: fields[3] as String?,
      percentage: fields[4] as double,
      timestamp: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ReadingProgressModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.bookId)
      ..writeByte(2)
      ..write(obj.page)
      ..writeByte(3)
      ..write(obj.chapter)
      ..writeByte(4)
      ..write(obj.percentage)
      ..writeByte(5)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReadingProgressModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
