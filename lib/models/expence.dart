import 'package:uuid/uuid.dart'; // import the uuid package to generate unique ids for expences

// create a uuid object
final uuid = const Uuid().v4();

// enum for category of expence
enum Category {
  food,
  leisure,
  travel,
  work,
}
// model class for expence
class ExpenceModel {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

// constructor
  ExpenceModel({
    required this.title,
    required this.amount,
    required this.date,
    required this.category
  })
  : id = uuid; // assign the generated uuid to the id field
}