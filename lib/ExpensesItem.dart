import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'Categoty.dart';
import 'ExpensesDataModel.dart';

const uuid = Uuid();
final formatter = DateFormat.yMd().add_jm();

class ExpensesItem extends StatelessWidget {
  const ExpensesItem({required this.expense, super.key});

  final ExpensesDataModel expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              expense.title.toUpperCase(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
               
                Text(
                  '\$ ${expense.amount!.toStringAsFixed(2)}',
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(categoryIcons[expense.category]),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(expense.formattedDate)
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
