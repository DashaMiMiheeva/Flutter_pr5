// lib/features/expenses/screens/expenses_list_screen.dart
import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../widgets/expense_row.dart';

class ExpensesListScreen extends StatelessWidget {
  final List<Expense> expenses;
  final VoidCallback onAddTap;
  final void Function(String id) onDelete;
  final void Function(Expense expense)? onEdit;

  const ExpensesListScreen({
    Key? key,
    required this.expenses,
    required this.onAddTap,
    required this.onDelete,
    this.onEdit,
  }) : super(key: key);

  double _sumAll() => expenses.fold(0.0, (s, e) => s + e.amount);

  @override
  Widget build(BuildContext context) {
    final total = _sumAll();
    return Scaffold(
      appBar: AppBar(title: const Text('Мои расходы')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.grey[100],
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Text('Итого за список:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Text('${total.toStringAsFixed(2)} ₽', style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
          Expanded(
            child: expenses.isEmpty
                ? const Center(child: Text('Список расходов пуст. Нажмите + чтобы добавить.'))
                : ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final e = expenses[index];
                return Dismissible(
                  key: ValueKey(e.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    onDelete(e.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: const Text('Расход удалён'), action: SnackBarAction(label: 'Отменить', onPressed: () {
                        // undo handled by container via stored state — here no-op
                      })),
                    );
                  },
                  child: ExpenseRow(
                    expense: e,
                    onTap: onEdit != null ? () => onEdit!(e) : null,
                    onDelete: () {},
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAddTap,
        child: const Icon(Icons.add),
      ),
    );
  }
}
