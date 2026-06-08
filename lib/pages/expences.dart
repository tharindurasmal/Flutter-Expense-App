import 'package:expence_app/models/expence.dart';
import 'package:flutter/material.dart';
import 'package:expence_app/widgets/expence_list.dart';
import 'package:expence_app/widgets/add_new_expence.dart';

class Expences extends StatefulWidget {
  const Expences({super.key});
  @override
  State<Expences> createState() => _ExpencesState();
}

class _ExpencesState extends State<Expences> {
  // dummy list of expences
  final List<ExpenceModel> _expenceList = [
    ExpenceModel(
      title: 'expence 1',
      amount: 10.0,
      date: DateTime.now(),
      category: Category.food,
    ),
    ExpenceModel(
      title: 'expence 2',
      amount: 20.0,
      date: DateTime.now(),
      category: Category.leisure,
    ),
    ExpenceModel(
      title: 'expence 3',
      amount: 30.0,
      date: DateTime.now(),
      category: Category.travel,
    ),
    ExpenceModel(
      title: 'expence 4',
      amount: 30.0,
      date: DateTime.now(),
      category: Category.travel,
    ),
    ExpenceModel(
      title: 'expence 5',
      amount: 30.0,
      date: DateTime.now(),
      category: Category.travel,
    ),ExpenceModel(
      title: 'expence 6',
      amount: 30.0,
      date: DateTime.now(),
      category: Category.travel,
    ),ExpenceModel(
      title: 'expence 7',
      amount: 30.0,
      date: DateTime.now(),
      category: Category.travel,
    ),ExpenceModel(
      title: 'expence 8',
      amount: 30.0,
      date: DateTime.now(),
      category: Category.travel,
    ),ExpenceModel(
      title: 'expence 9',
      amount: 30.0,
      date: DateTime.now(),
      category: Category.travel,
    ),ExpenceModel(
      title: 'expence 10',
      amount: 30.0,
      date: DateTime.now(),
      category: Category.travel,
    ),
  ];

//function to add new expence to the list
  void _openAddExpenceOverlay() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return AddNewExpence(onAddExpence: (newExpence) {
          setState(() {
            _expenceList.add(newExpence);
          });
        },);
      },
    );
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expences', style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 253, 253, 253),
        ),),
        backgroundColor: const Color.fromARGB(255, 44, 136, 182),
        elevation: 0,
        actions: [
          Container(
            color: const Color.fromARGB(255, 226, 230, 45),
            child: IconButton(
              onPressed: _openAddExpenceOverlay,
              icon: const Icon(Icons.add),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          ExpenceList(expenceList: _expenceList),
        ],
      )
    );

  }
}