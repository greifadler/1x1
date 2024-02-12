import 'package:flutter/material.dart';
import '../models/calculation.dart';
import '../services/calculation_service.dart';
import 'play_finished_page.dart';

class PlayPage extends StatefulWidget {
  final Set<CalculationType> selectedOperations;
  final Set<int> selectedMathRows;

  PlayPage({
    Key? key,
    required this.selectedMathRows,
    required this.selectedOperations,
  }) : super(key: key);

  @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage>
    with SingleTickerProviderStateMixin {
  late List<Calculation> calculations;
  late TabController _tabController;
  List<bool?> answers = List.filled(
      10, null); // true for correct, false for incorrect, null for unanswered

  // New: Lists for FocusNodes and TextEditingControllers
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    calculations = CalculationService.generateCalculations(
        widget.selectedMathRows, widget.selectedOperations);
    _tabController = TabController(length: 10, vsync: this);

    // Initialize FocusNodes and Controllers
    _focusNodes = List.generate(10, (_) => FocusNode());
    _controllers = List.generate(10, (_) => TextEditingController());

    // Listen for tab changes to request focus
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        Future.microtask(
            () => _focusNodes[_tabController.index].requestFocus());
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _focusNodes.forEach((node) => node.dispose());
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void checkAnswer(int index, String answer) {
    bool isCorrect = CalculationService.checkCalculation(
        calculations[index], int.tryParse(answer) ?? 0);
    setState(() {
      answers[index] = isCorrect;
    });

    // Check if all questions have been answered
    bool allAnswered = !answers.contains(null);

    if (allAnswered) {
      int correctAnswers = answers.where((answer) => answer == true).length;
      int wrongAnswers = answers.where((answer) => answer == false).length;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PlayFinished(
              correctAnswers: correctAnswers, wrongAnswers: wrongAnswers),
        ),
      );
    } else if (index < 9) {
      // Only move to the next question if not all questions have been answered
      _tabController.animateTo(index + 1);
    }
  }

  Widget _buildCalculationPage(int index) {
    Calculation calculation = calculations[index];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            '${calculation.firstNumber} ${calculation.calculationType.symbol} ${calculation.secondNumber}',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            onSubmitted: (value) {
              checkAnswer(index, value);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spiel läuft...'),
        bottom: TabBar(
          controller: _tabController,
          tabs: List.generate(
              10, (index) => Tab(icon: _getIconForAnswer(answers[index]))),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(10, (index) => _buildCalculationPage(index)),
      ),
    );
  }

  Widget _getIconForAnswer(bool? answer) {
    // Define default icon properties
    IconData iconData = Icons.help_outline;
    Color color = Colors.grey; // Default color for unanswered

    if (answer != null) {
      // Determine the icon and color based on the answer's correctness
      iconData = answer ? Icons.check : Icons.close;
      color = answer ? Colors.green : Colors.red;
    }

    // Return an Icon widget with the determined properties
    return Icon(iconData, color: color);
  }
}
