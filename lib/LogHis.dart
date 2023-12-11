import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LogHistoryPage extends StatefulWidget {
  const LogHistoryPage({Key? key}) : super(key: key);

  @override
  State<LogHistoryPage> createState() => _LogHistoryPageState();
}

class _LogHistoryPageState extends State<LogHistoryPage> {
  final DatabaseReference _databaseReference =
  FirebaseDatabase.instance.reference().child('Device02/history');
  List<Map<dynamic, dynamic>> data = []; // Store

  @override
  void initState() {
    super.initState();
    // Set up a listener to fetch and update data whenever there's a change in the database
    _databaseReference.onValue.listen((event) {
      if (event.snapshot.value != null) {
        data.clear(); // Clear existing data
        Map<dynamic, dynamic> values =
        event.snapshot.value as Map<dynamic, dynamic>; // Cast the value
        values.forEach((key, value) {
          data.add(value);
        });
        setState(() {});
      }
    });
  }

  String _formatMilliseconds(int milliseconds) {
    // Convert milliseconds to a DateTime object
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    // Format the DateTime object to a human-readable string
    return DateFormat.jm().format(dateTime);
  }

  Future<void> _showDeleteConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete All Data", style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),),
          content: Text("Are you sure you want to delete all data?"),
          actions: [
            // TextButton(
            //   onPressed: () {
            //     Navigator.of(context).pop(); // Close the dialog
            //   },
            //   child: Text("No"),
            // ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Set the button color to green
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(10), // Set button corner radius
                ),
              ),
              onPressed: () {
                _deleteAllData();
                Navigator.of(context).pop();
              },
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Set the button color to green
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(10), // Set button corner radius
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'No',
                style: TextStyle(color: Colors.white),
              ),
            ),

            // TextButton(
            //   onPressed: () {
            //     _deleteAllData(); // Delete data and update UI
            //     Navigator.of(context).pop(); // Close the dialog
            //   },
            //   child: Text("Yes"),
            // ),
          ],
        );
      },
    );
  }

  void _deleteAllData() {
    _databaseReference.remove(); // Delete all data in 'Device02/history'
    data.clear(); // Clear local data list
    setState(() {}); // Trigger UI update
  }

  @override
  Widget build(BuildContext context) {
    // Sort the data list based on the 'time' value in descending order
    data.sort((a, b) => b['time'].compareTo(a['time']));

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'LOG HISTORY',
          style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
        backgroundColor: Color(0xff073d07),
        titleSpacing: 10,
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red,),
            onPressed: () {
              // Show the delete confirmation dialog
              _showDeleteConfirmationDialog();
            },
          ),
        ],
      ),
      body: data.isEmpty
          ? Center(
        child: Text(
          'No actions have been done.',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      )
          : SingleChildScrollView(
        child: Column(
          children: data.map((value) {
            return Center(
              child: Card(
                color: Colors.lightGreen.shade100, // Change the card color
                margin: EdgeInsets.all(8), // Adjust margin for spacing
                child: SizedBox(
                  width: 350, // Adjust card width
                  child: ListTile(
                    title: Text("Action: ${value['action']}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Date: ${value['date']}"),
                        // Convert milliseconds to human-readable format
                        Text(
                            "Time: ${_formatMilliseconds(value['time'])}"),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
