import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  final double height;

  Chart({this.recentTransactions, @required this.height});

  List<Map<String, Object>> get groupedTransactionsValues {
    return List.generate(7, (index) {
      final currentDay = DateTime.now().subtract(Duration(days: index));
      final weekDay = DateFormat.E().format(currentDay);
      var totalSum = 0.0;

      for (var item in recentTransactions) {
        if (item.date.day == currentDay.day &&
            item.date.month == currentDay.month &&
            item.date.year == currentDay.year) totalSum += item.amount;
      }
      return {
        'day': weekDay,
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get weeklySpending {
    return groupedTransactionsValues.fold(
      0.0,
      (curr, item) => curr + item['amount'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      child: Card(
        elevation: 6,
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransactionsValues
                .map((dailyTransactions) => Flexible(
                      fit: FlexFit.tight,
                      child: ChartBar(
                        dailyTransactions['day'],
                        dailyTransactions['amount'],
                        weeklySpending,
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
