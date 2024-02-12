import 'package:flutter/material.dart';
import 'package:ein_mal_eins/services/calculation_analytics_service.dart';
import 'package:ein_mal_eins/models/calculation.dart'; // Adjust the path as necessary

class CalculationStatsCircleIndicator extends StatelessWidget {
  final CalculationType type;

  const CalculationStatsCircleIndicator({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CalculationAnalyticsService analyticsService =
        CalculationAnalyticsService();

    return FutureBuilder<CalculationStats>(
      future: analyticsService.getStatsByType(type),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          final stats = snapshot.data!;
          final double total = stats.amount.toDouble();
          final double fractionCorrect =
              total > 0 ? stats.amountRight / total : 0;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: fractionCorrect,
                      backgroundColor: Colors.red,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      strokeWidth: 10,
                    ),
                    Center(
                        child: Text('${stats.amountRight}/${total.toInt()}')),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(type.label),
            ],
          );
        } else {
          return Text("No data");
        }
      },
    );
  }
}
