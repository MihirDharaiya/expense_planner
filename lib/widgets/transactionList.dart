import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_planner/models/transaction.dart';
import 'package:intl/intl.dart';
class TransactionList extends StatelessWidget {

  final  List<Transaction> transactions;
  final  Function deleteTx;
  TransactionList(this.transactions,this.deleteTx);
  @override
  Widget build(BuildContext context) {
    return  transactions.isEmpty ? LayoutBuilder(builder: (ctx,constraints){
      return Center(
          child: Column(children: [Text('Nothing Added Yet!!!!!'),
      SizedBox(height: 20.0,),
      Container(height: constraints.maxHeight*0.6,
      child: Image.asset('assets/images/waiting.png',fit: BoxFit.cover,)),
      ],
      ),
      );
    }) : ListView.builder(
        itemBuilder: (ctx,index){
          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 8,horizontal: 5),
            child: ListTile(leading: CircleAvatar(radius: 30.0,child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: FittedBox(child: Text('\$${transactions[index].amount}')),
            ),
            ),
              title: Text(transactions[index].title,style: Theme.of(context).textTheme.title,
              ),
              subtitle: Text(DateFormat.yMMMd().format(transactions[index].date),
              ),
              trailing: MediaQuery.of(context).size.width > 400 ? FlatButton.icon(
                icon:Icon(Icons.delete),
                onPressed: () => deleteTx(transactions[index].id),
                label: Text('Delete'),
                textColor:Theme.of(context).errorColor ,) :
              IconButton(
                icon:Icon(Icons.delete),
                onPressed: () => deleteTx(transactions[index].id),
                color: Theme.of(context).errorColor,),
            ),
          );
        },
        itemCount: transactions.length,
    );
  }
}
