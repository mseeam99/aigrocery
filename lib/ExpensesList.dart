
import 'package:aigrocery/ExpensesItem.dart';
import 'package:flutter/material.dart';

import 'ExpensesDataModel.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key, required this.expenses, required this.removeExpenses});

  final List<ExpensesDataModel> expenses;

  final Function(ExpensesDataModel) removeExpenses;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
        background: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              color: Colors.red,
            ),
            const Text(
              'Deleted',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        onDismissed: (direction) {
          removeExpenses(expenses[index]);
        },
        key: ValueKey(expenses[index]),
        child: ExpensesItem(expense: expenses[index]),
      ),
    );
  }
}
