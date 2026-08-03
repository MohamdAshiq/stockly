// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StockHiveModelAdapter extends TypeAdapter<StockHiveModel> {
  @override
  final int typeId = 0;

  @override
  StockHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StockHiveModel(
      symbol: fields[0] as String,
      name: fields[1] as String,
      price: fields[2] as double,
      savedAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, StockHiveModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.symbol)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.savedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
