import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'db_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Calculator',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});
  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _display = "";
  final List<String> buttons = [
    "7", "8", "9", "÷",
    "4", "5", "6", "×",
    "1", "2", "3", "-",
    "0", "C", "=", "+"
  ];

  void _onButtonPressed(String button) {
    setState(() {
      if (button == "C") {
        _display = "";
      } else if (button == "=") {
        _calculate();
      } else {
        _display += button;
      }
    });
  }

  void _calculate() async {
    try {
      String expression = _display;
      expression = expression.replaceAll("×", "*");
      expression = expression.replaceAll("÷", "/");
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, cm);
      if (result.toString() == "Infinity" || result.isNaN) {
        _display = "Error";
      } else {
        _display = result.toString();
        // Save calculation to SQLite
        await DBHelper().insertCalculation({
          'expression': expression,
          'result': _display,
          'date': DateTime.now().toString(),
          'note': 'Manual calculation'
        });
      }
    } catch (e) {
      _display = "Error";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Calculator"),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryPage()),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.bottomRight,
              child: Text(
                _display,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: GridView.builder(
              itemCount: buttons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemBuilder: (context, index) {
                final button = buttons[index];
                Color buttonColor;
                if (button == "C") {
                  buttonColor = Colors.redAccent;
                } else if (button == "=") {
                  buttonColor = Colors.green;
                } else if (["+", "-", "×", "÷"].contains(button)) {
                  buttonColor = Colors.orange;
                } else {
                  buttonColor = Colors.grey[850]!;
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(20),
                    ),
                    onPressed: () => _onButtonPressed(button),
                    child: Text(
                      button,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------- History Page -------------------

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> _calculations = [];

  void _fetchCalculations() async {
    var data = await DBHelper().getCalculations();
    setState(() {
      _calculations = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchCalculations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("History")),
      body: ListView.builder(
        itemCount: _calculations.length,
        itemBuilder: (context, index) {
          final calc = _calculations[index];
          return ListTile(
            title: Text("${calc['expression']} = ${calc['result']}"),
            subtitle: Text("${calc['date']} | Note: ${calc['note']}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    await DBHelper().updateCalculation(calc['id'], {
                      'expression': calc['expression'],
                      'result': calc['result'],
                      'date': calc['date'],
                      'note': 'Updated note'
                    });
                    _fetchCalculations();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await DBHelper().deleteCalculation(calc['id']);
                    _fetchCalculations();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
