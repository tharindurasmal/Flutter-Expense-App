import 'dart:math';
import 'package:flutter/material.dart';
import 'package:expence_app/models/expence.dart';

class AddNewExpence extends StatefulWidget {
  const AddNewExpence({super.key, required this.onAddExpence});

  final Function(ExpenceModel) onAddExpence;

  @override
  State<AddNewExpence> createState() => _AddNewExpenceState();
}

class _AddNewExpenceState extends State<AddNewExpence> {

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  Category _selectedCategory = Category.food;

  //handle form submission
  void _submitExpence() {
    final title = _titleController.text;
    final amount = double.tryParse(_amountController.text);
    final date = DateTime.tryParse(_dateController.text);

    if (title.isEmpty || amount == null || date == null || amount <= 0) {
      // show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields correctly')),
      );
      return;
    }
// create a new expence object
    final newExpence = ExpenceModel(
      title: title,
      amount: amount,
      date: date,
      category: _selectedCategory,
    );

    widget.onAddExpence(newExpence);
    Navigator.pop(context); // close the form after submission
  }
// dispose controllers to free up resources
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column( 
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [// title text field and amount text field
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: 'Enter expence title',
              labelText: 'Title'),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(
              hintText: 'Enter expence amount',
                labelText: 'Amount'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16.0),
          // category dropdown and date picker in a row
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: Category.values
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category.name.toUpperCase()),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
              ),

              const SizedBox(width: 12),
              // date picker
              Expanded(
                child: TextField(
                  controller: _dateController,
                  readOnly: true,
                  style: const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );

                    if (pickedDate != null) {
                      _dateController.text = pickedDate.toString().split(' ')[0];
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          // add and cancel buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // cancel closes screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _submitExpence,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Add Expense'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),   
        ],
      ),
    );
  }
}