import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'transaction_item.dart';

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
        const SizedBox(
          height: 20,
        ),
        Flexible(
          child: Image.asset(
            'assets/images/waiting.png',
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print('build TransationList()');
    // TODO: Cannot using Expanded widget for that contains ListView, because of its infinity height
    return transactions.isEmpty
        ? showWaitingImage(context)
        : ListView(
            children: transactions
                .map((tx) => TransactionItem(
                      key: ValueKey(tx.id),
                      transactions: tx,
                      deleteTransaction: deleteTransaction,
                    ))
                .toList(),
          );
  }
}

//ListView.builder(
//itemBuilder: (context, index) {
//return TransactionItem(
//transactions: transactions[index],
//deleteTransaction: deleteTransaction,
//);
//},
//itemCount: transactions.length,
//);
