// row_stats_widget.dart
import 'package:flutter/material.dart';
import '../models/calculation.dart'; // Adjust the path as necessary

class CalculationStatsRowIndicator extends StatelessWidget {
  final String title;
  final CalculationStats stats;

  const CalculationStatsRowIndicator({
    Key? key,
    required this.title,
    required this.stats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double total = stats.amount.toDouble();
    final double fractionCorrect = (total > 0) ? stats.amountRight / total : 0;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headline6),
          SizedBox(height: 4),
          Stack(
            children: [
              Container(
                height: 20,
                width: screenWidth - 48, // Adjusted for padding
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(
                height: 20,
                width: (screenWidth - 48) *
                    fractionCorrect, // Adjusted for padding and fraction
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
              'Richtig: ${stats.amountRight}, Falsch: ${stats.amountWrong} (Gesamt: ${stats.amount})'),
        ],
      ),
    );
  }
}
