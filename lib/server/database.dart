import 'package:hive/hive.dart';
import 'package:expence_app/models/expence.dart';

class Database {
  final _myBox = Hive.box("expencesDatabase");

  List<ExpenseModel> expenceList = [];

  // ---------------- LOAD ----------------
  void loadDatabase() {
    final data = _myBox.get("EXPENCE_LIST");

    if (data == null) {
      // 🔥 FIRST TIME APP RUN = EMPTY LIST
      expenceList = [];

      // save empty state to Hive
      updateDatabase();
    } else {
      expenceList = List<ExpenseModel>.from(data);
    }
  }

  // ---------------- SAVE / UPDATE ----------------
  Future<void> updateDatabase() async {
    await _myBox.put("EXPENCE_LIST", expenceList);
  }
}