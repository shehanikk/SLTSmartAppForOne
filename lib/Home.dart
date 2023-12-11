import 'dart:async';
import 'dart:convert';
import 'package:finalsmartterraapp/LogHis.dart';
import 'package:finalsmartterraapp/login.dart';
import 'package:finalsmartterraapp/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
// import 'package:greengreenproj/models/sensor.dart';

class SelectedDeviceNotifier extends ChangeNotifier {
  String _deviceSelected = 'Device02';
  set changeDeviceSelected(String value) {
    _deviceSelected = value;
    notifyListeners();
  }

  String get deviceSelected => _deviceSelected;
}

class GreenHouseHome extends StatefulWidget {
  const GreenHouseHome({Key? key}) : super(key: key);

  @override
  State<GreenHouseHome> createState() => _GreenHouseHomeState();
}

class Reminder {
  final String key;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  Reminder({required this.key, required this.startTime, required this.endTime});
}

class _GreenHouseHomeState extends State<GreenHouseHome> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  final databaseReference = FirebaseDatabase.instance.ref();
  List<WateringTimeEntry> wateringTimeEntries = [];
  final databaseReferenceFer = FirebaseDatabase.instance.reference();
  List<FertilizingTimeEntry> fertilizingTimeEntries = [];
  SelectedDeviceNotifier _selectedDeviceNotifier = SelectedDeviceNotifier();

  // SensorData? sdata;

  String wateringStartTime = ''; // Variable to store the fetched start time
  String wateringEndTime = ''; // Variable to store the fetched end time
  String selectedValue = 'Smart terrarium 1';
  bool isTemperatureControlOn = false; // Initial state of the toggle button
  bool isLightControlOn = false; // Initial selected value for the dropdown
  bool isManualButtonEnabled = true;
  String selectedValueTwo = 'Pump_01';
  List<Reminder> reminders = [];

  //yash sensor data

  String humidity = "";
  String lightIntensity = "";
  String moisture = "";
  String temperature = "";

  String humidity_thresholds = "";
  String lightIntensity_thresholds = "";
  String moisture_thresholds = "";
  String temperature_thresholds = "";

  // shehani thresholds

  //yash buttons
  int isFanOn = 0;
  int isLightOn = 0;
  int isPumpOn = 0;
  int isSprinklerOn = 0;

  //yash onetogglebtn
  int isFanOneBtnOn = 0;
  int isLightOneBtnOn = 0;
  int isPumpOneBtnOn = 0;
  int isSprinklerOneBtnOn = 0;

  void listenToDeviceActuatorsManuals(String deviceName) {
    _database
        .reference()
        .child(deviceName)
        .child("mode")  // Update this to listen to "mode/manual" specifically
        .child("manual")
        .onValue
        .listen((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;

      // Update the local state based on the value in the database
      setState(() {
        isTemperatureControlOn = snapshot.value == 1;
      });
    });
  }

  void listenToDeviceActuatorsManualsAuto(String deviceName) {
    _database
        .reference()
        .child(deviceName)
        .child("mode")  // Update this to listen to "mode/manual" specifically
        .child("auto1")
        .onValue
        .listen((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;

      // Update the local state based on the value in the database
      setState(() {
        isTemperatureControlOn = snapshot.value == 1;
      });
    });
  }

  void listenToDeviceActuatorsManual(String deviceName) {
    _database
        .reference()
        .child(deviceName)
        .child("actuators-manual")
        .onValue
        .listen((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;

      Map<String, dynamic> data = jsonDecode(jsonEncode(snapshot?.value));
      setState(() {
        isFanOn = data['fan'];
        isLightOn = data['light'];
        isPumpOn = data['pump'];
        isSprinklerOn = data['sprinkler'];
      });
    });
  }

  void listenToDeviceSensors(String deviceName) {
    _database
        .reference()
        .child(deviceName)
        .child("sensors")
        .onValue
        .listen((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;

      Map<String, dynamic> data = jsonDecode(jsonEncode(snapshot.value));
      setState(() {
        humidity = data['humidity'];
        lightIntensity = data['light_intensity'];
        moisture = data['moisture'];
        temperature = data['temperature'];
      });
    });
  }

  void listenToDeviceThresholds(String deviceName) {
    _database
        .reference()
        .child(deviceName)
        .child("thresholds")
        .onValue
        .listen((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      Map<String, dynamic> data = jsonDecode(jsonEncode(snapshot.value));
      _selectedDeviceNotifier.changeDeviceSelected =
          deviceName; // Update the selected device
      setState(() {
        humidity_thresholds = data['humidity_thresholds'];
        lightIntensity_thresholds = data['lightIntensity_thresholds'];
        moisture_thresholds = data['moisture_thresholds'];
        temperature_thresholds = data['temperature_thresholds'];
      });
    });
  }

  void loadWateringTimeEntries() {
    // Clear the existing entries before loading new ones
    wateringTimeEntries.clear();

    DatabaseReference wateringTimeRef = databaseReference.child(
        '${_selectedDeviceNotifier.deviceSelected}/control/watering_time');

    wateringTimeRef.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      Map? value = dataSnapshot.value as Map<dynamic, dynamic>?;
      if (value != null) {
        setState(() {
          // Clear the existing entries before loading new ones
          wateringTimeEntries.clear();
          value.forEach((key, entryData) {
            wateringTimeEntries.add(WateringTimeEntry(
              key: key,
              startTime: entryData['start_time'] as String? ?? '',
              endTime: entryData['end_time'] as String? ?? '',
            ));
          });
        });
      }
    });
  }

  void loadFertilizingTimeEntries() {
    // Clear the existing entries before loading new ones
    fertilizingTimeEntries.clear();

    DatabaseReference fertilizingTimeRef = databaseReferenceFer.child(
        '${_selectedDeviceNotifier.deviceSelected}/control/fertilizing_time');

    fertilizingTimeRef.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      Map? value = dataSnapshot.value as Map<dynamic, dynamic>?;
      if (value != null) {
        setState(() {
          // Clear the existing entries before loading new ones
          fertilizingTimeEntries.clear();
          value.forEach((key, entryData) {
            fertilizingTimeEntries.add(FertilizingTimeEntry(
              key: key,
              startTime: entryData['start_time'] as String? ?? '',
              endTime: entryData['end_time'] as String? ?? '',
            ));
          });
        });
      }
    });
  }

  Future<void> _showEditPopup(
      String title, String valueKey, String initialValue) async {
    TextEditingController controller =
    TextEditingController(text: initialValue);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(controller: controller),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Set the button color to green
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(10), // Set button corner radius
                ),
              ),
              onPressed: () {
                // Save the edited value to the database
                _database
                    .reference()
                    .child(_selectedDeviceNotifier.deviceSelected)
                    .child("thresholds")
                    .update({valueKey: controller.text});
                Navigator.of(context).pop();
              },
              child: Text(
                'Save',
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
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // listenToDeviceActuatorsManual("Device02");
    // listenToDeviceSensors("Device02");
    // listenToDeviceThresholds("Device02");

    String selectedDevice = _selectedDeviceNotifier.deviceSelected;
    listenToDeviceActuatorsManuals(selectedDevice);
    listenToDeviceActuatorsManual(selectedDevice);
    listenToDeviceSensors(selectedDevice);
    listenToDeviceThresholds(selectedDevice);

    // Listen to changes in the "manual" mode in the database for the selected device
    _database
        .reference()
        .child(selectedDevice)
        .child("mode")
        .child("manual")
        .onValue
        .listen((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;

      // Update the local state based on the value in the database
      setState(() {
        isTemperatureControlOn = snapshot.value == 1;
      });
    });

    _database
        .reference()
        .child(selectedDevice)
        .child("mode")
        .child("auto1")
        .onValue
        .listen((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;

      // Update the local state based on the value in the database
      setState(() {
        isTemperatureControlOn = snapshot.value == 1;
      });
    });

    // Getsensordata();
    //yash
    // _database
    //     .reference()
    //     .child(_selectedDeviceNotifier.deviceSelected)
    //     .child("actuators-manual")
    //     .onValue
    //     .listen((DatabaseEvent event) {
    //   DataSnapshot snapshot = event.snapshot;

    //   Map<String, dynamic> data = jsonDecode(jsonEncode(snapshot?.value));
    //   setState(() {
    //     isFanOn = data['fan'];
    //     isLightOn = data['light'];
    //     isPumpOn = data['pump'];
    //     isSprinklerOn = data['sprinkler'];
    //   });
    // });

    // // sensors reading update part
    // _database
    //     .reference()
    //     .child(_selectedDeviceNotifier.deviceSelected)
    //     .child("sensors")
    //     .onValue
    //     .listen((DatabaseEvent event) {
    //   DataSnapshot snapshot = event.snapshot;

    //   Map<String, dynamic> data = jsonDecode(jsonEncode(snapshot.value));
    //   setState(() {
    //     humidity = data['humidity'];
    //     lightIntensity = data['light_intensity'];
    //     moisture = data['moisture'];
    //     temperature = data['temperature'];

    //   });
    // });

    //trytry

    //shehani

    // DatabaseReference wateringTimeRef = databaseReference.child(
    //     '${_selectedDeviceNotifier.deviceSelected}/control/watering_time');
    // DatabaseReference fertilizingTimeRef = databaseReferenceFer.child(
    //     '${_selectedDeviceNotifier.deviceSelected}/control/fertilizing_time');

    // wateringTimeRef.onChildAdded.listen((event) {
    //   DataSnapshot dataSnapshot = event.snapshot;
    //   Map? value = dataSnapshot.value as Map<dynamic, dynamic>?;
    //   if (value != null) {
    //     setState(() {
    //       // Adding water times
    //       wateringTimeEntries.add(WateringTimeEntry(
    //         key: dataSnapshot.key!,
    //         startTime: value['start_time'] as String? ?? '',
    //         endTime: value['end_time'] as String? ?? '',
    //       ));
    //     });
    //   }
    // });

    // fertilizingTimeRef.onChildAdded.listen((event) {
    //   DataSnapshot dataSnapshot = event.snapshot;
    //   Map? value = dataSnapshot.value as Map<dynamic, dynamic>?;
    //   if (value != null) {
    //     setState(() {
    //       // Adding water times
    //       fertilizingTimeEntries.add(FertilizingTimeEntry(
    //         key: dataSnapshot.key!,
    //         startTime: value['start_time'] as String? ?? '',
    //         endTime: value['end_time'] as String? ?? '',
    //       ));
    //     });
    //   }
    // });

    _selectedDeviceNotifier.addListener(() {
      // Clear the existing entries before loading new ones
      wateringTimeEntries.clear();
      loadWateringTimeEntries();
      fertilizingTimeEntries.clear();
      loadFertilizingTimeEntries();
    });
  }

  void  _showAddReminderBottomSheet(BuildContext context) async {
    TimeOfDay? startTime;
    TimeOfDay? endTime;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    startTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData(
                            primarySwatch: Colors.green,
                            hintColor: Colors.green,
                            buttonTheme: ButtonThemeData(
                              textTheme: ButtonTextTheme.primary,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (startTime != null) {
                      setState(() {});
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(150, 50),
                  ),
                  child: Text(
                    "Start Time",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    endTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData(
                            primarySwatch: Colors.green,
                            hintColor: Colors.green,
                            buttonTheme: ButtonThemeData(
                              textTheme: ButtonTextTheme.primary,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (endTime != null) {
                      setState(() {});
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(150, 50),
                  ),
                  child: Text(
                    "End Time",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (startTime != null && endTime != null) {
                      String deviceKey = _selectedDeviceNotifier.deviceSelected;
                      String wateringTimeKey = _database
                          .reference()
                          .child('$deviceKey/control/watering_time')
                          .push()
                          .key ??
                          '';

                      setState(() {
                        reminders.add(
                          Reminder(
                            key: wateringTimeKey,
                            startTime: startTime!,
                            endTime: endTime!,
                          ),
                        );
                      });

                      _database
                          .reference()
                          .child('$deviceKey/control/watering_time')
                          .child(wateringTimeKey)
                          .set({
                        'start_time':
                        '${startTime!.hour > 12 ? startTime!.hour - 12 : startTime!.hour}:${startTime!.minute} ${startTime!.hour >= 12 ? 'PM' : 'AM'}',
                        'end_time':
                        '${endTime!.hour > 12 ? endTime!.hour - 12 : endTime!.hour}:${endTime!.minute} ${endTime!.hour >= 12 ? 'PM' : 'AM'}',
                      });

                      Navigator.of(context).pop(); // Close the dialog
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(150, 50),
                  ),
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddReminderBottomSheetFerti(BuildContext context) async {
    TimeOfDay? startTime;
    TimeOfDay? endTime;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    startTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData(
                            primarySwatch: Colors.green,
                            hintColor: Colors.green,
                            buttonTheme: ButtonThemeData(
                              textTheme: ButtonTextTheme.primary,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (startTime != null) {
                      setState(() {});
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(150, 50),
                  ),
                  child: Text(
                    "Start Time",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    endTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData(
                            primarySwatch: Colors.green,
                            hintColor: Colors.green,
                            buttonTheme: ButtonThemeData(
                              textTheme: ButtonTextTheme.primary,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (endTime != null) {
                      setState(() {
                        // Handle the selected end time.
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(150, 50),
                  ),
                  child: Text(
                    "End Time",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (startTime != null && endTime != null) {
                      String deviceKey = _selectedDeviceNotifier.deviceSelected;
                      String fertiTimeKey = _database
                          .reference()
                          .child('$deviceKey/control/fertilizing_time')
                          .push()
                          .key ??
                          '';

                      setState(() {
                        reminders.add(
                          Reminder(
                            key: fertiTimeKey,
                            startTime: startTime!,
                            endTime: endTime!,
                          ),
                        );
                      });
                      _database
                          .reference()
                          .child('$deviceKey/control/fertilizing_time')
                          .child(fertiTimeKey)
                          .set({
                        'start_time':
                        '${startTime!.hour > 12 ? startTime!.hour - 12 : startTime!.hour}:${startTime!.minute} ${startTime!.hour >= 12 ? 'PM' : 'AM'}',
                        'end_time':
                        '${endTime!.hour > 12 ? endTime!.hour - 12 : endTime!.hour}:${endTime!.minute} ${endTime!.hour >= 12 ? 'PM' : 'AM'}',
                      });

                      Navigator.of(context).pop(); // Close the dialog
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(150, 50),
                  ),
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  void _deleteWateringTimeEntry(String entryKey) {
    DatabaseReference wateringTimeRef = databaseReference.child(
        '${_selectedDeviceNotifier.deviceSelected}/control/watering_time');
    wateringTimeRef.child(entryKey).remove().then((_) {
      setState(() {
        wateringTimeEntries.removeWhere((entry) => entry.key == entryKey);
      });
    }).catchError((error) {
      print("Failed to delete entry: $error");
    });
  }

  //shehani editting watering time
  void _showEditWateringTimeDialog(
      BuildContext context, WateringTimeEntry entry) {
    String updatedStartTime = entry.startTime;
    String updatedEndTime = entry.endTime;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Edit Watering Time',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Start Time'),
                onChanged: (value) {
                  updatedStartTime = value;
                },
                controller: TextEditingController(text: entry.startTime),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'End Time'),
                onChanged: (value) {
                  updatedEndTime = value;
                },
                controller: TextEditingController(text: entry.endTime),
              ),
            ],
          ),
          actions: <Widget>[

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                _updateWateringTimeEntry(
                    entry.key, updatedStartTime, updatedEndTime);
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateWateringTimeEntry(
      String entryKey, String updatedStartTime, String updatedEndTime) {
    DatabaseReference wateringTimeRef = databaseReference.child(
        '${_selectedDeviceNotifier.deviceSelected}/control/watering_time');
    wateringTimeRef.child(entryKey).update({
      'start_time': updatedStartTime,
      'end_time': updatedEndTime,
    }).then((_) {
      setState(() {
        int indexToUpdate =
        wateringTimeEntries.indexWhere((entry) => entry.key == entryKey);
        if (indexToUpdate != -1) {
          wateringTimeEntries[indexToUpdate].startTime = updatedStartTime;
          wateringTimeEntries[indexToUpdate].endTime = updatedEndTime;
        }
      });
    }).catchError((error) {
      print("Failed to update entry: $error");
    });
  }

  //shehani fertilizing Time delete
  void _deleteFertilizingTimeEntry(String entryKey) {
    DatabaseReference fertilizingTimeRef = databaseReferenceFer.child(
        '${_selectedDeviceNotifier.deviceSelected}/control/fertilizing_time');
    fertilizingTimeRef.child(entryKey).remove().then((_) {
      setState(() {
        fertilizingTimeEntries.removeWhere((entry) => entry.key == entryKey);
      });
    }).catchError((error) {
      print("Failed to delete entry: $error");
    });
  }

  //shehani fertilizing watering time
  void _showEditFertilizingTimeDialog(
      BuildContext context, FertilizingTimeEntry entry) {
    String updatedStartTime = entry.startTime;
    String updatedEndTime = entry.endTime;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, // Set the background color to white
          title: Text(
            'New Fertilizing Time',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Start Time'),
                onChanged: (value) {
                  updatedStartTime = value;
                },
                controller: TextEditingController(text: entry.startTime),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'End Time'),
                onChanged: (value) {
                  updatedEndTime = value;
                },
                controller: TextEditingController(text: entry.endTime),
              ),
            ],
          ),
          actions: <Widget>[

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green
                    .shade400, // Set the button's background color to green
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(10), // Set the border radius to 10
                ),
              ),
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                // Update the entry in Firebase and locally
                _updateFertilizingTimeEntry(
                    entry.key, updatedStartTime, updatedEndTime);
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green
                    .shade400, // Set the button's background color to green
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(10), // Set the border radius to 10
                ),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateFertilizingTimeEntry(
      String entryKey, String updatedStartTime, String updatedEndTime) {
    DatabaseReference fertilizingTimeRef = databaseReferenceFer.child(
        '${_selectedDeviceNotifier.deviceSelected}/control/fertilizing_time');
    fertilizingTimeRef.child(entryKey).update({
      'start_time': updatedStartTime,
      'end_time': updatedEndTime,
    }).then((_) {
      setState(() {
        int indexToUpdate =
        fertilizingTimeEntries.indexWhere((entry) => entry.key == entryKey);
        if (indexToUpdate != -1) {
          fertilizingTimeEntries[indexToUpdate].startTime = updatedStartTime;
          fertilizingTimeEntries[indexToUpdate].endTime = updatedEndTime;
        }
      });
    }).catchError((error) {
      print("Failed to update entry: $error");
    });
  }

  void showThresholdInputDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String thresholdValue = ""; // Store the user's input here

        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: TextFormField(
            onChanged: (value) {
              thresholdValue = value;
            },
            decoration: InputDecoration(
              labelText: "Enter Threshold Value",
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green
                    .shade400, // Set the button's background color to green
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(10), // Set the border radius to 10
                ),
              ),
              onPressed: () {
                print("Threshold value saved: $thresholdValue");

                Navigator.of(context).pop();
              },
              child: Text(
                "Save",
                style: TextStyle(
                  color: Colors.white,
                  // borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green
                    .shade400, // Set the button's background color to green
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(10), // Set the border radius to 10
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
          backgroundColor: Colors.white, // Set the background color to white
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final greenColor = Colors.white70;
    final greenColortwo = Colors.green.shade300;
    final dropColor = Colors.green.shade200;

    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Color(0xff073d07),
        automaticallyImplyLeading: false,

        title: Text(

          'ECOGARDEN',
          style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          // Adjust the font size as needed
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.history,color: Colors.green,),
            onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LogHistoryPage()),
                );
            },
          ),
          SizedBox(width: 2), // Add some spacing between icons
          IconButton(
            icon: Icon(Icons.person, color: Colors.green,),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                print("Signed Out");
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SignInScreen()));
              });
            },
          ),

          SizedBox(width: 8),
        ],
        toolbarHeight: 50, // Set the desired height for the AppBar
      ),
      body: SingleChildScrollView(
        child: Container(
          //width: 1000,
          height: 1230,
          child: Stack(
            children: [

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Opacity(
                  opacity: 0.9,
                  child: Container(
                    width: double.infinity,
                    height: 160,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/home13.jpg"),
                        fit: BoxFit.fill,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 60,
                left: 20,
                right: 20,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 300, // Adjust the width as needed
                      margin: EdgeInsets.only(top: 16),
                      padding: EdgeInsets.all(12), // Add padding to the container
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white.withOpacity(0.8),
                        // Change to white background
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Smart terrarium 1', // Replace with your desired text
                            style: TextStyle(
                              color: Colors.green.shade800,
                              fontSize: 17, // Adjust the font size as needed
                              fontWeight: FontWeight.bold, // Adjust the font weight as needed
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),



              //full code with smart terrerium 1 to 3 DO NOT DELETE THE BELOW CODE

              // Positioned(
              //   top: 60,
              //   left: 20,
              //   right: 20,
              //   child: Container(
              //     width: MediaQuery.of(context).size.width,
              //     child: Align(
              //       alignment: Alignment.topCenter,
              //       child: Container(
              //         width: 200,
              //         margin: EdgeInsets.only(top: 16),
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(30),
              //           color: greenColor,
              //         ),
              //         child: Center(
              //           child: Padding(
              //             padding: const EdgeInsets.symmetric(horizontal: 16),
              //             child: DropdownButton<String>(
              //               value: selectedValue,
              //               onChanged: (newValue) {
              //                 if (newValue == 'Smart terrarium 1') {
              //                   setState(() {
              //                     _selectedDeviceNotifier.changeDeviceSelected =
              //                     "Device02";
              //                   });
              //                   listenToDeviceActuatorsManual(
              //                       _selectedDeviceNotifier.deviceSelected);
              //                   listenToDeviceActuatorsManuals(
              //                       _selectedDeviceNotifier.deviceSelected);
              //                   listenToDeviceActuatorsManualsAuto(
              //                       _selectedDeviceNotifier.deviceSelected);
              //                   listenToDeviceSensors(
              //                       _selectedDeviceNotifier.deviceSelected);
              //                   listenToDeviceThresholds(
              //                       _selectedDeviceNotifier.deviceSelected);
              //                   loadWateringTimeEntries();
              //                   loadFertilizingTimeEntries();
              //                 }
              //
              //                 if (newValue == 'Smart terrarium 2') {
              //                   setState(() {
              //                     _selectedDeviceNotifier.changeDeviceSelected =
              //                     "Device03";
              //                   });
              //                   listenToDeviceActuatorsManual(
              //                       _selectedDeviceNotifier.deviceSelected);
              //                   listenToDeviceActuatorsManuals(
              //                       _selectedDeviceNotifier.deviceSelected);
              //                   listenToDeviceActuatorsManualsAuto(
              //                       _selectedDeviceNotifier.deviceSelected);
              //                   listenToDeviceSensors(
              //                       _selectedDeviceNotifier.deviceSelected);
              //                   listenToDeviceThresholds(
              //                       _selectedDeviceNotifier.deviceSelected);
              //                   loadWateringTimeEntries();
              //                   loadFertilizingTimeEntries();
              //                 }
              //                 if (newValue == 'Smart terrarium 3') {
              //                   setState(() {
              //                     _selectedDeviceNotifier.changeDeviceSelected =
              //                     "Device04";
              //                   });
              //                   listenToDeviceActuatorsManual(
              //                       _selectedDeviceNotifier.deviceSelected);
              //                   listenToDeviceActuatorsManuals(
              //                       _selectedDeviceNotifier.deviceSelected);
              //                   listenToDeviceActuatorsManualsAuto(
              //                       _selectedDeviceNotifier.deviceSelected);
              //                   listenToDeviceSensors(
              //                       _selectedDeviceNotifier.deviceSelected);
              //                   listenToDeviceThresholds(
              //                       _selectedDeviceNotifier.deviceSelected);
              //                   loadWateringTimeEntries();
              //                   loadFertilizingTimeEntries();
              //                 }
              //
              //                 setState(() {
              //                   selectedValue = newValue!;
              //                 });
              //               },
              //               underline: SizedBox(),
              //               dropdownColor: Colors.white,
              //               items: <String>[
              //                 'Smart terrarium 1',
              //                 'Smart terrarium 2',
              //                 'Smart terrarium 3',
              //               ].map((String value) {
              //                 return DropdownMenuItem<String>(
              //                   value: value,
              //                   child: Center(
              //                     child: Text(
              //                       value,
              //                       style: TextStyle(
              //                         color: Colors.green.shade800,
              //                       ),
              //                     ),
              //                   ),
              //                 );
              //               }).toList(),
              //               icon: Icon(
              //                 Icons.arrow_drop_down,
              //                 color: Colors.black87,
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),



              Positioned(
                top: 200,
                left: 20,
                right: 20,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 15,
                    color: Color(0xff073d07),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              'Sensor Readings',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildColumn(Icons.water_drop, '$humidity',
                                    Colors.blue.shade800),
                                buildColumn(
                                    Icons.thermostat,
                                    ' $lightIntensity',
                                    Color.fromARGB(255, 235, 57, 44)),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildColumn(Icons.water, '$moisture',
                                    Color.fromARGB(255, 119, 121, 118)),
                                buildColumn(Icons.light_mode, '$temperature',
                                    Color.fromARGB(255, 236, 210, 9)),
                              ],
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 350,
                left: 20,
                right: 20,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 15,
                    color: Color(0xff187a0d),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              'Thresholds',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _showEditPopup(
                                        'Humidity',
                                        'humidity_thresholds',
                                        humidity_thresholds);
                                  },
                                  child: buildColumn(
                                      Icons.water_drop_outlined,
                                      '$humidity_thresholds',
                                      Colors.blue.shade800),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _showEditPopup(
                                        'Light Intensity',
                                        'lightIntensity_thresholds',
                                        lightIntensity_thresholds);
                                  },
                                  child: buildColumn(
                                      Icons.lightbulb_outline_rounded,
                                      ' $lightIntensity_thresholds',
                                      Colors.orange),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _showEditPopup(
                                        'Moisture',
                                        'moisture_thresholds',
                                        moisture_thresholds);
                                  },
                                  child: buildColumn(Icons.water,
                                      '$moisture_thresholds', Colors.blue),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _showEditPopup(
                                        'Temperature',
                                        'temperature_thresholds',
                                        temperature_thresholds);
                                  },
                                  child: buildColumn(
                                      Icons.device_thermostat_outlined,
                                      '$temperature_thresholds',
                                      Colors.red),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Positioned(
              //   top: 350,
              //   left: 20,
              //   right: 20,
              //   child: Container(
              //     width: MediaQuery.of(context).size.width,
              //     child: Card(
              //       elevation: 15,
              //       color: Color(0xff187a0d),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       child: Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Center(
              //           child: Column(
              //             children: [
              //               Text(
              //                 'Thresholds Readings',
              //                 style: TextStyle(
              //                   fontSize: 16,
              //                   fontWeight: FontWeight.bold,
              //                   color: Colors.white,
              //                 ),
              //               ),
              //               SizedBox(
              //                 height: 10,
              //               ),
              //               Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                 children: [
              //                   ThresholdsWidget(
              //                     iconData: Icons.water_drop_outlined,
              //                     sensorName: "hum",
              //                     //nitialValue: "20%",
              //                     iconColor: Colors.blue.shade800,
              //                   ),
              //                   ThresholdsWidget(
              //                     iconData: Icons.lightbulb_outline_rounded,
              //                     sensorName: "li",
              //                     //nitialValue: "5000%",
              //                     iconColor: Colors.orange,
              //                   ),
              //                 ],
              //               ),
              //               SizedBox(height: 10),
              //               Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                 children: [
              //                   ThresholdsWidget(
              //                     iconData: Icons.water,
              //                     sensorName: "mo",
              //                     //itialValue: "100%",
              //                     iconColor: Colors.blue,
              //                   ),
              //                   ThresholdsWidget(
              //                     iconData: Icons.device_thermostat_outlined,
              //                     sensorName: "tem",
              //                     //nitialValue: "27°C",
              //                     iconColor: Colors.red,
              //                   ),
              //                 ],
              //               ),
              //               SizedBox(height: 5),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

              Positioned(
                top: 510, // Adjust the top position as needed
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Actuators Manual',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Set the text color to black
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'OFF',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isTemperatureControlOn
                                  ? Colors.black
                                  : Colors.black45,
                            ),
                          ),
                          Switch(
                            value: isTemperatureControlOn,
                            onChanged: isManualButtonEnabled
                                ? (value) {
                              setState(() {
                                isTemperatureControlOn = value;

                                //yash toggles try

                                isFanOneBtnOn = 0;
                                // isFanOneBtnOn == 0 ? 1 : 0;
                                isLightOneBtnOn = 0;
                                // isLightOneBtnOn == 0 ? 1 : 0;
                                isPumpOneBtnOn = 0;
                                // isPumpOneBtnOn == 0 ? 1 : 0;
                                isSprinklerOneBtnOn = 0;
                                // isSprinklerOneBtnOn == 0 ? 1 : 0;

                                //blaaa
                                _database
                                    .reference()
                                    .child(_selectedDeviceNotifier
                                    .deviceSelected)
                                    .child("actuators-manual")
                                    .update({"fan": isFanOneBtnOn});

                                _database
                                    .reference()
                                    .child(_selectedDeviceNotifier
                                    .deviceSelected)
                                    .child("actuators-manual")
                                    .update({"light": isLightOneBtnOn});

                                //togel button to data base
                                _database
                                    .reference()
                                    .child(_selectedDeviceNotifier
                                    .deviceSelected)
                                    .child("mode")
                                    .update({
                                  "manual": isTemperatureControlOn ? 1 : 0
                                });


                                _database
                                    .reference()
                                    .child(_selectedDeviceNotifier
                                    .deviceSelected)
                                    .child("actuators-manual")
                                    .update({"pump": isPumpOneBtnOn});

                                _database
                                    .reference()
                                    .child(_selectedDeviceNotifier
                                    .deviceSelected)
                                    .child("actuators-manual")
                                    .update({
                                  "sprinkler": isSprinklerOneBtnOn
                                });

                                String logAction = isTemperatureControlOn ? "Manual Mode On" : "Manual Mode Off";
                                int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;

                                _database
                                    .reference()
                                    .child(_selectedDeviceNotifier.deviceSelected)
                                    .child("history")
                                    .push()
                                    .set({
                                  "action": logAction,
                                  "time": currentTimeMillis,
                                  "date": DateFormat('dd MMMM yyyy').format(DateTime.now()),
                                });
                              });
                            }

                                : null,
                            activeColor: greenColortwo,
                            inactiveThumbColor: Colors.black45,
                            inactiveTrackColor:
                            Colors.white54, // Set the active color to green
                          ),
                          Text(
                            'ON',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isTemperatureControlOn
                                  ? Colors.green
                                  : Colors
                                  .black45, // Set the text color to green when ON, grey when OFF
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 560, // Adjust the top position as needed
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // ElevatedButton(
                      //   //yash
                      //   onPressed: isTemperatureControlOn
                      //       ? () {
                      //           // yash
                      //           setState(() {
                      //             if (isFanOn == 0) {
                      //               isFanOn = 1;
                      //               print(isFanOn);
                      //             } else if (isFanOn == 1) {
                      //               isFanOn = 0;
                      //               print(isFanOn);
                      //             }
                      //           });
                      //         }
                      //       : null,//yash
                      //   style: ElevatedButton.styleFrom(
                      //     primary: isFanOn == 0
                      //         ? Colors.green
                      //         : Color.fromARGB(255, 5, 61, 2), // Set the button background color to green
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(
                      //           10), // Set the border radius to 10
                      //     ), // Set the button background color to green
                      //   ),
                      //   child: Text(
                      //     'Fan',
                      //     style: TextStyle(
                      //         color: isTemperatureControlOn
                      //             ? Colors.white
                      //             : Colors.black), //yash
                      //   ),
                      // ),

                      //yash
                      ElevatedButton(
                        onPressed: isTemperatureControlOn
                            ? isManualButtonEnabled
                            ? () {
                          setState(() {
                            // Toggle the fan state
                            isFanOn = isFanOn == 0 ? 1 : 0;

                            String logAction = isFanOn == 1 ? "Fan On" : "Fan Off"; // Store time in milliseconds
                            int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;

                            _database
                                .reference()
                                .child(_selectedDeviceNotifier.deviceSelected)
                                .child("history")
                                .push()
                                .set({
                              "action": logAction,
                              "time": currentTimeMillis,
                              "date": DateFormat('dd MMMM yyyy').format(DateTime.now()),
                            });

                            // Update the Firebase value
                            _database
                                .reference()
                                .child(_selectedDeviceNotifier
                                .deviceSelected)
                                .child("actuators-manual")
                                .update({"fan": isFanOn});
                          });
                        }
                            : null
                            : null, //yash
                        style: ElevatedButton.styleFrom(
                          primary: isFanOn == 0
                              ? Colors.green.shade200
                              : Color(0xff126b23),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Fan',
                          style: TextStyle(
                            color: isTemperatureControlOn
                                ? isFanOn == 0
                                ? const Color.fromARGB(255, 0, 0, 0)
                                : const Color.fromARGB(255, 255, 255, 255)
                                : null,
                          ),
                        ),
                      ),

                      // ElevatedButton(
                      //   onPressed: isTemperatureControlOn
                      //       ? () {
                      //           // yash
                      //           setState(() {
                      //             if (isLightOn == 0) {
                      //               isLightOn = 1;
                      //               print(isLightOn);
                      //             } else if (isLightOn == 1) {
                      //               isLightOn = 0;
                      //               print(isLightOn);
                      //             }
                      //           });
                      //         }
                      //       : null, //yash
                      //   style: ElevatedButton.styleFrom(
                      //     primary: isLightOn == 0
                      //         ? Colors.green
                      //         : Color.fromARGB(255, 5, 61,
                      //             2), // Set the button background color to green
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(
                      //           10), // Set the border radius to 10
                      //     ), // Set the button background color to green
                      //   ),
                      //   child: Text(
                      //     'Light',
                      //     style: TextStyle(
                      //         color: isTemperatureControlOn
                      //             ? Colors.white
                      //             : Colors.black), //yash
                      //   ),
                      // ),

                      ElevatedButton(
                        onPressed: isTemperatureControlOn
                            ? isManualButtonEnabled
                            ? () {
                          setState(() {
                            // Toggle the fan state
                            isLightOn = isLightOn == 0 ? 1 : 0;

                            String logAction = isLightOn == 1 ? "Light On" : "Light Off"; // Store time in milliseconds
                            int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;

                            _database
                                .reference()
                                .child(_selectedDeviceNotifier.deviceSelected)
                                .child("history")
                                .push()
                                .set({
                              "action": logAction,
                              "time": currentTimeMillis,
                              "date": DateFormat('dd MMMM yyyy').format(DateTime.now()),
                            });

                            // Update the Firebase value
                            _database
                                .reference()
                                .child(_selectedDeviceNotifier
                                .deviceSelected)
                                .child("actuators-manual")
                                .update({"light": isLightOn});
                          });
                        }
                            : null
                            : null, //yash
                        style: ElevatedButton.styleFrom(
                          primary: isLightOn == 0
                              ? Colors.green.shade200
                              : Color(0xff126b23),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Light',
                          style: TextStyle(
                            color: isTemperatureControlOn
                                ? isLightOn == 0
                                ? Colors.black
                                : Colors.white
                                : null,
                          ),
                        ),
                      ),
                      // ElevatedButton(
                      //   onPressed: isTemperatureControlOn
                      //       ? () {
                      //           // yash
                      //           setState(() {
                      //             if (isPumpOn == 0) {
                      //               isPumpOn = 1;
                      //               print(isPumpOn);
                      //             } else if (isPumpOn == 1) {
                      //               isPumpOn = 0;
                      //               print(isPumpOn);
                      //             }
                      //           });
                      //         }
                      //       : null, //yash
                      //   style: ElevatedButton.styleFrom(
                      //     primary: isPumpOn == 0
                      //         ? Colors.green
                      //         : Color.fromARGB(255, 5, 61,
                      //             2), // Set the button background color to green
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(
                      //           10), // Set the border radius to 10
                      //     ), // Set the button background color to green
                      //   ),
                      //   child: Text(
                      //     'Pump',
                      //     style: TextStyle(
                      //         color: isTemperatureControlOn
                      //             ? Colors.white
                      //             : Colors
                      //                 .black), // Set the text color to white
                      //   ),
                      // ),

                      ElevatedButton(
                        onPressed: isTemperatureControlOn
                            ? isManualButtonEnabled
                            ? () {
                          setState(() {
                            // Toggle the fan state
                            isPumpOn = isPumpOn == 0 ? 1 : 0;

                            String logAction = isPumpOn == 1 ? "Pump On" : "Pump Off";

                            int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;

                            _database
                                .reference()
                                .child(_selectedDeviceNotifier.deviceSelected)
                                .child("history")
                                .push()
                                .set({
                              "action": logAction,
                              "time": currentTimeMillis,
                              "date": DateFormat('dd MMMM yyyy').format(DateTime.now()),
                            });


                            // Update the Firebase value
                            _database
                                .reference()
                                .child(_selectedDeviceNotifier
                                .deviceSelected)
                                .child("actuators-manual")
                                .update({"pump": isPumpOn});
                          });
                        }
                            : null
                            : null, //yash
                        style: ElevatedButton.styleFrom(
                          primary: isPumpOn == 0
                              ? Colors.green.shade200
                              : Color(0xff126b23),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Pump',
                          style: TextStyle(
                            color: isTemperatureControlOn
                                ? isPumpOn == 0
                                ? Colors.black
                                : Colors.white
                                : null,
                          ),
                        ),
                      ),
                      // ElevatedButton(
                      //   onPressed: isTemperatureControlOn
                      //       ? () {
                      //           // yash
                      //           setState(() {
                      //             if (isSprinklerOn == 0) {
                      //               isSprinklerOn = 1;
                      //               print(isSprinklerOn);
                      //             } else if (isSprinklerOn == 1) {
                      //               isSprinklerOn = 0;
                      //               print(isSprinklerOn);
                      //             }
                      //           });
                      //         }
                      //       : null, //yash
                      //   style: ElevatedButton.styleFrom(
                      //     primary: isSprinklerOn == 0
                      //         ? Colors.green
                      //         : Color.fromARGB(255, 5, 61,
                      //             2), // Set the button background color to green
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(
                      //           10), // Set the border radius to 10
                      //     ), // Set the button background color to green
                      //   ),
                      //   child: Text(
                      //     'Sprinkler',
                      //     style: TextStyle(
                      //         color: isTemperatureControlOn
                      //             ? Colors.white
                      //             : Colors
                      //                 .black), // Set the text color to white
                      //   ),
                      // ),

                      ElevatedButton(
                        onPressed: isTemperatureControlOn
                            ? isManualButtonEnabled
                            ? () {
                          setState(() {
                            // Toggle the fan state
                            isSprinklerOn = isSprinklerOn == 0 ? 1 : 0;

                            String logAction = isSprinklerOn == 1 ? "Sprinkler On" : "Sprinkler Off";

                            int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;

                            _database
                                .reference()
                                .child(_selectedDeviceNotifier.deviceSelected)
                                .child("history")
                                .push()
                                .set({
                              "action": logAction,
                              "time": currentTimeMillis,
                              "date": DateFormat('dd MMMM yyyy').format(DateTime.now()),
                            });


                            // Update the Firebase value
                            _database
                                .reference()
                                .child(_selectedDeviceNotifier
                                .deviceSelected)
                                .child("actuators-manual")
                                .update({"sprinkler": isSprinklerOn});
                          });
                        }
                            : null
                            : null, //yash
                        style: ElevatedButton.styleFrom(
                          primary: isSprinklerOn == 0
                              ? Colors.green.shade200
                              : Color(0xff126b23),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Sprinkler',
                          style: TextStyle(
                            color: isTemperatureControlOn
                                ? isSprinklerOn == 0
                                ? Colors.black
                                : Colors.white
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                top: 620, // Adjust the top position as needed
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Actuators Automatic',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Set the text color to black
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'OFF',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isLightControlOn
                                  ? Colors.black
                                  : Colors
                                  .black45, // Set the text color to black when ON, grey when OFF
                            ),
                          ),
                          Switch(
                            value: isLightControlOn,
                            onChanged: (value) {
                              setState(() {
                                isLightControlOn = value;
                                isManualButtonEnabled = !value;
                                isPumpOn = 0;

                                // Update the Firebase value
                                _database
                                    .reference()
                                    .child(
                                    _selectedDeviceNotifier.deviceSelected)
                                    .child("actuators-manual")
                                    .update({"pump": isPumpOn});

                                isSprinklerOn = 0;

                                // Update the Firebase value
                                _database
                                    .reference()
                                    .child(
                                    _selectedDeviceNotifier.deviceSelected)
                                    .child("actuators-manual")
                                    .update({"sprinkler": isSprinklerOn});

                                isFanOn = 0;

                                // Update the Firebase value
                                _database
                                    .reference()
                                    .child(
                                    _selectedDeviceNotifier.deviceSelected)
                                    .child("actuators-manual")
                                    .update({"fan": isFanOn});

                                isLightOn = 0;

                                _database
                                    .reference()
                                    .child(
                                    _selectedDeviceNotifier.deviceSelected)
                                    .child("actuators-manual")
                                    .update({"light": isLightOn});

                                // if (isLightControlOn) {
                                //   isTemperatureControlOn = false;
                                //    // Turn off Manual

                                // }
                              });
                              // Handle the toggle switch action here
                            },
                            activeColor: greenColortwo,
                            inactiveThumbColor: Colors.black45,
                            inactiveTrackColor:
                            Colors.white54, // Set the active color to green
                          ),
                          Text(
                            'ON',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isLightControlOn
                                  ? Colors.green
                                  : Colors
                                  .black45, // Set the text color to green when ON, grey when OFF
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                top: 700,
                left: 50,
                right: 50,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 3,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.green),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Watering Time',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.green,
                                  size: 24,
                                ),
                                onPressed: () {
                                  // Handle the button click action here
                                  _showAddReminderBottomSheet(context);
                                },
                              ),
                            ],
                          ),
                          // SizedBox(height: 1), // Add some space between the title and the cards
                          Container(
                            // Fixed height for displaying only two cards
                            height: 155, // Adjust this height as needed
                            child: ListView.builder(
                              itemCount: wateringTimeEntries.length,
                              scrollDirection:
                              Axis.vertical, // Change this to Axis.vertical
                              itemBuilder: (context, index) {
                                WateringTimeEntry entry =
                                wateringTimeEntries[index];
                                return SizedBox(
                                  height:
                                  125, // Adjust the height of each small card as needed
                                  child: Card(
                                    color: Colors.green.shade50,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Start Time: ${entry.startTime}',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'End Time: ${entry.endTime}',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Spacer(),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  IconButton(
                                                    icon: Icon(Icons.delete,
                                                        color: Colors.red[700]),
                                                    onPressed: () {
                                                      _deleteWateringTimeEntry(
                                                          entry.key);
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.edit,
                                                        color: Colors
                                                            .green.shade800),
                                                    onPressed: () {
                                                      _showEditWateringTimeDialog(
                                                          context, entry);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 950,
                left: 50,
                right: 50,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 3,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.green),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Fertilizing Time',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.green,
                                  size: 24,
                                ),
                                onPressed: () {
                                  // Handle the button click action here
                                  _showAddReminderBottomSheetFerti(context);
                                },
                              ),
                            ],
                          ),
                          Container(
                            // Fixed height for displaying only two cards
                            height: 155, // Adjust this height as needed
                            child: ListView.builder(
                              itemCount: fertilizingTimeEntries.length,
                              scrollDirection:
                              Axis.vertical, // Change this to Axis.vertical
                              itemBuilder: (context, index) {
                                FertilizingTimeEntry entry =
                                fertilizingTimeEntries[index];
                                return SizedBox(
                                  height:
                                  125, // Adjust the height of each small card as needed
                                  child: Card(
                                    color: Colors.green.shade50,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Start Time: ${entry.startTime}',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'End Time: ${entry.endTime}',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Spacer(),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  IconButton(
                                                    icon: Icon(Icons.delete,
                                                        color: Colors.red[700]),
                                                    onPressed: () {
                                                      _deleteFertilizingTimeEntry(
                                                          entry.key);
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.edit,
                                                        color: Colors
                                                            .green.shade800),
                                                    onPressed: () {
                                                      _showEditFertilizingTimeDialog(
                                                          context, entry);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Positioned(
              //   top: 1210,
              //   left: 20,
              //   right: 20,
              //   child: ElevatedButton(
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(builder: (context) => LogHistoryPage()),
              //       );
              //     },
              //     style: ElevatedButton.styleFrom(
              //       primary: Colors.green.shade400,
              //       elevation: 5,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //     ),
              //     child: Container(
              //       padding: EdgeInsets.all(16),
              //       child: Column(
              //         children: [
              //           // Your existing code here if needed
              //
              //           // Log History text
              //           Center(
              //             child: Text(
              //               'Log History',
              //               style: TextStyle(
              //                 fontSize: 19,
              //                 fontWeight: FontWeight.bold,
              //                 color: Colors.white,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),

            ],
          ),
        ),
      ),
    );
  }
}

Widget buildColumn(IconData icon, String text, Color iconColor) {
  return Column(
    children: [
      Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 17,
            child: Icon(icon, color: iconColor, size: 25),
          ),
          SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    ],
  );
}

Widget buildText(String text) {
  return Column(
    children: [
      Row(
        children: [
          Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    ],
  );
}

class WateringTimeEntry {
  final String key;
  late final String startTime;
  late final String endTime;

  WateringTimeEntry({
    required this.key,
    required this.startTime,
    required this.endTime,
  });
}

class FertilizingTimeEntry {
  final String key;
  late final String startTime;
  late final String endTime;

  FertilizingTimeEntry({
    required this.key,
    required this.startTime,
    required this.endTime,
  });
}

class ThresholdsWidget extends StatefulWidget {
  final IconData iconData;
  final String sensorName;
  final Color iconColor;

  ThresholdsWidget({
    required this.iconData,
    required this.sensorName,
    required this.iconColor,
  });

  @override
  _ThresholdsWidgetState createState() => _ThresholdsWidgetState();
}

class _ThresholdsWidgetState extends State<ThresholdsWidget> {
  String thresholdValue = "";

  @override
  void initState() {
    super.initState();
    fetchDataFromDatabase();
  }

  void updateThresholdValue(String newValue) {
    setState(() {
      thresholdValue = newValue;
    });
  }

  void fetchDataFromDatabase() {
    final DatabaseReference dbRef = FirebaseDatabase.instance
        .reference()
        .child(_selectedDeviceNotifier.deviceSelected)
        .child("thresholdss");

    // Listen for changes to the data in the database
    dbRef.child(widget.sensorName).onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null) {
        setState(() {
          thresholdValue = data.toString();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Show the popup dialog for the threshold
        showThresholdInputDialog(
          context,
          widget.sensorName,
          widget.iconData,
          thresholdValue,
          updateThresholdValue,
        );
      },
      child: buildColumn(
        widget.iconData,
        thresholdValue,
        widget.iconColor,
      ),
    );
  }
}

void updateThresholdValue(
    String deviceName, String sensorName, String newValue) {
  final DatabaseReference dbRef = FirebaseDatabase.instance
      .reference()
      .child(deviceName)
      .child("thresholdss");
  dbRef.update({sensorName: newValue});
}

SelectedDeviceNotifier _selectedDeviceNotifier = SelectedDeviceNotifier();
void showThresholdInputDialog(
    BuildContext context,
    String title,
    IconData iconData,
    String currentValue,
    Function(String) onThresholdValueUpdated,
    ) {
  String thresholdValue = currentValue;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: TextFormField(
          initialValue: currentValue,
          onChanged: (value) {
            thresholdValue = value;
          },
          decoration: InputDecoration(
            labelText: "Enter Threshold Value",
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.green.shade400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              // Update the database with the new threshold value
              updateThresholdValue(_selectedDeviceNotifier.deviceSelected,
                  title.toLowerCase(), thresholdValue);

              // Call the callback function to update the value in the widget
              onThresholdValueUpdated(thresholdValue);

              print("Threshold value saved: $thresholdValue");
              Navigator.of(context).pop();
            },
            child: Text(
              "Save",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.green.shade400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Cancel",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
      );
    },
  );
}

// Updated buildThresholdColumn function with iconColor parameter
Widget buildThresholdColumn(
    IconData icon, String text, Color iconColor, Color backgroundColor) {
  return Column(
    children: [
      Row(
        children: [
          CircleAvatar(
            backgroundColor: backgroundColor,
            radius: 17,
            child:
            Icon(icon, color: iconColor, size: 25), // Set icon color here
          ),
          SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
                color: const Color.fromARGB(255, 255, 0, 0), fontSize: 16),
          ),
        ],
      ),
    ],
  );
}

