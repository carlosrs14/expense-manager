import 'package:collection/collection.dart';
import 'package:expense_manager/providers/expense_provider.dart';
import 'package:expense_manager/screens/add_expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'By Added Date',),
            Tab(text: 'By Category',)
          ]
        )
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 120,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.green,),
                padding: EdgeInsets.all(20),
                child: Text('Menu', 
                  style: TextStyle(color: Colors.white, fontSize: 24,),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.category, color: Colors.green,),
              title: Text('Manage Categories'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/manage_categories');
              },
            ),
            ListTile(
              leading: Icon(Icons.tag, color: Colors.green,),
              title: Text('Manage Tags'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/manage_tags');
              },
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildExpensesByDate(context),
          buildExpensesByCategory(context)
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, 
          MaterialPageRoute(builder: (context) => AddExpenseScreen(),)
        ),
        tooltip: 'Add Expense',
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildExpensesByDate(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, child) {
        if (provider.expenses.isEmpty) {
          return Center(
            child: Text('Click the + button to record expenses',
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
          );
        }
        return ListView.builder(
          itemCount: provider.expenses.length,
          itemBuilder: (context, index) {
            final expense = provider.expenses[index];
            String formattedDate = DateFormat('yyyy-MM-dd').format(expense.date);
            return Dismissible(
              key: Key(expense.id), 
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                provider.removeExpense(expense.id);
              },
              background: Container(
                color: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerRight,
                child: Icon(Icons.delete, color: Colors.white,),
              ),
              child: Card(
                color: Colors.green,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: ListTile(
                  title: Text('${expense.payee} - \$${expense.amount.toStringAsFixed(2)}'),
                  subtitle: Text('$formattedDate - Category: ${getCategoryNameById(context, expense.categoryId)}'),
                  isThreeLine: true,
                ),
              )
            );
          },
        );
      },
    );
  }

  Widget buildExpensesByCategory(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, child) {
        if (provider.expenses.isEmpty) {
          return Center(
            child: Text('Click the + button to record expenses',
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
          );
        }
        var grouped = groupBy(provider.expenses, (e) => e.categoryId);
        return ListView(
          children: grouped.entries.map((e) {
            String categoryName = getCategoryNameById(context, e.key);
            double total = e.value.fold(0.0, (previousValue, element) => previousValue + element.amount,);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    '$categoryName -Total> \$${total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green
                    ),
                  ),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: e.value.length,
                  itemBuilder: (context, index) {
                    final expense = e.value[index];
                    return ListTile(
                      leading: Icon(Icons.monetization_on, color: Colors.green),
                      title: Text('${expense.payee} - \$${expense.amount.toStringAsFixed(2)}'),
                      subtitle: Text(DateFormat('yyyy-MM-dd').format(expense.date)),
                    );
                  },
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  String getCategoryNameById(BuildContext context, String categoryId) {
    var category = Provider.of<ExpenseProvider>(context, listen: false)
    .categories
    .firstWhere((cat) => cat.id == categoryId);
    return category.name;
  }
}