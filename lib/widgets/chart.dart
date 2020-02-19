import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses_app/models/transaction.dart';
import 'chart_bar.dart';

class Chart extends StatelessWidget {
  Chart({@required this.recentTransactions});
  final List<Transaction> recentTransactions;

  // TODO: Using getter for no argument method
  // TODO: This is just a handy way of modifying a property when some other part of the code tries to read it
  // TODO: The same as setter but having arguments
  // TODO: Pay attention on List<Map<String, Object>>
  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(Duration(days: index));

      double totalValue = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekday.day &&
            recentTransactions[i].date.month == weekday.month &&
            recentTransactions[i].date.year == weekday.year) {
          totalValue += recentTransactions[i].amount;
        }
      }

//      print(index);
//      print(totalValue);
//      print(DateFormat.E().format(weekday));
//      print('---------------------------');

      return {
        'day': DateFormat.E().format(weekday).substring(0, 1),
        'amount': totalValue.toStringAsFixed(0)
      };
      // TODO: move current day to the last
    }).reversed.toList();
  }

  // TODO: get total Spending using fold method for a list
  // TODO: need more practises in this
  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + double.parse(item['amount']);
    });
  }

  List<Column> get chartList {
    return List.generate(7, (index) {
      final amount = groupedTransactionValues[index]['amount'];

      return Column(
        children: <Widget>[
          Text('\$$amount'),
          SizedBox(height: 4),
          ChartBar(
              // TODO: a certain day amount / total amount
              // TODO: avoid totalSpending = 0 when there is no transaction data
              spendingProductOfTotal: totalSpending == 0.0
                  ? 0.0
                  : double.parse(amount) / totalSpending),
          SizedBox(height: 4),
          Text('${groupedTransactionValues[index]['day']}'),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(20),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: chartList,
        ),
      ),
    );
  }
}
