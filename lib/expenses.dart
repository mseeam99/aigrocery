import "dart:convert";
import 'dart:math';

import 'package:aigrocery/Categoty.dart';
import 'package:aigrocery/ExpensesDataModel.dart';
import 'package:aigrocery/ExpensesList.dart';
import 'package:aigrocery/NewExpense.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<ExpensesDataModel> _registeredExpenses = [];

  String _enteredText = '';

  String responseFromGPT = "";
  DateTime? currentSelectedDateandTime;
  final now = DateTime.now();

  void _addExpenses(ExpensesDataModel expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpenses(ExpensesDataModel expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: const Text('Deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(
              () {
                _registeredExpenses.insert(expenseIndex, expense);
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget? mainContent;
    if (_registeredExpenses.isNotEmpty) {
      mainContent = Expanded(
        child: ExpensesList(
          expenses: _registeredExpenses,
          removeExpenses: _removeExpenses,
        ),
      );
    } else {
      mainContent = const Center(
        child: Text('You currently do not have anything saved !'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AI Grocery',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (ctx) => NewExpense(onAddExpense: _addExpenses),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20), // Add top padding of 5
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _enteredText = value;
                });
              },
              decoration: const InputDecoration(
                labelText:
                    'Name an event/recipe in ONE WORD and our A.I. will autofill your grocery list',
                labelStyle: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: ElevatedButton(
              onPressed: () async {
                responseFromGPT = await chatGPTAPI(_enteredText);

                addExpensesFromResponse(responseFromGPT);
                // print(responseFromGPT);
              },
              child: const Text('Submit'),
            ),
          ),
          mainContent,
        ],
      ),
    );
  }

  void addExpensesFromResponse(String response) {
    List<String> elements = response.split(',');
    for (String element in elements) {
      element = element.trim();

      var doubleValue =
          Random().nextDouble() * 10; // Value is >= 0.0 and < 256.0.

      ExpensesDataModel expense = ExpensesDataModel(
          title: element,
          amount: doubleValue,
          date: DateTime.now(),
          category: Category.AI);
      _addExpenses(expense);
    }
  }

  //OPEN AI INTEGRATION WITH FLUTTER IS BELOW

  static List<Map<String, String>> messages = [];

  Future<String> chatGPTAPI(String prompt) async {
    String finalOpenAiQuestion =
        "Just return me a string of list of ingredients to '$prompt'. Nothing else. Just return list of sting and do not tell a singe word. If you do not have an answer, then aswer Buy Air ";

    String OpenAiKey = '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';
    messages.add(
      {
        'role': 'user',
        'content': finalOpenAiQuestion,
      },
    );
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $OpenAiKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": messages,
        }),
      );

      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();

        messages.add({
          'role': 'assistant',
          'content': content,
        });
        return content;
      }
      return 'An internal error occurred with openAI';
    } catch (e) {
      return e.toString();
    }
  }
}
