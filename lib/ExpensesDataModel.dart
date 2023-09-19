
import 'package:aigrocery/Categoty.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd().add_jm();

class ExpensesDataModel {
  ExpensesDataModel({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });

  final String title;
  final double? amount;
  final DateTime? date;
  final Category category;

  String get formattedDate {
    return formatter.format(date!);
  }
}
