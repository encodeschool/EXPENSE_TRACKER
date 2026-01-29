import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/expense_data.dart';

class MonthlyChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final expenseData = Provider.of<ExpenseData>(context);

    final rawData = expenseData.calculateMonthlyExpenseSummary();

    final now = DateTime.now();
    final year = now.year;

    // 🧠 Force all 12 months
    final Map<int, double> monthlyTotals = {
      for (int m = 1; m <= 12; m++) m: 0.0,
    };

    rawData.forEach((key, value) {
      final parts = key.split('-'); // yyyy-MM
      final month = int.parse(parts[1]);
      monthlyTotals[month] = value;
    });

    return Padding(
      padding: const EdgeInsets.all(16),
      child: BarChart(
        BarChartData(
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),

          barGroups: List.generate(12, (index) {
            final month = index + 1;

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: monthlyTotals[month]!,
                  width: 16,
                  color: Colors.grey[800],
                  backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      color: Colors.grey[200]
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),

          titlesData: FlTitlesData(
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  const months = [
                    'Jan','Feb','Mar','Apr','May','Jun',
                    'Jul','Aug','Sep','Oct','Nov','Dec'
                  ];

                  return Text(
                    months[value.toInt()],
                    style: const TextStyle(fontSize: 11),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
