import 'package:wordle_game/src/data_source/word_list/vocab.dart';

abstract class WordListDatabase{

  Future<Vocab?> findWord(String word);

  Future<bool> isWordExist(String word);

  Future<String> getRandomWord();

  Future<String> getTargetWord();


}