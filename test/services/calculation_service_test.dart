import 'package:flutter_test/flutter_test.dart';
import 'package:ein_mal_eins/models/calculation.dart'; // Update this path
import 'package:ein_mal_eins/services/calculation_service.dart'; // Update this path

void main() {
  group('CalculationService Tests', () {
    test('generateCalculations returns empty list for empty inputs', () {
      var calculations = CalculationService.generateCalculations({}, {});
      expect(calculations.isEmpty, true);
    });

    test('generateCalculations generates correct amount of calculations', () {
      var calculations = CalculationService.generateCalculations(
          {1, 2}, {CalculationType.MAL},
          amount: 5);
      expect(calculations.length, 5);
    });

    test('generateCalculations generates calculations with correct types', () {
      var calculations = CalculationService.generateCalculations(
          {1}, {CalculationType.MAL, CalculationType.DIV},
          amount: 20);
      var hasMal =
          calculations.any((c) => c.calculationType == CalculationType.MAL);
      var hasDiv =
          calculations.any((c) => c.calculationType == CalculationType.DIV);
      expect(hasMal, true);
      expect(hasDiv, true);
    });

    // Add more tests as needed
  });
}
