import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  ChartBar({this.spendingProductOfTotal});
  final double spendingProductOfTotal;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 10,
      //
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // TODO: This widget below will overlap on the previous one, widgets can overlap based on Stack
          FractionallySizedBox(
            // TODO: a rate ~ 1
            heightFactor: spendingProductOfTotal,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
