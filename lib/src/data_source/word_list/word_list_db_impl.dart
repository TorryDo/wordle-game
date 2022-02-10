import 'package:sqflite/sqflite.dart';
import 'package:wordle_game/src/data_source/word_list/vocab.dart';
import 'package:wordle_game/src/data_source/word_list/word_list_db.dart';

class WordListDataBaseImpl implements WordListDatabase {

  final Future<Database> futureDatabase;

  const WordListDataBaseImpl({required this.futureDatabase});

  @override
  Future<Vocab?> findWord(String word) async{

    final db = await futureDatabase;

    final wordInLowerCase = word.toLowerCase();

    final List<Map<String, dynamic>> maps = await db.query('words');

    final list = List.generate(maps.length, (i) {
      return Vocab(
        title: maps[i]['word']
      );
    });

    if(list.contains(wordInLowerCase)) {
      return Vocab(title: word);
    }

    return null;
  }

}