import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/pod_data_model.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  factory DbHelper() => _instance;
  DbHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'RADIANT_DATABASE.db');
    return await openDatabase(
      path,
      version: 2, // Bumped version for schema change
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Drop and recreate table to fix duplicate issue
          await db.execute('DROP TABLE IF EXISTS PODList_UploadImage');
          await db.execute('''
            CREATE TABLE PODList_UploadImage (
              PODNo TEXT PRIMARY KEY,
              Photograph TEXT,
              Done TEXT
            )
          ''');
        }
      },
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE PODList_UploadImage (
        PODNo TEXT PRIMARY KEY,
        Photograph TEXT,
        Done TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE tbl_UndeliveredPOD (
        DRSNo TEXT,
        DocketNo TEXT PRIMARY KEY,
        WebDeliveredStatus INTEGER,
        OfflineDeliveredStatus INTEGER,
        OfflineUploadStatus TEXT,
        PODSyncStatus INTEGER,
        OfflineDeliveredDate TEXT,
        PODSyncDate TEXT,
        ErrorCode TEXT,
        imagepath TEXT,
        DOCKSF TEXT
      )
    ''');
  }

  Future<void> insertPODNoList(String podNo, String path) async {
    final db = await database;
    await db.insert(
      'PODList_UploadImage',
      {'PODNo': podNo, 'Photograph': path, 'Done': '0'},
      conflictAlgorithm: ConflictAlgorithm.ignore, // Ignore if already exists
    );
  }

  Future<void> updatePODNoList(String podNo, String path) async {
    final db = await database;
    await db.update(
      'PODList_UploadImage',
      {'Done': '1', 'Photograph': path},
      where: 'PODNo = ?',
      whereArgs: [podNo],
    );
  }

  Future<List<PodData>> selectDocketnoList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('PODList_UploadImage');
    return List.generate(maps.length, (i) {
      return PodData(
        dOCKNO: maps[i]['PODNo'],
        imagePath: maps[i]['Photograph'],
        scanStatus: maps[i]['Done'],
      );
    });
  }

  Future<List<PodData>> selectDocketForBackService(String status) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'PODList_UploadImage',
      where: "Done = ? AND Photograph != ''",
      whereArgs: [status],
      limit: 1,
    );
    return List.generate(maps.length, (i) {
      return PodData(
        dOCKNO: maps[i]['PODNo'],
        imagePath: maps[i]['Photograph'],
        scanStatus: maps[i]['Done'],
      );
    });
  }

  Future<void> deletePODNo(String podNo) async {
    final db = await database;
    await db.delete(
      'PODList_UploadImage',
      where: 'PODNo = ?',
      whereArgs: [podNo],
    );
  }

  // --- Mark Delivered Methods ---
  Future<void> insertUndeliveredPODNo(PodData data) async {
    final db = await database;
    await db.insert(
      'tbl_UndeliveredPOD',
      {
        'DRSNo': data.dRS,
        'DocketNo': data.dOCKNO,
        'WebDeliveredStatus': 0,
        'OfflineDeliveredStatus': 0,
        'OfflineUploadStatus': '0',
        'PODSyncStatus': 0,
        'OfflineDeliveredDate': '0',
        'PODSyncDate': '0',
        'ErrorCode': '0',
        'imagepath': data.imagePath,
        'DOCKSF': data.dOCKSF,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PodData>> selectUndeliveredPODList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tbl_UndeliveredPOD');
    return List.generate(maps.length, (i) {
      return PodData(
        dRS: maps[i]['DRSNo'],
        dOCKNO: maps[i]['DocketNo'],
        imagePath: maps[i]['imagepath'],
        scanStatus: maps[i]['OfflineUploadStatus'],
        dOCKSF: maps[i]['DOCKSF'],
      );
    });
  }
}
