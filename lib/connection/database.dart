import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection {
  setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    print('db path: '+directory.path);
    var path = join(directory.path, 'chat.db');
    var database = await openDatabase(path, version: 1, onCreate: _onCreatingDatabase);

    return database;
  }

  _onCreatingDatabase(Database database, int version) async {

    await database.execute('CREATE TABLE chats(sender TEXT, receiver TEXT, message TEXT)');
  }
}