import 'package:chatapptask/connection/database.dart';
import 'package:sqflite/sqflite.dart';


class Repository {
  DatabaseConnection _databaseConnection;

  Repository() {
    _databaseConnection = DatabaseConnection();
  }

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _databaseConnection.setDatabase();
    return _database;
  }

  insertData(table, data) async {
    var connection = await database;
    return await connection.insert(table, data);
  }

  readDatabySender(table, sender, receiver) async {
    var connection = await database;
    return await connection.query(
        table, where: '(sender=? or sender=?) and (receiver=? or receiver=?)', whereArgs: [sender, receiver, sender, receiver]);
  }

  readFriends(table, user) async {
    var connection = await database;
    return await connection.query(
        table, where: 'sender=? or receiver=?', whereArgs: [user, user]);
  }
}
//'id IN (${ids.join(', ')})'
//'sender=? or sender=? and receiver=? or receiver=?', whereArgs: [sender, receiver, sender, receiver]