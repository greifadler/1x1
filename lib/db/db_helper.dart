import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'dart:async';
import '../models/calculation.dart'; // Adjust the path as necessary

class DBHelper {
  static Database? _database;
  static final DBHelper instance = DBHelper._instance();
  DBHelper._instance();

  String calculationsTable = 'calculations';
  String colId = 'id';
  String colFirstNumber = 'firstNumber';
  String colCalculationType = 'calculationType';
  String colSecondNumber = 'secondNumber';
  String colCorrect = 'correct';

  Future<Database> get database async {
    _database ??= await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'calculations.db';
    final calculationsDb =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return calculationsDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $calculationsTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colFirstNumber INTEGER, $colCalculationType TEXT, $colSecondNumber INTEGER, $colCorrect INTEGER)',
    );
  }

  Future<int> insertCalculation(Calculation calc, bool correct) async {
    Database db = await this.database;
    final Map<String, dynamic> calculationMap = {
      colFirstNumber: calc.firstNumber,
      colCalculationType: calc.calculationType.toString(),
      colSecondNumber: calc.secondNumber,
      colCorrect: correct ? 1 : 0,
    };
    final int result = await db.insert(calculationsTable, calculationMap);
    return result;
  }

  // Get stats by calculationType
  Future<CalculationStats> getStats() async {
    Database db = await this.database;
    List<Map<String, dynamic>> results = await db.rawQuery(
      'SELECT COUNT(*) as amount, SUM(CASE WHEN correct = 1 THEN 1 ELSE 0 END) as amountRight, SUM(CASE WHEN correct = 0 THEN 1 ELSE 0 END) as amountWrong FROM $calculationsTable',
      [],
    );
    if (results.isNotEmpty) {
      return CalculationStats.fromMap(results.first);
    } else {
      return CalculationStats(amount: 0, amountRight: 0, amountWrong: 0);
    }
  }

  // Get stats by secondNumber and calculationType
  Future<CalculationStats> getStatsBySecondNumberAndType(
      int secondNumber, CalculationType type) async {
    Database db = await this.database;
    List<Map<String, dynamic>> results = await db.rawQuery(
      'SELECT COUNT(*) as amount, SUM(CASE WHEN correct = 1 THEN 1 ELSE 0 END) as amountRight, SUM(CASE WHEN correct = 0 THEN 1 ELSE 0 END) as amountWrong FROM $calculationsTable WHERE $colSecondNumber = ? AND $colCalculationType = ?',
      [secondNumber, type.toString()],
    );
    if (results.isNotEmpty) {
      return CalculationStats.fromMap(results.first);
    } else {
      return CalculationStats(amount: 0, amountRight: 0, amountWrong: 0);
    }
  }

// Get stats by firstNumber, secondNumber, and calculationType
  Future<CalculationStats> getStatsByFirstSecondAndType(
      int firstNumber, int secondNumber, CalculationType type) async {
    Database db = await this.database;
    List<Map<String, dynamic>> results = await db.rawQuery(
      'SELECT COUNT(*) as amount, SUM(CASE WHEN correct = 1 THEN 1 ELSE 0 END) as amountRight, SUM(CASE WHEN correct = 0 THEN 1 ELSE 0 END) as amountWrong FROM $calculationsTable WHERE $colFirstNumber = ? AND $colSecondNumber = ? AND $colCalculationType = ?',
      [firstNumber, secondNumber, type.toString()],
    );
    if (results.isNotEmpty) {
      return CalculationStats.fromMap(results.first);
    } else {
      return CalculationStats(amount: 0, amountRight: 0, amountWrong: 0);
    }
  }

// Get stats by calculationType
  Future<CalculationStats> getStatsByType(CalculationType type) async {
    Database db = await this.database;
    List<Map<String, dynamic>> results = await db.rawQuery(
      'SELECT COUNT(*) as amount, SUM(CASE WHEN correct = 1 THEN 1 ELSE 0 END) as amountRight, SUM(CASE WHEN correct = 0 THEN 1 ELSE 0 END) as amountWrong FROM $calculationsTable WHERE $colCalculationType = ?',
      [type.toString()],
    );
    if (results.isNotEmpty) {
      return CalculationStats.fromMap(results.first);
    } else {
      return CalculationStats(amount: 0, amountRight: 0, amountWrong: 0);
    }
  }

  // Get stats by secondNumber and calculationType
  Future<CalculationStats> getStatsBySecondNumber(int secondNumber) async {
    Database db = await this.database;
    List<Map<String, dynamic>> results = await db.rawQuery(
      'SELECT COUNT(*) as amount, SUM(CASE WHEN correct = 1 THEN 1 ELSE 0 END) as amountRight, SUM(CASE WHEN correct = 0 THEN 1 ELSE 0 END) as amountWrong FROM $calculationsTable WHERE $colSecondNumber = ?',
      [secondNumber],
    );
    if (results.isNotEmpty) {
      return CalculationStats.fromMap(results.first);
    } else {
      return CalculationStats(amount: 0, amountRight: 0, amountWrong: 0);
    }
  }
}
