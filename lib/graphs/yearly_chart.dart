import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/expense_data.dart';

class YearlyChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data =
    Provider.of<ExpenseData>(context).calculateYearlyExpenseSummary();

    if (data.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'No yearly data yet',
          textAlign: TextAlign.center,
        ),
      );
    }

    final entries = data.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: AspectRatio(
        aspectRatio: 1.7,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: entries.length - 1,
            minY: 0,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: _calculateInterval(entries),
              getDrawingHorizontalLine: (value) => FlLine(
                color: theme.dividerColor.withOpacity(0.3),
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(show: false),

            lineBarsData: [
              LineChartBarData(
                spots: List.generate(
                  entries.length,
                      (index) => FlSpot(
                    index.toDouble(),
                    entries[index].value,
                  ),
                ),
                isCurved: true,
                curveSmoothness: 0.25,
                barWidth: 3,
                color: theme.colorScheme.primary,
                isStrokeCapRound: true,

                // ✨ Gradient fill below line
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withOpacity(0.3),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),

                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, bar, index) =>
                      FlDotCirclePainter(
                        radius: 4,
                        color: theme.colorScheme.primary,
                        strokeWidth: 2,
                        strokeColor: theme.scaffoldBackgroundColor,
                      ),
                ),
              ),
            ],

            titlesData: FlTitlesData(
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 42,
                  interval: _calculateInterval(entries),
                  getTitlesWidget: (value, _) => Text(
                    '\$${value.toInt()}',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, _) => Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      entries[value.toInt()].key.toString(),
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ),
              ),
            ),

            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (spots) => spots.map(
                      (spot) {
                    final year = entries[spot.x.toInt()].key;
                    return LineTooltipItem(
                      '$year\n\$${spot.y.toStringAsFixed(2)}',
                      theme.textTheme.bodyMedium!,
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _calculateInterval(List<MapEntry<int, double>> entries) {
    final max = entries
        .map((e) => e.value)
        .reduce((a, b) => a > b ? a : b);

    return (max / 4).ceilToDouble();
  }
}

