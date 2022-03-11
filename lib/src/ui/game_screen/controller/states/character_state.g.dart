// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InitialCharacterStateAdapter extends TypeAdapter<InitialCharacterState> {
  @override
  final int typeId = 2;

  @override
  InitialCharacterState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InitialCharacterState(
      fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, InitialCharacterState obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.char);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InitialCharacterStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RightCharacterRightPositionStateAdapter
    extends TypeAdapter<RightCharacterRightPositionState> {
  @override
  final int typeId = 3;

  @override
  RightCharacterRightPositionState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RightCharacterRightPositionState(
      fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RightCharacterRightPositionState obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.char);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RightCharacterRightPositionStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RightCharacterWrongPositionStateAdapter
    extends TypeAdapter<RightCharacterWrongPositionState> {
  @override
  final int typeId = 4;

  @override
  RightCharacterWrongPositionState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RightCharacterWrongPositionState(
      fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RightCharacterWrongPositionState obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.char);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RightCharacterWrongPositionStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WrongCharacterStateAdapter extends TypeAdapter<WrongCharacterState> {
  @override
  final int typeId = 5;

  @override
  WrongCharacterState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WrongCharacterState(
      fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WrongCharacterState obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.char);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WrongCharacterStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
