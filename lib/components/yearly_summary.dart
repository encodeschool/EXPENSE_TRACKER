import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/expense_data.dart';

class YearlySummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final summary =
    Provider.of<ExpenseData>(context).calculateYearlyExpenseSummary();

    return Column(
      children: summary.entries.map((entry) {
        return ListTile(
          title: Text('${entry.key}'),
          trailing: Text(
            '\$${entry.value.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }).toList(),
    );
  }
}
