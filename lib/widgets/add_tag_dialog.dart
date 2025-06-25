import 'package:expense_manager/models/tag.dart';
import 'package:expense_manager/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTagDialog extends StatefulWidget {
  final Function(Tag) onAdd;
  
  const AddTagDialog({required this.onAdd});

  @override
  State<AddTagDialog> createState() => _AddTagDialogState();
}

class _AddTagDialogState extends State<AddTagDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Tag'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'Tag Name'
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), 
          child: Text('Cancel')
        ),
        TextButton(
          onPressed: () {
            var newTag = Tag(id: DateTime.now().toString(), name: _controller.text);
            widget.onAdd(newTag);
            Provider.of<ExpenseProvider>(context, listen: false).addTag(newTag);
            _controller.clear();

            Navigator.of(context).pop();
          }, child: Text('Add')
        )
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}