import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  TransactionList({@required this.transactions, this.deleteTransaction});
  final List<Transaction> transactions;
  final Function deleteTransaction;

  Widget showWaitingImage(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'No transactions added yet!',
          style: Theme.of(context).textTheme.title,
        ),
        SizedBox(
          height: 20,
        ),
        Flexible(
          child: Image.asset('assets/images/waiting.png'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Cannot using Expanded widget for that contains ListView, because of its infinity height
    return transactions.isEmpty
        ? showWaitingImage(context)
        : ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                elevation: 5,
                // TODO: using ListTile to define elements in ListView
                child: ListTile(
                  leading: CircleAvatar(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: FittedBox(
                        child: Text(
                          '\$${transactions[index].amount.toStringAsFixed(2)}',
                        ),
                      ),
                    ),
                    radius: 30,
                  ),
                  title: Text(
                    transactions[index].title,
                    style: Theme.of(context).textTheme.title,
                  ),
                  subtitle: Text(
                    DateFormat('MMM d, yyyy').format(transactions[index].date),
                  ),
                  // TODO: if phone width > 500, use FlatButton.icon widget
                  trailing: MediaQuery.of(context).size.width > 500
                      ? FlatButton.icon(
                          label: Text('Delete'),
                          icon: Icon(Icons.delete),
                          textColor: Theme.of(context).errorColor,
                          onPressed: () =>
                              deleteTransaction(transactions[index].id),
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).errorColor,
                          ),
                          onPressed: () {
                            deleteTransaction(transactions[index].id);
                          },
                        ),
                ),
              );
            },
            itemCount: transactions.length,
          );
  }
}
