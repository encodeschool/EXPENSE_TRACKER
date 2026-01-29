import 'package:expense_tracker/data/hive_database.dart';
import 'package:expense_tracker/models/expense_item.dart';
import 'package:expense_tracker/utils/date_time_helper.dart';
import 'package:flutter/widgets.dart';

class ExpenseData extends ChangeNotifier {
  // list opf all expenses
  List<ExpenseItem> overallExpenseList = [];

  // get expense lst
  List<ExpenseItem> getAllExpensesList() {
    return overallExpenseList;
  }

  final db = HiveDataBase();
  void prepareData() {
    if (db.readData().isNotEmpty) {
      overallExpenseList = db.readData();
    }
  }

  // Update expense
  void updateExpense(ExpenseItem oldExpense, ExpenseItem updatedExpense) {
    final index = overallExpenseList.indexOf(oldExpense);
    if (index != -1) {
      overallExpenseList[index] = updatedExpense;
      notifyListeners();
      db.saveData(overallExpenseList);
    }
  }

  void insertExpense(int index, ExpenseItem expense) {
    overallExpenseList.insert(index, expense);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  void removeExpenseTemporarily(ExpenseItem expense) {
    overallExpenseList.remove(expense);
    notifyListeners();
  }

  void commitDelete() {
    db.saveData(overallExpenseList);
  }

  // add new expense
  void addNewExpenses(ExpenseItem newExpense) {
    overallExpenseList.add(newExpense);
    notifyListeners();
    db.saveData(overallExpenseList);
  }

  // delete expense
  void deleteExpense(ExpenseItem expense) {
    overallExpenseList.remove(expense);

    notifyListeners();
    db.saveData(overallExpenseList);
  }

  // get weekly expense
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  // get the date for the start of the week
  DateTime startOfWeekDate() {
    DateTime? startOfWeek;
    DateTime today = DateTime.now();

    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Sun') {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }

    return startOfWeek!;
  }

  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {};

    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      
      double amount = double.parse(expense.amount);
      if (dailyExpenseSummary.containsKey(date)) {
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      } else {
        dailyExpenseSummary.addAll({date: amount});
      }
    }

    return dailyExpenseSummary;
  }

  Map<String, double> calculateMonthlyExpenseSummary() {
    Map<String, double> monthlySummary = {};

    for (var expense in overallExpenseList) {
      final key =
          '${expense.dateTime.year}-${expense.dateTime.month.toString().padLeft(2, '0')}';

      final amount = double.parse(expense.amount);

      if (monthlySummary.containsKey(key)) {
        monthlySummary[key] = monthlySummary[key]! + amount;
      } else {
        monthlySummary[key] = amount;
      }
    }

    return monthlySummary;
  }

  Map<int, double> calculateYearlyExpenseSummary() {
    Map<int, double> yearlySummary = {};

    for (var expense in overallExpenseList) {
      final year = expense.dateTime.year;
      final amount = double.parse(expense.amount);

      if (yearlySummary.containsKey(year)) {
        yearlySummary[year] = yearlySummary[year]! + amount;
      } else {
        yearlySummary[year] = amount;
      }
    }

    return yearlySummary;
  }

}