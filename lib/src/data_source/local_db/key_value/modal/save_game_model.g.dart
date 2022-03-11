// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_game_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SaveGameModelAdapter extends TypeAdapter<SaveGameModel> {
  @override
  final int typeId = 0;

  @override
  SaveGameModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SaveGameModel()
      ..targetWord = fields[0] as String
      ..gameBoardStateList = (fields[1] as List).cast<CharacterState>();
  }

  @override
  void write(BinaryWriter writer, SaveGameModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.targetWord)
      ..writeByte(1)
      ..write(obj.gameBoardStateList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaveGameModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
