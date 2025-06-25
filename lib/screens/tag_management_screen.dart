import 'package:expense_manager/providers/expense_provider.dart';
import 'package:expense_manager/widgets/add_tag_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TagManagementScreen extends StatelessWidget {
  const TagManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Tags'),
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ExpenseProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.tags.length,
            itemBuilder: (context, index) {
              final tag = provider.tags[index];
              return ListTile(
                title: Text(tag.name),
                trailing: IconButton(
                  onPressed: () {
                    provider.removeTag(tag.id);
                  }, 
                  icon: Icon(Icons.delete, color: Colors.red,)
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context, 
            builder: (context) => AddTagDialog(
              onAdd: (newTag) {
                Provider.of<ExpenseProvider>(context, listen: false).addTag(newTag);
              }, 
            ),
          );
        },
        tooltip: 'Add New Tag',
        child: Icon(Icons.add),
      ),
    );
  }
}