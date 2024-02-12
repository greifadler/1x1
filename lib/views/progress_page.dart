// progress_page.dart
import 'package:flutter/material.dart';
import '../services/calculation_analytics_service.dart';
import '../models/calculation.dart';
import '../widgets/calculation_stats_circle_indicator.dart';
import '../widgets/calculation_stats_row_indicator.dart';
import 'progress_details_page.dart';

class ProgressPage extends StatelessWidget {
  final CalculationAnalyticsService analyticsService =
      CalculationAnalyticsService();

  ProgressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FutureBuilder<CalculationStats>(
            future: analyticsService.getFullStats(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasData) {
                return CalculationStatsRowIndicator(
                    title: 'Gesamtstatistik', stats: snapshot.data!);
              } else {
                return Text("Keine Daten");
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <CalculationType>[
                CalculationType.MAL,
                CalculationType.DIV,
                CalculationType.IN,
              ]
                  .map((type) => CalculationStatsCircleIndicator(
                        type: type,
                      ))
                  .toList(),
            ),
          ),
          ...List.generate(10, (index) {
            return FutureBuilder<CalculationStats>(
              future: analyticsService.getStatsByRow(index + 1),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProgressDetailsPage(row: index + 1),
                        ),
                      );
                    },
                    child: CalculationStatsRowIndicator(
                      title: '${index + 1}er Reihe',
                      stats: snapshot.data!,
                    ),
                  );
                } else {
                  return Text("Keine Daten für Reihe ${index + 1}");
                }
              },
            );
          }),
        ],
      ),
    );
  }
}
