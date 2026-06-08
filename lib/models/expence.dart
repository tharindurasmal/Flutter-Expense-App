import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';

part 'expence.g.dart';

const Uuid uuid = Uuid();

@HiveType(typeId: 2)
enum Category {
  @HiveField(0)
  food,

  @HiveField(1)
  leisure,

  @HiveField(2)
  travel,

  @HiveField(3)
  work,
}

@HiveType(typeId: 1)
class ExpenseModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final Category category;

  ExpenseModel({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();
}