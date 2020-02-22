import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:intl/intl.dart';
import 'adaptive_flat_button.dart';

// Add to check git
class NewTransaction extends StatefulWidget {
  NewTransaction({@required this.addTransaction}) {
    print('Contructor');
  }
  final Function addTransaction;

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _datePicker;

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);
    final enteredDate = _datePicker;

    if (enteredTitle.isEmpty ||
        enteredAmount <= 0 ||
        enteredAmount.isNaN ||
        _datePicker == null) {
      return;
    }

    widget.addTransaction(
      enteredTitle,
      enteredAmount,
      enteredDate,
    );

    // TODO: Navigate to previous page
    Navigator.pop(context);
  }

  // TODO: showDatePicker
  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((picker) {
      if (picker == null) {
        return;
      }

      setState(() {
        _datePicker = picker;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Using 'SingleChildScrollView' to avoid overlapping by keyboard
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          right: 20,
          left: 20,
          top: 10,
          // TODO: Limit bottom of card with the last widget is 10
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              controller: _titleController,
              // TODO: (_) means don't care about parameters/arguments
              onSubmitted: (_) => _submitData(),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Amount'),
              controller: _amountController,
              // TODO: .numberWithOptions(decimal: true) for iOS, .number for android
              keyboardType: Platform.isIOS
                  ? const TextInputType.numberWithOptions(decimal: true)
                  : TextInputType.number,
              onSubmitted: (_) => _submitData(),
            ),
            Container(
              height: 70,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(_datePicker == null
                        ? 'No Date Chosen'
                        : 'Picked Date: ${DateFormat.yMMMd().format(_datePicker)}'),
                  ),
                  AdaptiveFlatButton(
                    text: 'Choose Date',
                    presentDate: _presentDatePicker,
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: _submitData,
              child: const Text(
                'Add Transaction',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              // TODO: Set color from global theme
              color: Theme.of(context).primaryColor,
              textColor: Theme.of(context).textTheme.button.color,
            )
          ],
        ),
      ),
    );
  }
}
