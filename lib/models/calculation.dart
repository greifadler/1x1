import 'package:flutter/material.dart';

enum CalculationType { MAL, DIV, IN }

extension CalculationTypeExtension on CalculationType {
  String get label {
    switch (this) {
      case CalculationType.MAL:
        return 'MAL';
      case CalculationType.DIV:
        return 'DIVIDIEREN';
      case CalculationType.IN:
        return 'IN';
      default:
        return '';
    }
  }

  String get symbol {
    switch (this) {
      case CalculationType.MAL:
        return '⋅';
      case CalculationType.DIV:
        return ':';
      case CalculationType.IN:
        return 'in';
      default:
        return '';
    }
  }

  Color get color {
    switch (this) {
      case CalculationType.MAL:
        return Colors.orange;
      case CalculationType.DIV:
        return Colors.pink;
      case CalculationType.IN:
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  String printCalc(int row, int number) {
    switch (this) {
      case CalculationType.MAL:
        return '$number $symbol $row';
      case CalculationType.DIV:
        return '$number $symbol $row';
      case CalculationType.IN:
        return '$row $symbol $number';
    }
  }
}

class Calculation {
  int firstNumber;
  CalculationType calculationType;
  int secondNumber;
  int correctResult;

  Calculation({
    required this.firstNumber,
    required this.calculationType,
    required this.secondNumber,
    required this.correctResult,
  });
}

class CalculationStats {
  final int amount;
  final int amountRight;
  final int amountWrong;

  CalculationStats({
    required this.amount,
    required this.amountRight,
    required this.amountWrong,
  });

  factory CalculationStats.fromMap(Map<String, dynamic> map) {
    return CalculationStats(
      amount: map['amount'] ?? 0,
      amountRight: map['amountRight'] ?? 0,
      amountWrong: map['amountWrong'] ?? 0,
    );
  }
}
