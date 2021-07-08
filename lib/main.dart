import 'package:expense_planner/widgets/Chart.dart';
import 'package:expense_planner/widgets/new_transaction.dart';
import 'package:expense_planner/widgets/transactionList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        brightness: Brightness.light,
        textTheme: ThemeData.light().textTheme.copyWith(
          button: TextStyle(color: Colors.white)
        )
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<Transaction> _userTransactions = [

  ];

  bool _showChart  = false;
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx){return tx.date.isAfter(
        DateTime.now().subtract(Duration( days: 7),));
    }).toList();
  }
  void _addNewTransaction(String txTitle,double txAmount,DateTime chosenDate){
    final newTx = Transaction(id: DateTime.now().toString(), title: txTitle, amount: txAmount, date: chosenDate);
    setState(() {
      _userTransactions.add(newTx);
    });
  }
  void _startAddNewTransaction(BuildContext ctx){
    showModalBottomSheet(context: ctx, builder: (_){
      return GestureDetector(
          onTap: (){},
          behavior: HitTestBehavior.opaque,
          child: NewTransaction(_addNewTransaction));
    });
  }

  void _deleteTransaction(String id){
      setState(() {
        _userTransactions.removeWhere((tx){
          return tx.id == id;
        });
      });
  }
  @override
  Widget build(BuildContext context) {
    final isLandscape =  MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = AppBar(
      title: Text('Expense Planner'),
      actions: [
        IconButton(icon: Icon(Icons.add), onPressed: ()=>_startAddNewTransaction(context)),
      ],
    );
    final txListWidget = Container(height: (MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top) * 0.7,
        child: TransactionList(_userTransactions,_deleteTransaction));
    return Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if(isLandscape) Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
               Text('Show Chart'),
               Switch.adaptive(value: _showChart, onChanged: (val) {
                 setState(() {
                   _showChart = val;
                 });
               })
             ],),
              if(!isLandscape)
                Container(
                    height: (MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top) * 0.3,
                    child: Chart(_recentTransactions)),
              if(!isLandscape) txListWidget,
              if(isLandscape)
              _showChart ? Container(
                  height: (MediaQuery.of(context).size.height - appBar.preferredSize.height - MediaQuery.of(context).padding.top) * 0.7,
                  child: Chart(_recentTransactions)): txListWidget,
            ],
          ),
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add),onPressed: ()=>_startAddNewTransaction(context),),
    );
  }
}
