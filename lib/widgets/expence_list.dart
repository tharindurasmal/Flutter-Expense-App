import 'package:expence_app/models/expence.dart';
import 'package:flutter/material.dart';
import 'package:expence_app/widgets/expense_tile.dart';
class ExpenceList extends StatelessWidget {
  const ExpenceList({super.key, required this.expenceList});

  final List<ExpenceModel> expenceList;

  @override
  Widget build(BuildContext context) {
    return Expanded(
            child: ListView.builder(
              itemCount: expenceList.length,
              itemBuilder: (context, index) {
                return ExpenceTile(
                  expence: expenceList[index],
                );
              },
            ),
          );
  }
}