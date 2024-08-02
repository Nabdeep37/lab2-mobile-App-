import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _display = '';
  String _result = '';
  String _operation = '';
  double _firstOperand = 0.0;
  double _secondOperand = 0.0;

  @override
  void initState() {
    super.initState();
    _loadDisplayValue();
  }

  void _loadDisplayValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _display = prefs.getString('display') ?? '';
    });
  }

  void _saveDisplayValue(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('display', value);
  }

  void _inputDigit(String digit) {
    setState(() {
      _display += digit;
      _saveDisplayValue(_display);
    });
  }

  void _inputOperation(String operation) {
    if (_display.isNotEmpty) {
      _firstOperand = double.parse(_display);
      _display = '';
      _operation = operation;
    }
  }

  void _calculateResult() {
    if (_display.isNotEmpty) {
      _secondOperand = double.parse(_display);
      switch (_operation) {
        case '+':
          _result = (_firstOperand + _secondOperand).toString();
          break;
        case '-':
          _result = (_firstOperand - _secondOperand).toString();
          break;
        case '*':
          _result = (_firstOperand * _secondOperand).toString();
          break;
        case '/':
          if (_secondOperand != 0) {
            _result = (_firstOperand / _secondOperand).toString();
          } else {
            _result = 'ERROR';
          }
          break;
        default:
          _result = 'ERROR';
          break;
      }
      setState(() {
        _display = _result;
        _saveDisplayValue(_display);
      });
    }
  }

  void _clear() {
    setState(() {
      _display = '';
      _result = '';
      _operation = '';
      _firstOperand = 0.0;
      _secondOperand = 0.0;
      _saveDisplayValue(_display);
    });
  }

  void _clearEntry() {
    setState(() {
      _display = '';
      _saveDisplayValue(_display);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Calculator'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: Text(
              _display,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              _buildButton('7'),
              _buildButton('8'),
              _buildButton('9'),
              _buildButton('/'),
            ],
          ),
          Row(
            children: [
              _buildButton('4'),
              _buildButton('5'),
              _buildButton('6'),
              _buildButton('*'),
            ],
          ),
          Row(
            children: [
              _buildButton('1'),
              _buildButton('2'),
              _buildButton('3'),
              _buildButton('-'),
            ],
          ),
          Row(
            children: [
              _buildButton('CE'),
              _buildButton('0'),
              _buildButton('C'),
              _buildButton('+'),
            ],
          ),
          Row(
            children: [
              _buildButton('='),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String label) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          if (label == 'C') {
            _clear();
          } else if (label == 'CE') {
            _clearEntry();
          } else if (label == '=') {
            _calculateResult();
          } else if (['+', '-', '*', '/'].contains(label)) {
            _inputOperation(label);
          } else {
            _inputDigit(label);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            label,
            style: const TextStyle(fontSize: 32),
          ),
        ),
      ),
    );
  }
}
