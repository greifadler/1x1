import 'package:flutter/material.dart';
import 'play_page.dart';
import '../utils/message_utils.dart';
import '../models/calculation.dart';

class PlaySetupPage extends StatefulWidget {
  @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<PlaySetupPage> {
  Set<CalculationType> selectedOperations = {};
  Set<int> selectedMathRows = {};

  static int MIN_ROW = 1;
  static int MAX_ROW = 10;

  void toggleRow(int mathRow) {
    setState(() {
      if (selectedMathRows.contains(mathRow)) {
        selectedMathRows.remove(mathRow);
      } else {
        selectedMathRows.add(mathRow);
      }
    });
  }

  void toggleOperation(CalculationType type) {
    setState(() {
      if (selectedOperations.contains(type)) {
        selectedOperations.remove(type);
      } else {
        selectedOperations.add(type);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          // Generate row buttons
          for (int i = MIN_ROW; i < MAX_ROW; i++)
            ListTile(
              title: Text('${i}er Reihe'),
              trailing: Switch(
                value: selectedMathRows.contains(i),
                onChanged: (_) => toggleRow(i),
              ),
            ),

          // Separator
          Divider(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              for (CalculationType type in CalculationType.values)
                ElevatedButton(
                  onPressed: () => toggleOperation(type),
                  child: Text(
                    type.label,
                    style: TextStyle(
                        color: selectedOperations.contains(type)
                            ? Colors.white
                            : Colors.black87),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          selectedOperations.contains(type)
                              ? Colors.blue
                              : Colors.grey[300])),
                ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                var mathRowTogglesValid = selectedMathRows.isNotEmpty;
                var operationTogglesValid = selectedOperations.isNotEmpty;

                if (operationTogglesValid && mathRowTogglesValid) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayPage(
                          selectedMathRows: selectedMathRows,
                          selectedOperations: selectedOperations),
                    ),
                  );
                } else {
                  String message = "Bitte wähle ";

                  if (!mathRowTogglesValid && !operationTogglesValid) {
                    message += "Zahlenreihen zum Rechnen und Operationen";
                  } else if (!mathRowTogglesValid) {
                    message += "Zahlenreihen zum Rechnen";
                  } else if (!operationTogglesValid) {
                    message += "Operationen";
                  }

                  message += " aus, um mit dem Üben zu starten";
                  MessageUtils.showToast(message);
                }
              },
              child: Text('Los gehts!'),
            ),
          ),
        ],
      ),
    );
  }
}
