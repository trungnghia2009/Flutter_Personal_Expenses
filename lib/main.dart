import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'widgets/new_transaction.dart';
import 'models/transaction.dart';
import 'widgets/transaction_list.dart';
import 'widgets/chart.dart';
import 'dart:io' show Platform;

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

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  // TODO: App lifeCycle
  // ----------------------------------
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print(state);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.addObserver(this);
  }
  // -----------------------------------------------

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
        // TODO: isScrollControlled == true allow the bottom sheet to take the full required height
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        isScrollControlled: true,
        context: ctx,
        builder: (_) {
          return NewTransaction(
            addTransaction: _addTransaction,
          );
        });
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQueryData, AppBar appBar, Widget txListWidget) {
    return [
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
      _switchValue
          ? Container(
              // TODO: (total height - appBar height - statusBar height) * dynamic rate
              height: (mediaQueryData.size.height -
                      appBar.preferredSize.height -
                      mediaQueryData.padding.top) *
                  0.7,
              child: Chart(recentTransactions: _userTransactions),
            )
          : txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(MediaQueryData mediaQueryData,
      PreferredSizeWidget appBar, Widget txListWidget) {
    return [
      Container(
        height: (mediaQueryData.size.height -
                appBar.preferredSize.height -
                mediaQueryData.padding.top) *
            0.3,
        child: Chart(recentTransactions: _userTransactions),
      ),
      txListWidget
    ];
  }

  Widget _buildCupertinoNavigationBar() {
    return CupertinoNavigationBar(
      middle: const Text(
        'Personal Expenses',
      ),
      trailing: CupertinoButton(
        padding: EdgeInsets.zero,
        child: Semantics(
          child: const Icon(
            CupertinoIcons.add,
            size: 32,
          ),
        ),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Personal Expenses',
      ),
      actions: <Widget>[
        // TODO: Remember types of button, IconButton, FlatButton ....
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            _startAddNewTransaction(context);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print('build HomePage()');
    // TODO: assign isLandscape as bool type follow Orientation.landscape
    final mediaQueryData = MediaQuery.of(context);
    final isLandscape = mediaQueryData.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar =
        Platform.isIOS ? _buildCupertinoNavigationBar() : _buildAppBar();

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
          children: isLandscape
              ? _buildLandscapeContent(mediaQueryData, appBar, txListWidget)
              : _buildPortraitContent(mediaQueryData, appBar, txListWidget),

// TODO: can use '...' before List<Widget> to merge to one Widget
//          children: <Widget>[
//            if (!isLandscape)
//              ..._buildPortraitContent(mediaQueryData, appBar, txListWidget),
//            if (isLandscape)
//              ..._buildLandscapeContent(mediaQueryData, appBar, txListWidget)
//          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar,
            child: bodyPage,
          )
        : Scaffold(
            appBar: appBar,
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
