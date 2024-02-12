import 'dart:math';
import '../models/calculation.dart';
import '../db/db_helper.dart';

class CalculationService {
  static final _random = Random();

  static List<Calculation> generateCalculations(
      Set<int> selectedMathRows, Set<CalculationType> selectedOperations,
      {int amount = 10}) {
    List<Calculation> calculations = [];

    // Ensure there are items to choose from
    if (selectedMathRows.isEmpty || selectedOperations.isEmpty) {
      return calculations; // Return empty if no selections
    }

    for (int i = 0; i < amount; i++) {
      int firstNumber =
          _random.nextInt(10) + 1; // Random value between 1 and 10
      CalculationType calculationType = selectedOperations
          .elementAt(_random.nextInt(selectedOperations.length));
      int secondNumber =
          selectedMathRows.elementAt(_random.nextInt(selectedMathRows.length));

      int correctResult = firstNumber * secondNumber;

      switch (calculationType) {
        case CalculationType.DIV:
          //here we just change the result and the first number to get to the right result
          var helper = firstNumber;
          firstNumber = correctResult;
          correctResult = helper;
        case CalculationType.IN:
          var helper = firstNumber;
          firstNumber = correctResult;
          correctResult = helper;

          helper = firstNumber;
          firstNumber = secondNumber;
          secondNumber = helper;
        case CalculationType.MAL:
        default:
        //MAL
      }

      calculations.add(Calculation(
        firstNumber: firstNumber,
        calculationType: calculationType,
        secondNumber: secondNumber,
        correctResult: correctResult,
      ));
    }

    return calculations;
  }

  static bool checkCalculation(Calculation calc, int result) {
    bool isCorrect = calc.correctResult == result;
    DBHelper.instance.insertCalculation(calc, isCorrect);
    return isCorrect;
  }
}
