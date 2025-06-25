import 'package:expense_manager/models/expense.dart';
import 'package:expense_manager/providers/expense_provider.dart';
import 'package:expense_manager/widgets/add_category_dialog.dart';
import 'package:expense_manager/widgets/add_tag_dialog.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? initialExpense;

  const AddExpenseScreen({super.key, this.initialExpense});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  late TextEditingController _amountController;
  late TextEditingController _payeeController;
  late TextEditingController _noteController;
  String? _selectedCategoryId;
  String? _selectedTagId;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.initialExpense?.amount.toString() ?? ''
    );
    _payeeController = TextEditingController(
      text: widget.initialExpense?.payee.toString() ?? ''
    );
    _noteController = TextEditingController(
      text: widget.initialExpense?.note ?? ''
    );
    _selectedDate = widget.initialExpense?.date ?? DateTime.now();
    _selectedCategoryId = widget.initialExpense?.categoryId ?? '';
    _selectedTagId = widget.initialExpense?.tag;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initialExpense == null? 'Add Expense': 'Edit Expense',
        ),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
          ],
        ),
      ),
      bottomNavigationBar: Padding(      
        padding: EdgeInsets.all(8),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 50)

          ),
          onPressed: _saveExpense, 
          child: Text('Save Expense')
        ),
      ),
    );
  }

  void _saveExpense() {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all required fields'))
      );
      return;
    }

    final expense = Expense(
      id: widget.initialExpense?.id ?? DateTime.now().toString(), 
      amount: double.parse(_amountController.text), 
      categoryId: _selectedCategoryId!, 
      payee: _payeeController.text, 
      note: _noteController.text, 
      date: _selectedDate, 
      tag: _selectedTagId!
    );
  
    Provider.of<ExpenseProvider>(context, listen: false).addOrUpdateExpense(expense);
    Navigator.pop(context);
  }

  Widget buildTextField(TextEditingController controller, String label, TextInputType type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder()
        ),
        keyboardType: type,
      ),
    );
  }

  Widget buildDateField(DateTime selectedDate) {
    return ListTile(
      title: Text("Date: ${DateFormat('yyyy-mm-dd').format(selectedDate)}"),
      trailing: Icon(Icons.calendar_today),
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context, 
          initialDate: selectedDate,
          firstDate: DateTime(2000), 
          lastDate: DateTime(2100)
        );
        if (picked != null && picked != selectedDate) {
          setState(() {
            _selectedDate = picked;
          });
        }
      },
    );
  }

  Widget buildCategoryDropdown(ExpenseProvider prorvider) {
    return DropdownButtonFormField<String>(
      value: _selectedCategoryId,
      onChanged: (newValue) {
        if (newValue == 'New') {
          showDialog(
            context: context, 
            builder: (context) => AddCategoryDialog(onAdd: (newCategory) {
              setState(() {
                _selectedCategoryId = newCategory.id;
                prorvider.addCategory(newCategory);
              });
            },),
          );
        } else {
          setState(() {
            _selectedCategoryId = newValue;
          });
        }
      },
      items: prorvider.categories.map<DropdownMenuItem<String>>((category) {
        return DropdownMenuItem(
          value: category.id,
          child: Text(category.name)
        );
      },).toList()..add(DropdownMenuItem(
        value: 'New',
        child: Text("Add New Category")
      )),
      decoration: InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder()
      ),
    );
  }

  Widget buildTagDropdown(ExpenseProvider provider) {
    return DropdownButtonFormField<String>(
      value: _selectedTagId,
      onChanged: (newValue) {
        if (newValue == 'New') {
          showDialog(
            context: context, 
            builder: (context) => AddTagDialog(onAdd: (newTag) {
              setState(() {
                _selectedTagId = newTag.id;
                provider.addTag(newTag);
              });
            },),
          );
        } else {
          setState(() {
            _selectedTagId = newValue;
          });
        }
      },
      items: provider.tags.map<DropdownMenuItem<String>>((category) {
        return DropdownMenuItem(
          value: category.id,
          child: Text(category.name)
        );
      },).toList()..add(DropdownMenuItem(
        value: 'New',
        child: Text('Add New Tag')
      )),
      decoration: InputDecoration(
        labelText: 'Tag',
        border: OutlineInputBorder()
      ),
    );
  }
}