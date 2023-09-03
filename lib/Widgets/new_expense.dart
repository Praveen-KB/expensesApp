import 'package:expense_tracker/modals/expense.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountCOntroller = TextEditingController();
  Category _selectedCaegory = Category.leisure;
  DateTime? _selectedDate;
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final lastDate = DateTime(now.year + 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountCOntroller.dispose();
    super.dispose();
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountCOntroller.text);
    final bool amountisINvalid = enteredAmount == null || enteredAmount <= 0;

    if (_titleController.text.trim().isEmpty ||
        amountisINvalid ||
        _selectedDate == null) {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text("Invalid Input"),
              content: const Text("Please make sure all the feilds are filled"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text("Okay"))
              ],
            );
          });
      return;
    }

    widget.onAddExpense(Expense(
        amount: enteredAmount,
        category: _selectedCaegory,
        date: _selectedDate!,
        title: _titleController.text));
    Navigator.pop(context);
  }

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(children: [
        TextField(
          controller: _titleController,
          maxLength: 50,
          decoration: const InputDecoration(label: Text("Give Use expense")),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _amountCOntroller,
                keyboardType: TextInputType.number,
                maxLength: 50,
                decoration: const InputDecoration(
                  prefixText: "\$",
                  label: Text("Amount"),
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(_selectedDate == null
                    ? "NO date Selected"
                    : fomratter.format(_selectedDate!)),
                IconButton(
                    onPressed: _presentDatePicker,
                    icon: const Icon(Icons.calendar_month_outlined))
              ],
            ))
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            DropdownButton(
              value: _selectedCaegory,
              items: Category.values
                  .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e.name.toUpperCase(),
                      )))
                  .toList(),
              onChanged: (e) {
                if (e == null) {
                  return;
                }
                setState(() {
                  _selectedCaegory = e;
                });
              },
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("cancel")),
            ElevatedButton(
                onPressed: _submitExpenseData,
                child: const Text("Save Expense"))
          ],
        )
      ]),
    );
  }
}
