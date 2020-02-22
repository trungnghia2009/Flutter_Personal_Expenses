import 'dart:math';

import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key key,
    @required this.transactions,
    @required this.deleteTransaction,
  }) : super(key: key);

  final Transaction transactions;
  final Function deleteTransaction;

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color bgColor;

  @override
  void initState() {
    super.initState();

    const availableColor = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.amber,
      Colors.teal,
    ];

    bgColor = availableColor[Random().nextInt(6)];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      elevation: 5,
      // TODO: using ListTile to define elements in ListView
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: bgColor,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: FittedBox(
              child: Text(
                '\$${widget.transactions.amount.toStringAsFixed(2)}',
              ),
            ),
          ),
          radius: 30,
        ),
        title: Text(
          widget.transactions.title,
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Text(
          DateFormat('MMM d, yyyy').format(widget.transactions.date),
        ),
        // TODO: if phone width > 500, use FlatButton.icon widget
        trailing: MediaQuery.of(context).size.width > 500
            ? FlatButton.icon(
                label: const Text('Delete'),
                icon: const Icon(Icons.delete),
                textColor: Theme.of(context).errorColor,
                onPressed: () =>
                    widget.deleteTransaction(widget.transactions.id),
              )
            : IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                onPressed: () {
                  widget.deleteTransaction(widget.transactions.id);
                },
              ),
      ),
    );
  }
}
