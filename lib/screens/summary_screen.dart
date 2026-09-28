import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../utils/categories.dart';
import '../utils/formatters.dart';
import '../widgets/empty_state.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final totals = provider.currentMonthCategoryTotals;

    return Scaffold(
      appBar: AppBar(title: const Text('Monthly Summary')),
      body: totals.isEmpty
          ? const EmptyState(
              message: 'No expenses this month yet.', icon: Icons.pie_chart_outline)
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SizedBox(
                  height: 240,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        for (final entry in totals.entries)
                          PieChartSectionData(
                            value: entry.value,
                            title: entry.key,
                            color: categoryByName(entry.key).color,
                            radius: 90,
                            titleStyle: const TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                      ],
                      sectionsSpace: 2,
                      centerSpaceRadius: 30,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                for (final entry in totals.entries)
                  ListTile(
                    leading: Icon(categoryByName(entry.key).icon,
                        color: categoryByName(entry.key).color),
                    title: Text(entry.key),
                    trailing: Text(formatCurrency(entry.value),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
    );
  }
}
