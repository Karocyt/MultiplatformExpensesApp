import 'package:flutter/material.dart';

import '../models/transaction.dart';
import './transaction_card.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (context, constraints) => Column(
              children: <Widget>[
                Text(
                  'No transactions added yet!',
                  style: Theme.of(context).textTheme.title,
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return TransactionCard(key: ValueKey(transactions[index].id), transaction: transactions[index], deleteTx: deleteTx);
            },
            itemCount: transactions.length,
          );
  }
}
