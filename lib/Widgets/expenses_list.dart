import 'package:expense_tracker/Widgets/expense_item.dart';
import 'package:expense_tracker/modals/expense.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key, required this.expenses, required this.onRemove});

  final List<Expense> expenses;

  final Function onRemove;

  @override
  Widget build(context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: expenses.length,
      itemBuilder: (context, index) => Dismissible(
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(.75),
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
        ),
        onDismissed: (diecection) {
          onRemove(expenses[index]);
        },
        key: ValueKey(expenses[index]),
        child: ExpenseItem(expenses[index]),
      ),
    );
  }
}
