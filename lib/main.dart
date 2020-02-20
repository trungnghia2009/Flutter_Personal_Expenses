import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'widgets/new_transaction.dart';
import 'models/transaction.dart';
import 'widgets/transaction_list.dart';
import 'widgets/chart.dart';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';

const Color myColor = Colors.red;

void main() {
  runApp(new MyApp());
//  SystemChrome.setPreferredOrientations([
//    DeviceOrientation.portraitUp,
//    DeviceOrientation.portraitDown,
//  ]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // TODO: Theme sets up for global application
      theme: ThemeData(
        // TODO: Set color,
        errorColor: Colors.red,
        primarySwatch: Colors.purple, // Set color to primary color
        accentColor: Colors.amber, // Set color to FloatingActionButton/Switch
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

  bool _switchValue = false;

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
    // TODO: assign isLandscape as bool type follow Orientation.landscape
    final mediaQueryData = MediaQuery.of(context);
    final isLandscape = mediaQueryData.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Personal Expenses',
            ),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: Semantics(
                child: Icon(
                  CupertinoIcons.add,
                  size: 32,
                ),
              ),
              onPressed: () => _startAddNewTransaction(context),
            ),
          )
        : AppBar(
            title: Text(
              'Personal Expenses',
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
          );

    final txListWidget = Container(
      height: (mediaQueryData.size.height -
              appBar.preferredSize.height -
              mediaQueryData.padding.top) *
          0.7,
      child: TransactionList(
        transactions: _recentTransactions,
        deleteTransaction: _deleteTransaction,
      ),
    );

    final bodyPage = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // TODO: For landscape mode
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Show Chart',
                    style: Theme.of(context).textTheme.title,
                  ),
                  Switch.adaptive(
                      activeColor: Theme.of(context).accentColor,
                      value: _switchValue,
                      onChanged: (val) {
                        setState(() {
                          _switchValue = val;
                        });
                      })
                ],
              ),
            if (isLandscape)
              _switchValue
                  ? Container(
                      // TODO: (total height - appBar height - statusBar height) * dynamic rate
                      height: (mediaQueryData.size.height -
                              appBar.preferredSize.height -
                              mediaQueryData.padding.top) *
                          0.7,
                      child: Chart(recentTransactions: _userTransactions),
                    )
                  : txListWidget,

            // TODO: For portrait mode
            if (!isLandscape)
              Container(
                height: (mediaQueryData.size.height -
                        appBar.preferredSize.height -
                        mediaQueryData.padding.top) *
                    0.3,
                child: Chart(recentTransactions: _userTransactions),
              ),
            if (!isLandscape)
              txListWidget,
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: bodyPage,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      _startAddNewTransaction(context);
                    },
                  ),
            // TODO: add SingleChildScrollView on the top to fix pixel overlapping by keyboard
            body: bodyPage,
          );
  }
}
