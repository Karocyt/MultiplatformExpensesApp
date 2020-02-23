import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionCard extends StatefulWidget {
  const TransactionCard({
    Key key,
    @required this.transaction,
    @required this.deleteTx,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTx;
  static const _availableColors = [
    Colors.blue,
    Colors.purple,
    Colors.black,
    Colors.red,
  ];

  @override
  _TransactionCardState createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  final _bgColor = TransactionCard._availableColors[
      Random().nextInt(TransactionCard._availableColors.length)];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: _bgColor,
            child: FittedBox(
              child: Text('${widget.transaction.amount.toStringAsFixed(2)} €'),
            ),
          ),
          title: Text(
            widget.transaction.title,
            style: Theme.of(context).textTheme.title,
          ),
          subtitle: Text(
            DateFormat.yMMMd().format(widget.transaction.date),
          ),
          trailing: MediaQuery.of(context).size.width >= 400
              ? FlatButton.icon(
                  label: const Text('Delete'),
                  icon: const Icon(Icons.delete),
                  textColor: Theme.of(context).errorColor,
                  onPressed: () => widget.deleteTx(widget.transaction.id),
                )
              : IconButton(
                  icon: const Icon(Icons.delete),
                  color: Theme.of(context).errorColor,
                  onPressed: () => widget.deleteTx(widget.transaction.id),
                )),
    );
  }
}
