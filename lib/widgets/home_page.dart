import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'dart:io';
import 'package:excel/excel.dart' as flutter_excel;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../theme.dart';



class ExpenseTracker extends StatefulWidget {
  @override
  _ExpenseTrackerState createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker> {
  final Box paymentBox = Hive.box('payment_modes');
  final Box expenseBox = Hive.box('expenses');
  String? selectedMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: _buildAddExpenseButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      appBar: AppBar(
        title: Text('Expense Tracker'),
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(onPressed: _exportToExcel, child: Text("Export to Excel",style: TextStyle(color: textColor.withOpacity(0.5)),)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Row(
              children: [
                Expanded(child: _buildDropdown()),
                IconButton(icon: Icon(Icons.add), onPressed: _addPaymentMode),
              ],
            ),
          ),
          Expanded(child: _buildExpenseList()),
        ],
      ),
    );
  }

  late GlobalKey dropdownKey;

  @override
  void initState() {
    super.initState();
    List<String> modes =
        paymentBox.get('modes', defaultValue: <String>[])?.cast<String>() ?? [];
    dropdownKey = GlobalKey();
    setState(() {
      selectedMode = modes.isNotEmpty ? modes.first : null;
    });
  }

  Widget _buildDropdown() {
    List<String> modes =
        paymentBox.get('modes', defaultValue: <String>[])?.cast<String>() ?? [];
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        key: GlobalKey(),
        value: selectedMode,
        alignment: AlignmentDirectional.bottomEnd,
        hint: Align(alignment:AlignmentDirectional.centerStart, child: Text('Select Payment Mode')),
        isExpanded: true,
        buttonStyleData: ButtonStyleData(
          // height: 50,
          // width: 160,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black26),
            // color: Colors.redAccent,
          ),
          // elevation: 2,
        ),

        dropdownStyleData: DropdownStyleData(
          // maxHeight: 200,
          // width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            // color: Colors.redAccent,
          ),
          // offset: const Offset(-20, 0),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all(6),
            thumbVisibility: MaterialStateProperty.all(true),
          ),
        ),
        items:
        modes.map((mode) {
          return DropdownMenuItem(
            value: mode,
            child: Row(
              children: [
                Expanded(child: Text(mode)),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red.shade300),
                  onPressed: () => _deletePaymentMode(mode),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedMode = value ?? (modes.isNotEmpty ? modes.first : null);
          });
        },
      ),
    );
  }

  DateTime selectedDate = DateTime.now(); // Default to today

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<bool?> _showConfirmationDialog(
      BuildContext context,
      String title,
      String content,
      ) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Cancel
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Confirm
              child: Text("Delete", style: TextStyle(color: Colors.red.shade300)),
            ),
          ],
        );
      },
    );
  }

  void _addPaymentMode() {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
        title: Text('Add Payment Mode'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            child: Text('Add'),
            onPressed: () {
              List<String> modes =
                  paymentBox
                      .get('modes', defaultValue: <String>[])
                      ?.cast<String>() ??
                      [];
              modes.add(controller.text);
              paymentBox.put('modes', modes);
              selectedMode = controller.text;
              setState(() {});
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _deletePaymentMode(String mode) async {
    bool? confirmDelete = await _showConfirmationDialog(
      context,
      "Delete Payment Mode?",
      "Are you sure you want to delete '$mode'? This will also delete all its expenses.",
    );
    if (confirmDelete == true) {
      setState(() {
        // Remove mode from list
        List<String> modes =
            paymentBox.get('modes', defaultValue: <String>[])?.cast<String>() ??
                [];
        modes.remove(mode);
        paymentBox.put('modes', modes);

        // Remove associated expenses
        expenseBox.delete(mode);

        // Update selectedMode safely
        if (modes.isNotEmpty) {
          selectedMode = modes.first; // Select first available mode
        } else {
          selectedMode = null; // No modes left
        }
      });
      Navigator.pop(dropdownKey.currentContext!);
    }
  }

  Widget _buildExpenseList() {
    List<Map<String, dynamic>> expenses =
    selectedMode != null
        ? (expenseBox.get(selectedMode) as List?)
        ?.map((e) => Map<String, dynamic>.from(e))
        .toList() ??
        []
        : [];

    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        var expense =  _getSortedExpenses()[index];
        return ListTile(
          title: Text('₹${expense['amount']} - ${expense['reason']}'),
          subtitle: Text(expense['date']),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red.shade300),
            onPressed: () => _deleteExpense(index),
          ),
        );
      },
    );
  }
  List<Map<String, dynamic>> _getSortedExpenses() {
    if (selectedMode == null) return [];

    List<Map<String, dynamic>> expenses = (expenseBox.get(selectedMode) as List?)?.map((e) => Map<String, dynamic>.from(e)).toList() ?? [];

    // Sort expenses by date (latest first)
    expenses.sort((a, b) => DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));

    return expenses;
  }

  Future<void> _deleteExpense(int index) async {
    List<Map> expenses =
        expenseBox.get(selectedMode, defaultValue: <Map>[])?.cast<Map>() ?? [];
    bool? confirmDelete = await _showConfirmationDialog(
      context,
      "Delete Expense?",
      "Are you sure you want to delete this\n${expenses[index]}?",
    );

    if (confirmDelete == true) {
      expenses.removeAt(index);
      expenseBox.put(selectedMode, expenses);
      setState(() {});
    }
  }

  Widget _buildAddExpenseButton() {
    return ElevatedButton(onPressed: _addExpense, child: Text('Add Expense'));
  }

  void _addExpense() {
    if (selectedMode == null) return;
    TextEditingController amountController = TextEditingController();
    TextEditingController reasonController = TextEditingController();
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
        title: Text('Add Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Amount'),
            ),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(labelText: 'Reason'),
            ),
            Row(
              children: [
                Text("Date: ${selectedDate.toLocal()}".split(' ')[0]),
                // Display selected date
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context), // Open date picker
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Add'),
            onPressed: () {
              List<Map> expenses =
                  expenseBox
                      .get(selectedMode, defaultValue: <Map>[])
                      ?.cast<Map>() ??
                      [];
              expenses.add({
                'date':
                selectedDate.toLocal().toString().split(' ')[0] ?? '',
                'amount':
                amountController.text.isNotEmpty
                    ? amountController.text
                    : '0',
                'reason':
                reasonController.text.isNotEmpty
                    ? reasonController.text
                    : 'Unknown',
              });

              // Ensure non-null storage
              expenseBox.put(selectedMode ?? 'default', expenses);

              setState(() {
                amountController.clear();
                reasonController.clear();
                selectedDate =
                    DateTime.now(); // Reset to today after adding
              });
              setState(() {});
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _exportToExcel() async {
    if (selectedMode == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("No payment mode selected!")));
      return;
    }

    List<Map<String, dynamic>> expenses =
        (expenseBox.get(selectedMode) as List?)
            ?.map((e) => Map<String, dynamic>.from(e))
            .toList() ??
            [];

    if (expenses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No expenses found for '$selectedMode'")),
      );
      return;
    }
    // Sort expenses by date (latest first)
    expenses.sort((a, b) => DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));


    var excel = flutter_excel.Excel.createExcel();
    flutter_excel.Sheet sheet = excel['Expenses'];

    // Add headers
    sheet.appendRow([
      flutter_excel.TextCellValue('Date'),
      flutter_excel.TextCellValue('Amount'),
      flutter_excel.TextCellValue('Reason'),
    ]);

    // Add expenses data
    for (var expense in expenses) {
      sheet.appendRow([
        flutter_excel.TextCellValue(expense['date'].toString()),
        flutter_excel.TextCellValue(expense['amount'].toString()),
        flutter_excel.TextCellValue(expense['reason'].toString()),
      ]);
    }

    String defaultSheet = excel.getDefaultSheet()!;
    excel.delete(defaultSheet);

    // Save the file
    var bytes = excel.encode();
    if (bytes == null) return;

    Directory directory = await getApplicationDocumentsDirectory();
    String filePath = "${directory.path}/expenses_${selectedMode}.xlsx";
    File file =
    File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(bytes);

    // Share the file
    Share.shareXFiles([
      XFile(filePath),
    ], text: "Here are the expenses for $selectedMode");
  }
}