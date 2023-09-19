// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'Categoty.dart';
import 'ExpensesDataModel.dart';

const uuid = Uuid();
final formatter = DateFormat.yMd().add_jm();

class NewExpense extends StatefulWidget {
  const NewExpense({Key? key, required this.onAddExpense}) : super(key: key);

  final Function(ExpensesDataModel expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  Category? _selectedCategory;
  DateTime? currentSelectedDateandTime;

  void presentDateTimePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = DateTime(now.year + 1, now.month, now.day);

    final pickDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickDate != null) {
      final pickTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(now),
      );

      if (pickTime != null) {
        final pickedDateTime = DateTime(
          pickDate.year,
          pickDate.month,
          pickDate.day,
          pickTime.hour,
          pickTime.minute,
        );
        setState(() {
          currentSelectedDateandTime = pickedDateTime;
        });
      }
    }
  }

  void submitDataAndSave() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedCategory == null ||
        currentSelectedDateandTime == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input...'),
          content: const Text(
              'Please enter valid input for Title, Amount, Category, and Date.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }
    widget.onAddExpense(
      ExpensesDataModel(
        title: _titleController.text,
        amount: enteredAmount,
        date: currentSelectedDateandTime!,
        category: _selectedCategory!,
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            keyboardType: TextInputType.text, // Appropriate keyboard for text input
            autofocus: true,
            controller: _titleController,
            maxLength: 30,
            autocorrect: false,
            decoration: const InputDecoration(
              labelText: 'Title',
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number, // Numeric keyboard
                    decoration: const InputDecoration(
                      prefix: Text('\$ '),
                      labelText: 'Budget',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      currentSelectedDateandTime == null
                          ? 'No date selected'
                          : formatter.format(currentSelectedDateandTime!),
                    ),
                    Container(
                      constraints: const BoxConstraints.tightFor(
                        width: 32,
                        height: 32,
                      ),
                      child: IconButton(
                        onPressed: presentDateTimePicker,
                        icon: const Icon(Icons.calendar_today),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(border: Border.all()),
                child: DropdownButton(
                  value: _selectedCategory,
                  items: Category.values
                      .where((category) => category != Category.values.last) // Exclude the last item
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(
                            category.toString().split('.').last.toUpperCase(),
                          ),
                        ),
                      )
                      .toList(),
                  underline: Container(
                    height: 2,
                    color: Colors.black,
                  ),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: submitDataAndSave,
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
