import 'package:flutter/material.dart';
import 'package:expence_app/models/expence.dart';
import 'package:expence_app/widgets/expense_tile.dart';

class ExpenceList extends StatelessWidget {
  const ExpenceList({
    super.key,
    required this.expenceList,
    required this.onDeleteExpence,
  });

  final List<ExpenseModel> expenceList;

  final void Function(ExpenseModel expence) onDeleteExpence;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenceList.length,
      itemBuilder: (context, index) {
        final item = expenceList[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Dismissible(
            key: ValueKey(item.id),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) {
              onDeleteExpence(item);
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: ExpenceTile(
              expence: item,
            ),
          ),
        );
      },
    );
  }
}