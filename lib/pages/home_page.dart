import 'dart:async';

import 'package:expense_tracker/components/expense_summary.dart';
import 'package:expense_tracker/components/expense_tile.dart';
import 'package:expense_tracker/data/expense_data.dart';
import 'package:expense_tracker/models/expense_item.dart';
import 'package:expense_tracker/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final newExpenseNameController = TextEditingController();
  final newExpenseDollarController = TextEditingController();
  final newExpenseCentsController = TextEditingController();


  @override
  void initState() {
    super.initState();
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  void openExpenseDialog({ExpenseItem? expense}) {
    if (expense != null) {
      newExpenseNameController.text = expense.name;

      final parts = expense.amount.split('.');
      newExpenseDollarController.text = parts[0];
      newExpenseCentsController.text = parts.length > 1 ? parts[1] : '00';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(expense == null ? 'Add New Expense' : 'Edit Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: newExpenseNameController,
              decoration: const InputDecoration(hintText: 'Expense name'),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: newExpenseDollarController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Dollars'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: newExpenseCentsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Cents'),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              clear();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => saveExpense(oldExpense: expense),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void deleteExpenseWithAutoCommit(ExpenseItem expense) {
    final expenseData = Provider.of<ExpenseData>(context, listen: false);
    final int index = expenseData.overallExpenseList.indexOf(expense);

    expenseData.removeExpenseTemporarily(expense);

    int secondsLeft = 3;
    Timer? timer;
    bool undone = false;

    ScaffoldMessenger.of(context).clearSnackBars();

    final snackBar = SnackBar(
      duration: const Duration(seconds: 3),
      content: StatefulBuilder(
        builder: (context, setState) {
          timer ??= Timer.periodic(const Duration(seconds: 1), (t) {
            if (secondsLeft == 0) {
              t.cancel();
            } else {
              secondsLeft--;
              setState(() {});
            }
          });

          return Row(
            children: [
              const Expanded(child: Text('Expense deleted')),
              Text(
                'UNDO ($secondsLeft)',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          );
        },
      ),
      action: SnackBarAction(
        label: 'UNDO',
        onPressed: () {
          undone = true;
          timer?.cancel();
          expenseData.insertExpense(index, expense);
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // 🔥 Commit delete ONLY after SnackBar disappears
    Future.delayed(const Duration(seconds: 3), () {
      if (!undone) {
        expenseData.commitDelete();
      }
    });
  }

  void saveExpense({ExpenseItem? oldExpense}) {
    if (newExpenseNameController.text.isEmpty ||
        newExpenseDollarController.text.isEmpty ||
        newExpenseCentsController.text.isEmpty) return;

    final amount =
        '${newExpenseDollarController.text}.${newExpenseCentsController.text}';

    final newExpense = ExpenseItem(
      name: newExpenseNameController.text,
      amount: amount,
      dateTime: oldExpense?.dateTime ?? DateTime.now(),
    );

    final expenseData = Provider.of<ExpenseData>(context, listen: false);

    if (oldExpense == null) {
      expenseData.addNewExpenses(newExpense);
    } else {
      expenseData.updateExpense(oldExpense, newExpense);
    }

    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newExpenseNameController.clear();
    newExpenseDollarController.clear();
    newExpenseCentsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: openExpenseDialog,
          child: Icon(
              Icons.add
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Switch Theme'
                    ),
                    Consumer<ThemeProvider>(
                        builder: (context, theme, _) => Switch(
                          value: theme.isDarkMode,
                          onChanged: theme.toggleTheme,
                        )
                    )
                  ],
                ),
              ),
              ExpenseSummary(startOfWeek: value.startOfWeekDate()),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.all(5),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: value.getAllExpensesList().length,
                    itemBuilder: (context, index) {
                      final expense = value.getAllExpensesList()[index];

                      return ExpenseTile(
                        name: expense.name,
                        dateTime: expense.dateTime,
                        amount: expense.amount,
                        onDelete: (_) {
                          showDialog(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: const Text('Delete expense?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(dialogContext),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(dialogContext);
                                    deleteExpenseWithAutoCommit(
                                      value.getAllExpensesList()[index],
                                    );
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                        onEdit: (context) {
                          openExpenseDialog(expense: expense);
                        },
                      );
                    }
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}
