import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
// import 'package:flutter/services.dart'; // SystemChrome

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';
import './widgets/chart.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([ // the lazy way
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

/*
  Dirty trick for release mode, when MediaQuery doesn't hold values at stratup.
  needs to be provided in a stream as future in FutureBuilder, with a builder function that takes
  a snapshot parameter and returns an empty container if snapshot.hasData is false.
  Example stream: 
    future: whenNotZero(
      Stream<double>.periodic(Duration(milliseconds: 50),
      (x) => MediaQuery.of(context).size.width),
    ),
*/
// 
// Future<double> whenNotZero(Stream<double> source) async {
//   await for (double value in source) {
//     print("Width:" + value.toString());
//     if (value > 0) {
//       print("Width > 0: " + value.toString());
//       return value;
//     }
//   }
//   // stream exited without a true value, maybe return an exception.
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    // MediaQuery not available yet, and all fonts are scaled by default, awesome !
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          //errorColor: Colors.red, // red is already default
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              button: TextStyle(
                color: Colors.white,
              )),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [];
  bool _showChart = true;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime txDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: txDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() => _userTransactions.removeWhere((item) => item.id == id));
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  List<Widget> _buildLandscapeContent(contentSize, transactionListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Show Chart'),
          Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _showChart,
            onChanged: (val) => setState(() => _showChart = val),
          )
        ],
      ),
      _showChart
          ? Chart(
              height: contentSize * 0.7,
              recentTransactions: _recentTransactions,
            )
          : transactionListWidget,
    ];
  }

  List<Widget> _buildPortraitContent(contentSize, transactionListWidget) {
    return [
      Chart(
        height: contentSize * 0.3,
        recentTransactions: _recentTransactions,
      ),
      transactionListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bool _isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Personal Expenses',
              style: Theme.of(context).textTheme.title,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              // otherwise Row takes all the width and we don't have the 'middle' text
              children: <Widget>[
                GestureDetector(
                    onTap: () => _startAddNewTransaction(context),
                    child: const Icon(CupertinoIcons.add))
              ],
            ),
          )
        : AppBar(
            title: const Text(
              'Personal Expenses',
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              ),
            ],
          );
    final contentSize = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;
    print(mediaQuery.size.height);
    print(contentSize);
    final _transactionListWidget = Container(
      height: contentSize * 0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );
    final body = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _isLandscape
              ? _buildLandscapeContent(contentSize, _transactionListWidget)
              : _buildPortraitContent(contentSize, _transactionListWidget),
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: body,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: body,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
