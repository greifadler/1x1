import 'package:flutter/material.dart';
import '../models/calculation.dart'; // Adjust the path as necessary
import '../services/calculation_analytics_service.dart'; // Adjust the path as necessary
import '../widgets/calculation_stats_row_indicator.dart'; // Adjust the path as necessary

class ProgressDetailsPage extends StatefulWidget {
  final int row;

  const ProgressDetailsPage({Key? key, required this.row}) : super(key: key);

  @override
  _ProgressDetailsPageState createState() => _ProgressDetailsPageState();
}

class _ProgressDetailsPageState extends State<ProgressDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CalculationAnalyticsService _analyticsService =
      CalculationAnalyticsService();

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: CalculationType.values.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.row}er Reihe'),
        bottom: TabBar(
          controller: _tabController,
          tabs: CalculationType.values
              .map((type) => Tab(text: type.label))
              .toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: CalculationType.values
            .map((type) => _buildTabContent(widget.row, type))
            .toList(),
      ),
    );
  }

  Widget _buildTabContent(int row, CalculationType type) {
    return FutureBuilder<List<Widget>>(
      future: _buildStatsWidgets(row, type), // Use the new method here
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: ListView(
              children: snapshot.data!, // Directly use the list of widgets
            ),
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }

  Future<List<Widget>> _buildStatsWidgets(int row, CalculationType type) async {
    var details =
        await _analyticsService.getDetailStatsListByRowAndType(row, type);
    List<Widget> widgets = [];

    for (var entry in details.entries) {
      var key = entry.key;
      var statsFuture = entry.value;
      var stats = await statsFuture; // Await the future
      var widget = CalculationStatsRowIndicator(
          title: type.printCalc(row, key), stats: stats);
      widgets.add(widget);
    }

    return widgets;
  }
}
