import 'package:expense_tracker/models/expense_item.dart';
import 'package:hive/hive.dart';

class HiveDataBase {
  final _myBox = Hive.box('expense_database');
  void saveData(List<ExpenseItem> allExpenses) {
    List<List<dynamic>> allExpensesFormatted = [];
    for (var expense in allExpenses) {
      List<dynamic> expensesFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime
      ];
      allExpensesFormatted.add(expensesFormatted);
    }

    _myBox.put('ALL_EXPENSES', allExpensesFormatted);
  }

  List<ExpenseItem> readData() {
    List savedExpenses = _myBox.get('ALL_EXPENSES') ?? [];
    List<ExpenseItem> allExpenses = [];

    for (int i = 0; i < savedExpenses.length; i++) {
      String name = savedExpenses[i][0];
      String amount = savedExpenses[i][1];
      DateTime dateTime = savedExpenses[i][2];
      
      ExpenseItem expenseItem = ExpenseItem(
          name: name,
          amount: amount,
          dateTime: dateTime
      );
      allExpenses.add(expenseItem);
    }
    return allExpenses;
  }
}