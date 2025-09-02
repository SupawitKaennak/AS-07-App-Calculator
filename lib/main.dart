import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const CalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});
  
  @override
  CalculatorScreenState createState() => CalculatorScreenState();
}

class CalculatorScreenState extends State<CalculatorScreen> {
  String output = "0";
  String expression = "";
  String displayExpression = "";

  void _buttonPressed(String value) {
    setState(() {
      if (value == "C") {
        output = "0";
        expression = "";
        displayExpression = "";
      } else if (value == "DEL") {
        if (output.length > 1) {
          output = output.substring(0, output.length - 1);
        } else {
          output = "0";
        }
      } else if (value == "=") {
        try {
          // เพิ่มตัวเลขปัจจุบันเข้าไปในนิพจน์
          String finalExpression = expression + output;
          // คำนวณผลลัพธ์
          double result = _evaluateExpression(finalExpression);
          output = result.toString();
          expression = "";
          displayExpression = "";
        } catch (e) {
          output = "Error";
          expression = "";
          displayExpression = "";
        }
      } else if (value == "%") {
        // คำนวณเปอร์เซ็นต์ (หารด้วย 100)
        if (output != "0") {
          double number = double.parse(output);
          double percentage = number / 100;
          output = percentage.toString();
        }
      } else if (value == "*") {
        if (output != "0") {
          expression += output + "*";
          displayExpression += output + "×";
          output = "0";
        }
      } else if (value == "/" || value == "+" || value == "-") {
        if (output != "0") {
          expression += output + value;
          displayExpression += output + value;
          output = "0";
        }
      } else {
        if (output == "0") {
          output = value;
        } else {
          output += value;
        }
      }
    });
  }

  double _evaluateExpression(String expression) {
    // แยกตัวเลขและตัวดำเนินการ
    List<String> tokens = [];
    String currentNumber = "";
    
    for (int i = 0; i < expression.length; i++) {
      String char = expression[i];
      if (char == '+' || char == '-' || char == '*' || char == '/') {
        if (currentNumber.isNotEmpty) {
          tokens.add(currentNumber);
          currentNumber = "";
        }
        tokens.add(char);
      } else {
        currentNumber += char;
      }
    }
    if (currentNumber.isNotEmpty) {
      tokens.add(currentNumber);
    }
    
    // คำนวณผลลัพธ์
    double result = double.parse(tokens[0]);
    for (int i = 1; i < tokens.length; i += 2) {
      String operator = tokens[i];
      double operand = double.parse(tokens[i + 1]);
      
      switch (operator) {
        case '+':
          result += operand;
          break;
        case '-':
          result -= operand;
          break;
        case '*':
          result *= operand;
          break;
        case '/':
          if (operand == 0) {
            throw Exception("Division by zero");
          }
          result /= operand;
          break;
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final buttons = [
      "C", "%", "DEL", "/",
      "7", "8", "9", "*",
      "4", "5", "6", "-",
      "1", "2", "3", "+",
      "00", "0", ".", "=",
    ];

    return Scaffold(
      appBar: AppBar(title: Text("Calculator"),
      backgroundColor: Colors.blue,
      titleTextStyle: TextStyle(color: const Color.fromARGB(255, 0, 255, 26),
      fontSize: 24,
      fontWeight: FontWeight.bold)),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (displayExpression.isNotEmpty)
                    Text(
                      displayExpression,
                      style: TextStyle(fontSize: 24, color: Colors.grey),
                    ),
                  Text(
                    output,
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GridView.builder(
              itemCount: buttons.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: () => _buttonPressed(buttons[index]),
                    child: Text(
                      buttons[index],
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
