import 'package:wordle_game/src/data_source/word_list/vocab.dart';

abstract class WordListDatabase{

  Future<Vocab?> findWord(String word);

}