import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'widgets/new_transaction.dart';
import 'models/transaction.dart';
import 'widgets/transaction_list.dart';
import 'widgets/chart.dart';

const Color myColor = Colors.red;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // TODO: Theme sets up for global application
      theme: ThemeData(
        // TODO: Set color,
        errorColor: Colors.red,
        primarySwatch: Colors.purple, // Set color to primary color
        accentColor: Colors.amber, // Set color to FloatingActionButton
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
            // Set style for text
            title: TextStyle(
              fontSize: 18,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
            ),
            button: TextStyle(
              color: Colors.white,
            )),
      ),
      title: 'Personal Expenses',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Transaction> _userTransactions = [
//    Transaction(
//      id: 'id1',
//      title: 'New Shoes',
//      amount: 59.99,
//      date: DateTime.now(),
//    ),
//    Transaction(
//      id: 'id2',
//      title: 'New Groceries',
//      amount: 20.99,
//      date: DateTime.now(),
//    ),
  ];

  // TODO: 'where' method exists in every List, allow to run a function
  // TODO: if function returns true, the item is kept in a newly returned list
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      // TODO: We get the transactions of the past seven days.
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addTransaction(String title, double amount, DateTime dateTime) {
    final newTx = Transaction(
      title: title,
      amount: amount,
      date: dateTime,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      // TODO: use .removeWhere to remove element in list with condition
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  // TODO: Add BottomSheet
  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(
            addTransaction: _addTransaction,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Personal Expenses',
          style: TextStyle(fontFamily: 'OpenSans'),
        ),
        actions: <Widget>[
          // TODO: Remember types of button, IconButton, FlatButton ....
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _startAddNewTransaction(context);
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _startAddNewTransaction(context);
        },
      ),
      // TODO: add SingleChildScrollView on the top to fix pixel overlapping by keyboard
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Chart(
                recentTransactions: _userTransactions,
              ),
              // TODO: Remember this!!, there is no () in _addTransaction function
              // TODO: setSate() was only implemented in Stateful class
              TransactionList(
                transactions: _recentTransactions,
                deleteTransaction: _deleteTransaction,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
