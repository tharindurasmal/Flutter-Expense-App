import 'dart:async';
import 'package:flutter/material.dart';
import 'package:expence_app/models/expence.dart';
import 'package:expence_app/widgets/expence_list.dart';
import 'package:expence_app/widgets/add_new_expence.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:expence_app/server/database.dart';

class Expences extends StatefulWidget {
  const Expences({super.key});

  @override
  State<Expences> createState() => _ExpencesState();
}

class _ExpencesState extends State<Expences> {
  final Database db = Database();

  ExpenseModel? _recentDeleted;
  int? _recentIndex;
  bool _showUndoBanner = false;
  Timer? _undoTimer;

  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  bool _isYearView = false;

  @override
  void initState() {
    super.initState();
    db.loadDatabase();
  }

  // ---------------- ADD ----------------
  void _onAddExpence(ExpenseModel expence) {
    setState(() {
      db.expenceList.add(expence);
    });
    db.updateDatabase();
  }

  // ---------------- DELETE ----------------
  void _deleteExpence(ExpenseModel expence) {
    final index = db.expenceList.indexOf(expence);

    if (index == -1) return;

    setState(() {
      _recentDeleted = expence;
      _recentIndex = index;

      db.expenceList.removeAt(index);
      _showUndoBanner = true;
    });

    db.updateDatabase();

    _undoTimer?.cancel();
    _undoTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showUndoBanner = false;
          _recentDeleted = null;
          _recentIndex = null;
        });
      }
    });
  }

  // ---------------- UNDO ----------------
  void _undoDelete() {
    if (_recentDeleted == null) return;

    setState(() {
      db.expenceList.insert(_recentIndex!, _recentDeleted!);
      _showUndoBanner = false;
    });

    db.updateDatabase();
  }

  // ---------------- FILTER (MONTH + YEAR) ----------------
  List<ExpenseModel> get filteredExpenses {
    return db.expenceList.where((e) {
      final sameYear = e.date.year == _selectedYear;

      if (_isYearView) {
        return sameYear;
      } else {
        return sameYear && e.date.month == _selectedMonth;
      }
    }).toList();
  }

  // ---------------- PIE DATA ----------------
  Map<String, double> get safeDataMap {
    final Map<String, double> data = {};

    for (var e in filteredExpenses) {
      final key = e.category.name;
      data[key] = (data[key] ?? 0) + e.amount;
    }

    if (data.isEmpty) {
      return {"No Data": 1};
    }

    return data;
  }

  // ---------------- TIME SELECTOR ----------------
  Widget _buildTimeSelector() {
    return Column(
      children: [
        const SizedBox(height: 10),

        // Toggle buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _toggleButton("Month", !_isYearView, () {
              setState(() => _isYearView = false);
            }),
            const SizedBox(width: 10),
            _toggleButton("Year", _isYearView, () {
              setState(() => _isYearView = true);
            }),
          ],
        ),

        const SizedBox(height: 10),

        // MONTH CHIPS
        if (!_isYearView) _buildMonthFilter(),

        // YEAR DROPDOWN
        if (_isYearView)
          DropdownButton<int>(
            value: _selectedYear,
            items: List.generate(5, (i) {
              final year = DateTime.now().year - i;
              return DropdownMenuItem(
                value: year,
                child: Text("$year"),
              );
            }),
            onChanged: (value) {
              setState(() {
                _selectedYear = value!;
              });
            },
          ),
      ],
    );
  }

  // ---------------- TOGGLE BUTTON ----------------
  Widget _toggleButton(String text, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: active
              ? const Color.fromARGB(255, 44, 136, 182)
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: active ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ---------------- MONTH FILTER ----------------
  Widget _buildMonthFilter() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 12,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          final month = index + 1;
          final isSelected = _selectedMonth == month;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedMonth = month;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color.fromARGB(255, 44, 136, 182)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _monthShortName(month),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "$month",
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected ? Colors.white70 : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _monthShortName(int m) {
    const months = [
      "JAN","FEB","MAR","APR","MAY","JUN",
      "JUL","AUG","SEP","OCT","NOV","DEC"
    ];
    return months[m - 1];
  }

  // ---------------- TOTAL ----------------
  double get totalBalance {
    return filteredExpenses.fold(0.0, (sum, e) => sum + e.amount);
  }

  Widget _buildTotalCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Total Spending",
                  style: TextStyle(color: Colors.grey)),
              SizedBox(height: 6),
              Text("Expenses",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          Text(
            "Rs ${totalBalance.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    final chartData = safeDataMap;
    final hasData = chartData.values.any((e) => e > 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Expense Tracker",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => AddNewExpence(
              onAddExpence: _onAddExpence,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          _buildTimeSelector(),
          _buildTotalCard(),

          const SizedBox(height: 10),

          SizedBox(
            height: 220,
            child: hasData
                ? PieChart(
                    dataMap: chartData,
                    chartType: ChartType.disc,
                    chartValuesOptions: const ChartValuesOptions(
                      showChartValues: true,
                    ),
                  )
                : const Center(
                    child: Text("No expenses found"),
                  ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: ExpenceList(
              expenceList: filteredExpenses,
              onDeleteExpence: _deleteExpence,
            ),
          ),

          if (_showUndoBanner)
            Container(
              color: Colors.black,
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Expense deleted",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: _undoDelete,
                    child: const Text(
                      "UNDO",
                      style: TextStyle(color: Colors.amber),
                    ),
                  )
                ],
              ),
            )
        ],
      ),
    );
  }
}