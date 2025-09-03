import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:slc/db/table_common.dart';
import 'package:slc/db/table_data.dart';
import 'package:slc/db/table_facility.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/utils/constant.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, TableDetails.DB_NAME);
    var theDb = await openDatabase(
      path,
      version: TableDetails.DB_VERSION,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute("CREATE TABLE " +
        TableDetails.TABLE_COMMON +
        " (" +
        TableDetails.TABLE_COMMON_ID +
        " INTEGER PRIMARY KEY, " +
        TableDetails.TABLE_COMMON_CID +
        " INTEGER, " +
        TableDetails.TABLE_COMMON_ENGLISH +
        " TEXT, " +
        TableDetails.TABLE_COMMON_ARABIC +
        " TEXT)");

    await db.execute("CREATE TABLE " +
        TableDetails.TABLE_FACILITY +
        " (" +
        TableDetails.TABLE_FACILITY_ID +
        " INTEGER PRIMARY KEY, " +
        TableDetails.TABLE_FACILITY_CID +
        " TEXT, " +
        TableDetails.TABLE_FACILITY_ENGLISH +
        " TEXT, " +
        TableDetails.TABLE_FACILITY_ARABIC +
        " TEXT)");
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // When upgrading the db, create/update the table
//    if (oldVersion < newVersion) {
//      await db.execute("CREATE TABLE " +
//          TableDetails.TABLE_FACILITY +
//          " (" +
//          TableDetails.TABLE_FACILITY_ID +
//          " INTEGER PRIMARY KEY, " +
//          TableDetails.TABLE_FACILITY_CID +
//          " TEXT, " +
//          TableDetails.TABLE_FACILITY_ENGLISH +
//          " TEXT, " +
//          TableDetails.TABLE_FACILITY_ARABIC +
//          " TEXT)");
//    }
  }

  Future<int> saveContent(Map<String, dynamic> user, String tableName) async {
    var dbClient = await db;
    int res = await dbClient.insert(tableName, user);
    return res;
  }

  Future<List<CommonTable>> getContent() async {
    var dbClient = await db;
    List<Map> list =
        await dbClient.rawQuery('SELECT * FROM ' + TableDetails.TABLE_COMMON);
    List<CommonTable> employees = [];
    for (int i = 0; i < list.length; i++) {
      var user = new CommonTable(
          cid: list[i][TableDetails.TABLE_COMMON_CID],
          englishContent: list[i][TableDetails.TABLE_COMMON_ENGLISH],
          arabicContent: list[i][TableDetails.TABLE_COMMON_ARABIC]);
      user.setId(list[i][TableDetails.TABLE_COMMON_ID]);
      employees.add(user);
    }
    // print(employees.length);
    return employees;
  }

  Future<CommonTable> getContentByCID(String cid) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM ' +
        TableDetails.TABLE_COMMON +
        ' WHERE ' +
        TableDetails.TABLE_COMMON_CID +
        '= "$cid"');
    List<CommonTable> content = [];
    for (int i = 0; i < list.length; i++) {
      var user = new CommonTable(
          cid: list[i][TableDetails.TABLE_COMMON_CID],
          englishContent: list[i][TableDetails.TABLE_COMMON_ENGLISH],
          arabicContent: list[i][TableDetails.TABLE_COMMON_ARABIC]);
      user.setId(list[i][TableDetails.TABLE_COMMON_ID]);
      content.add(user);
    }
    // print(content.length);
//    return content[0];
    return content.length > 0 ? content[0] : null;
  }

  Future<FacilityTable> getFacilityContentByCID(String cid) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM ' +
        TableDetails.TABLE_FACILITY +
        ' WHERE ' +
        TableDetails.TABLE_FACILITY_CID +
        ' = "$cid"');
    List<FacilityTable> content = [];
    for (int i = 0; i < list.length; i++) {
      var user = new FacilityTable(
          cid: list[i][TableDetails.TABLE_FACILITY_CID],
          englishContent: list[i][TableDetails.TABLE_FACILITY_ENGLISH],
          arabicContent: list[i][TableDetails.TABLE_FACILITY_ARABIC]);
      user.setId(list[i][TableDetails.TABLE_FACILITY_ID]);
      content.add(user);
    }
    return content.length > 0 ? content[0] : null;
  }

  Future<int> delete(String cid) async {
    CommonTable commonTable = await getContentByCID(cid);
    var dbClient = await db;

    int res = await dbClient.rawDelete(
        'DELETE FROM ' + TableDetails.TABLE_COMMON + ' WHERE id = ?',
        [commonTable.id]);
    return res;
  }

  Future<bool> updateContent(CommonTable user) async {
    var dbClient = await db;
    int res = await dbClient.update(TableDetails.TABLE_COMMON, user.toJson(),
        where: "id = ?", whereArgs: <int>[user.id]);
    return res > 0 ? true : false;
  }

  Future<bool> saveOrUpdateContent(String cid, String content) async {
    var dbClient = await db;
    int res = 0;
    CommonTable temp = await getContentByCID(cid);

    if (temp == null) {
      var commonTable = perpareData(cid, content, null);
      res = await dbClient.insert(
          TableDetails.TABLE_COMMON, commonTable.toJson());
    } else {
      var commonTable = perpareData(cid, content, temp);
      res = await dbClient.update(
          TableDetails.TABLE_COMMON, commonTable.toJson(),
          where: "id = ?", whereArgs: <int>[temp.id]);
    }
    return res > 0 ? true : false;
  }

  Future<bool> saveOrUpdateFacilityContent(String cid, String content) async {
    var dbClient = await db;
    int res = 0;
    FacilityTable temp = await getFacilityContentByCID(cid);

    if (temp == null) {
      var commonTable = perpareFacilityData(cid, content, null);
      res = await dbClient.insert(
          TableDetails.TABLE_FACILITY, commonTable.toJson());
    } else {
      var commonTable = perpareFacilityData(cid, content, temp);
      res = await dbClient.update(
          TableDetails.TABLE_FACILITY, commonTable.toJson(),
          where: "id = ?", whereArgs: <int>[temp.id]);
    }
    return res > 0 ? true : false;
  }

  CommonTable perpareData(String cid, String content, CommonTable temp) {
    CommonTable commonTable = new CommonTable();

    if (SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
            Constants.LANGUAGE_ENGLISH ||
        SPUtil.getInt(Constants.CURRENT_LANGUAGE) == 0) {
      commonTable.cid = cid;
      commonTable.englishContent = content;
    } else if (SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
        Constants.LANGUAGE_ARABIC) {
      commonTable.arabicContent = content;
      commonTable.cid = cid;
    }
    if (null != temp) {
      if (SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
              Constants.LANGUAGE_ENGLISH ||
          SPUtil.getInt(Constants.CURRENT_LANGUAGE) == 0) {
        commonTable.arabicContent = temp.arabicContent;
      } else if (SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
          Constants.LANGUAGE_ARABIC) {
        commonTable.englishContent = temp.englishContent;
      }
    }
    return commonTable;
  }

  FacilityTable perpareFacilityData(
      String cid, String content, FacilityTable temp) {
    FacilityTable commonTable = new FacilityTable();

    if (SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
            Constants.LANGUAGE_ENGLISH ||
        SPUtil.getInt(Constants.CURRENT_LANGUAGE) == 0) {
      commonTable.cid = cid;
      commonTable.englishContent = content;
    } else if (SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
        Constants.LANGUAGE_ARABIC) {
      commonTable.arabicContent = content;
      commonTable.cid = cid;
    }
    if (null != temp) {
      if (SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
              Constants.LANGUAGE_ENGLISH ||
          SPUtil.getInt(Constants.CURRENT_LANGUAGE) == 0) {
        commonTable.arabicContent = temp.arabicContent;
      } else if (SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
          Constants.LANGUAGE_ARABIC) {
        commonTable.englishContent = temp.englishContent;
      }
    }
    return commonTable;
  }
}
