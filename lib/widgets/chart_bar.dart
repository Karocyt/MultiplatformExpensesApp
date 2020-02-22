import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double maxSpending;

  const ChartBar(this.label, this.spendingAmount, this.maxSpending);

  @override
  Widget build(BuildContext context) {
    const radius = 10.0;

    // print('debug');
    // print(spendingAmount);
    // print(maxSpending);
    // print(spendingAmount / maxSpending);
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: <Widget>[
          Container(
            height: constraints.maxHeight * 0.15,
            child: FittedBox(
              child: Text('${spendingAmount.toStringAsFixed(0)} €'),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: constraints.maxHeight * 0.05,
            ),
            height: constraints.maxHeight * 0.7,
            width: 10,
            child: Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    color: Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(radius),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor:
                      spendingAmount != 0 ? spendingAmount / maxSpending : 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(radius),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: constraints.maxHeight * 0.15,
            child: FittedBox(child: Text(label)),
          ),
        ],
      );
    });
  }
}
