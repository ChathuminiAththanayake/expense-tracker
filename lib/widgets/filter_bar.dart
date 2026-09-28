import 'package:flutter/material.dart';
import '../providers/expense_provider.dart';
import '../utils/categories.dart';

class FilterBar extends StatelessWidget {
  final ExpenseProvider provider;
  const FilterBar({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final hasFilters =
        provider.selectedCategory != null || provider.dateRange != null;
    final scheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PillFilter(
            icon: Icons.category_outlined,
            label: provider.selectedCategory ?? 'Category',
            selected: provider.selectedCategory != null,
            onTap: () => _pickCategory(context),
          ),
          const SizedBox(width: 10),
          _PillFilter(
            icon: Icons.calendar_today_outlined,
            label: provider.dateRange == null ? 'Date range' : 'Custom range',
            selected: provider.dateRange != null,
            onTap: () => _pickDateRange(context),
          ),
          if (hasFilters) ...[
            const SizedBox(width: 10),
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: provider.clearFilters,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.close_rounded, size: 16, color: scheme.error),
                    const SizedBox(width: 4),
                    Text('Clear',
                        style: TextStyle(
                            color: scheme.error,
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                  ],
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }

  void _pickCategory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: const Text('All categories'),
              onTap: () {
                provider.setCategoryFilter(null);
                Navigator.pop(context);
              },
            ),
            for (final c in kCategories)
              ListTile(
                leading: Icon(c.icon, color: c.color),
                title: Text(c.name),
                onTap: () {
                  provider.setCategoryFilter(c.name);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDateRange(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
      initialDateRange: provider.dateRange,
    );
    if (picked != null) {
      provider.setDateRange(picked);
    }
  }
}

class _PillFilter extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PillFilter({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: selected ? scheme.primary : scheme.surfaceContainerHighest.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: selected ? Colors.white : scheme.onSurfaceVariant),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : scheme.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}