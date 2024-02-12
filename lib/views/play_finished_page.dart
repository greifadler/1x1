import 'package:flutter/material.dart';

class PlayFinished extends StatelessWidget {
  final int correctAnswers;
  final int wrongAnswers;

  PlayFinished(
      {Key? key, required this.correctAnswers, required this.wrongAnswers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spiel abgeschlossen!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🎉', style: TextStyle(fontSize: 64)),
            Text('Sehr gut gemacht!',
                style: Theme.of(context).textTheme.headline4),
            SizedBox(height: 20),
            Text('Richtige Antworten: $correctAnswers',
                style: Theme.of(context).textTheme.headline6),
            Text('Falsche Antworten: $wrongAnswers',
                style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
              child: Text('Zurück zum Hauptmenü'),
            ),
          ],
        ),
      ),
    );
  }
}
