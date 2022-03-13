// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayingGameStateAdapter extends TypeAdapter<PlayingGameState> {
  @override
  final int typeId = 6;

  @override
  PlayingGameState read(BinaryReader reader) {
    return PlayingGameState();
  }

  @override
  void write(BinaryWriter writer, PlayingGameState obj) {
    writer..writeByte(0);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayingGameStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EndGameStateAdapter extends TypeAdapter<EndGameState> {
  @override
  final int typeId = 7;

  @override
  EndGameState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EndGameState(
      hasWon: fields[0] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, EndGameState obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.hasWon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EndGameStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
