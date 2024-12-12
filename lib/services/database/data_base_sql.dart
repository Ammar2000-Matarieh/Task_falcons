import 'package:sqflite/sqflite.dart';
import 'package:task_falcons/models/items/items_master.dart';
import 'package:task_falcons/models/merged_data.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await openDatabase(
      'inventory.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE Items(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            itemno TEXT,
            name TEXT,
            qty TEXT,
            isLowQuantity INTEGER
          )
        ''');
      },
    );
    return _database!;
  }

  Future<void> insertMergedItems(List<MergedData> items) async {
    final db = await database;
    for (var item in items) {
      await db.insert(
        'Items',
        {
          'itemno': item.item.iTEMNO,
          'name': item.item.nAME,
          'qty': item.quantity,
          'isLowQuantity': int.parse(
                    item.quantity ?? '0.0',
                  ) <
                  5
              ? 1
              : 0
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<MergedData>> getAllItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Items',
    );

    return List.generate(maps.length, (i) {
      return MergedData(
        item: ItemsMaster(
          iTEMNO: maps[i]['itemno'],
          nAME: maps[i]['name'],
        ),
        quantity: maps[i]['qty'],
      );
    });
  }
}
