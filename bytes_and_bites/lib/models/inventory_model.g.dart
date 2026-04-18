// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InventoryModelAdapter extends TypeAdapter<InventoryModel> {
  @override
  final int typeId = 1;

  @override
  InventoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InventoryModel(
      name: fields[0] as String,
      quantity: fields[1] as int,
      categoryName: fields[2] as String,
      lowStockThreshold: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, InventoryModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.categoryName)
      ..writeByte(3)
      ..write(obj.lowStockThreshold);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InventoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
