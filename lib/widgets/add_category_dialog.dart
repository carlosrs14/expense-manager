import 'package:expense_manager/providers/expense_provider.dart';
import 'package:provider/provider.dart';
import 'package:expense_manager/models/expense_category.dart';
import 'package:flutter/material.dart';

class AddCategoryDialog extends StatefulWidget {
  final Function(ExpenseCategory) onAdd;

  const AddCategoryDialog({super.key, required this.onAdd});

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Category'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'Category Name'
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), 
          child: Text('Cancel')
        ),
        TextButton(
          onPressed: () {
            var newCategory = ExpenseCategory(
              id: DateTime.now().toString(), 
              name: _controller.text, 
              isDefault: false
            );
            widget.onAdd(newCategory);
            Provider.of<ExpenseProvider>(context, listen: false).addCategory(newCategory);
            _controller.clear();

            Navigator.of(context).pop();
          }, 
          child: Text('Add')
        ),
      ],
    );
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}