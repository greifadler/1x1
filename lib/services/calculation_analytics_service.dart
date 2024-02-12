// calculation_analytics_service.dart

import 'package:ein_mal_eins/db/db_helper.dart';
import 'package:ein_mal_eins/models/calculation.dart'; // Adjust the path as necessary

class CalculationAnalyticsService {
  final DBHelper _dbHelper = DBHelper.instance;

  List<int> _getNumbersByRowAndType(int row, CalculationType type) {
    List<int> numbers = [];

    for (int i = 1; i < 11; i++) {
      switch (type) {
        case CalculationType.MAL:
          numbers.add(i);
        case CalculationType.DIV:
          numbers.add(i * row);
        case CalculationType.IN:
          numbers.add(i * row);
        default:
      }
    }

    return numbers;
  }

  Map<int, Future<CalculationStats>> getDetailStatsListByRowAndType(
      int row, CalculationType type) {
    Map<int, Future<CalculationStats>> resultMap = {};

    var numbers = _getNumbersByRowAndType(row, type);

    for (var number in numbers) {
      resultMap[number] = getStatsByNumberRowAndType(number, row, type);
    }

    return resultMap;
  }

  Future<CalculationStats> getStatsByNumberRowAndType(
      int number, int row, CalculationType type) async {
    switch (type) {
      case CalculationType.MAL:
        return await _dbHelper.getStatsByFirstSecondAndType(number, row, type);
      case CalculationType.DIV:
        return await _dbHelper.getStatsByFirstSecondAndType(number, row, type);
      case CalculationType.IN:
        return await _dbHelper.getStatsByFirstSecondAndType(row, number, type);
    }
  }

  Future<CalculationStats> getStatsByType(CalculationType type) async {
    return await _dbHelper.getStatsByType(type);
  }

  Future<CalculationStats> getStatsByRow(int row) async {
    return await _dbHelper.getStatsBySecondNumber(row);
  }

  Future<CalculationStats> getFullStats() async {
    return await _dbHelper.getStats();
  }
}
