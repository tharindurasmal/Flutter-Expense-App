import 'package:expence_app/models/expence.dart';
import 'package:flutter/material.dart';

class ExpenceTile extends StatelessWidget {
  const ExpenceTile({super.key, required this.expence});

  final ExpenceModel expence;

  @override
  Widget build(BuildContext context) {
    return Card( color: const Color.fromARGB(255, 248, 246, 246),
                  child: ListTile(
                    title: Text(expence.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 206, 74, 74)),),
                    subtitle: Text(expence.amount.toStringAsFixed(2)),
                    leading: Icon(
                      expence.category == Category.food
                          ? Icons.fastfood
                          : expence.category == Category.leisure
                              ? Icons.movie
                              : expence.category == Category.travel
                                  ? Icons.flight
                                  : Icons.work,
                      color: const Color.fromARGB(255, 44, 136, 182),
                    ),
                    trailing: Text(expence.date.toString()),
                  ),
                );
  }
}