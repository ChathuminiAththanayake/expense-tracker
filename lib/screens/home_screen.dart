import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../providers/theme_provider.dart';
import '../services/auth_service.dart';
import '../widgets/expense_tile.dart';
import '../widgets/monthly_summary_card.dart';
import '../widgets/filter_bar.dart';
import '../widgets/empty_state.dart';
import '../widgets/fade_slide_in.dart';
import 'add_edit_expense_screen.dart';
import 'summary_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _searching = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _confirmSignOut() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sign out?'),
        content: const Text('You can sign in again any time with your email and password.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton.tonal(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Sign out')),
        ],
      ),
    );
    if (ok == true) {
      await AuthService().signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final email = FirebaseAuth.instance.currentUser?.email ?? '';
    final isDark = themeProvider.mode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: _searching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search expenses...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  filled: false,
                ),
                onChanged: provider.setSearchQuery,
              )
            : const Text('Expense Tracker'),
        actions: [
          IconButton(
            icon: Icon(_searching ? Icons.close_rounded : Icons.search_rounded),
            onPressed: () {
              setState(() {
                _searching = !_searching;
                if (!_searching) {
                  _searchController.clear();
                  provider.setSearchQuery('');
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.pie_chart_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SummaryScreen()),
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle_rounded),
            onSelected: (value) {
              if (value == 'theme') themeProvider.toggle();
              if (value == 'logout') _confirmSignOut();
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                enabled: false,
                child: Text(email, style: const TextStyle(fontSize: 13)),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'theme',
                child: Row(
                  children: [
                    Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
                    const SizedBox(width: 12),
                    Text(isDark ? 'Light mode' : 'Dark mode'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded),
                    SizedBox(width: 12),
                    Text('Sign out'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          MonthlySummaryCard(total: provider.currentMonthTotal),
          const SizedBox(height: 4),
          FilterBar(provider: provider),
          const SizedBox(height: 8),
          Expanded(child: _buildList(provider)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddEditExpenseScreen()),
        ),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add'),
      ),
    );
  }

  Widget _buildList(ExpenseProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
            const SizedBox(height: 8),
            Text(provider.error!, textAlign: TextAlign.center),
          ],
        ),
      );
    }
    final expenses = provider.filteredExpenses;
    if (expenses.isEmpty) {
      return const EmptyState(
          message: 'No expenses found.\nTap + to add your first expense.');
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 90),
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final e = expenses[index];
        return FadeSlideIn(
          index: index,
          child: ExpenseTile(
            expense: e,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddEditExpenseScreen(existing: e)),
            ),
            onDelete: () => provider.deleteExpense(e.id),
          ),
        );
      },
    );
  }
}