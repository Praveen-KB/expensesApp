import 'package:expense_tracker/Widgets/chart/chart.dart';
import 'package:expense_tracker/Widgets/expenses_list.dart';
import 'package:expense_tracker/Widgets/new_expense.dart';
import 'package:expense_tracker/modals/expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registedExpenses = [
    Expense(
        amount: 19.99,
        title: "Flutter Course",
        date: DateTime.now(),
        category: Category.work),
    Expense(
        amount: 16.59,
        title: "Cinema fun",
        date: DateTime.now(),
        category: Category.leisure),
    Expense(
        amount: 109.55,
        title: "Dateing",
        date: DateTime.now(),
        category: Category.leisure),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return NewExpense(
            onAddExpense: _addExpense,
          );
        });
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registedExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registedExpenses.indexOf(expense);
    setState(() {
      _registedExpenses.remove(expense);
    });

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text("Expense Deleted"),
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              setState(() {
                _registedExpenses.insert(expenseIndex, expense);
              });
            }),
      ),
    );
  }

  @override
  Widget build(context) {
    Widget mainCont = const Center(
      child: Text("No expenses Found add some"),
    );

    if (_registedExpenses.isNotEmpty) {
      mainCont = Expanded(
        child: Column(
          children: [
            ExpensesList(expenses: _registedExpenses, onRemove: _removeExpense),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Expense Tracker"),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Chart(expenses: _registedExpenses),
          mainCont,
        ],
      ),
    );
  }
}
