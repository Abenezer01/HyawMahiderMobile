import 'package:flutter/material.dart';
import 'package:hyaw_mahider/services/api-service.dart';
import 'dart:convert';

class TakeAttendanceScreen extends StatefulWidget {
  const TakeAttendanceScreen({Key? key}) : super(key: key);

  @override
  _TakeAttendanceScreenState createState() => _TakeAttendanceScreenState();
}

class _TakeAttendanceScreenState extends State<TakeAttendanceScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  DateTime? selectedWeek;
  List<Map<String, dynamic>> memberList = [];
  Map<String, bool> attendanceData = {};
  final APIService apiService = APIService();
  late Map<String, dynamic> data = {};
  late String note = '';
  bool _isLoading = false;

  Future<void> _selectWeek() async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = now.subtract(Duration(days: now.weekday - 1));
    final DateTime? picked = await showDatePicker(
      context: _scaffoldKey.currentContext!,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      selectableDayPredicate: (DateTime day) => day.weekday == DateTime.monday,
    );

    if (picked != null) {
      setState(() {
        selectedWeek = picked;
        _initializeAttendanceData();
        fetchAttendanceData();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeAttendanceData();
  }

  void _initializeAttendanceData() {
    attendanceData = {};
    for (var member in memberList) {
      attendanceData[member['id'].toString()] = false;
    }
  }

  void _markAttendance(String memberId, bool? isPresent) {
    setState(() {
      attendanceData[memberId] = isPresent ?? false;
    });
  }

  void _submitWeeklyReport() async {
    if (_formKey.currentState!.validate()) {
      // Here you can handle the submission of attendance data
      List<Map<String, dynamic>> attendanceList =
          attendanceData.entries.map((entry) {
        return {
          'member_id': entry.key,
          'status': entry.value,
        };
      }).toList();
      Map<String, dynamic> data = {
        'members_attendance': attendanceList,
        'description': note,
        'date': selectedWeek?.toIso8601String(),
        "small_team_id": "d476c9a1-5020-42a7-bdbd-8be49ba392a9",
      };

      try {
        setState(() {
          _isLoading = true; // Show loading indicator
        });

        final submitAttendance = await apiService.postData(
            'auth/members-module/weekly-report', data);

        if (submitAttendance != null) {
          Navigator.of(context).pop(data);
          var showSnackBar = ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Attendance submitted succesfully!')),
          );
        }
      } catch (e) {
        print('Error: $e');
      } finally {
        setState(() {
          _isLoading = false; // Hide loading indicator
        });
      }
    }
  }

  void fetchAttendanceData() async {
    try {
      final formattedSelectedWeek =
          selectedWeek != null ? selectedWeek!.toIso8601String() : '';
      final attendanceResponse = await apiService.getData(
          'auth/members-module/attendance/prepare/853bcd28-df64-4826-9108-a97276ea5f40?date=$formattedSelectedWeek');

      final attendanceData = json.decode(attendanceResponse);

      if (attendanceData != null) {
        setState(() {
          data = attendanceData;
          memberList = data['data'] != null
              ? List<Map<String, dynamic>>.from(data['data']['members'])
              : [];
        });

        final attendanceTaken = data['attendance_taken'] ?? false;
        if (attendanceTaken) {
          _showAttendanceTakenDialog(formattedSelectedWeek, data['data']['id']);
        }
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showAttendanceTakenDialog(formattedSelectedWeek, teamId) {
    showDialog(
      context: _scaffoldKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Attendance Taken'),
          content: const Text(
              'Attendance has already been taken for the selected week.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                _editPreviousAttendance(formattedSelectedWeek, teamId);
              },
              child: const Text('Edit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Return'),
            ),
          ],
        );
      },
    );
  }

  void _editPreviousAttendance(formattedSelectedWeek, teamId) async {
    try {
      final previousAttendanceResponse = await apiService.getData(
          'auth/members-module/attendance/getByTeamId/$teamId?date=$formattedSelectedWeek');

      final previousAttendanceData = json.decode(previousAttendanceResponse);

      if (previousAttendanceData != null) {
        setState(() {
          final attendances = previousAttendanceData['attendances'];
          final attendanceList = List<Map<String, dynamic>>.from(attendances);
          for (var member in memberList) {
            attendanceData[member['id'].toString()] = attendanceList.any(
                (attendance) =>
                    attendance['member_id'] == member['id'].toString());
          }
        });
      } else {
        throw Exception('Failed to fetch previous attendance data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Attendance App'),
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: _selectWeek,
                  child: Text(selectedWeek != null
                      ? 'Selected Week: ${selectedWeek!.toString()}'
                      : 'Select Week'),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    selectedWeek != null
                        ? 'Selected Week: ${selectedWeek!.toString()}'
                        : 'No week selected',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        note = value;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Note is required';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Note',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: memberList.length,
                    itemBuilder: (context, index) {
                      var member = memberList[index];
                      return AttendanceItem(
                        key: Key(member['id'].toString()),
                        member: member,
                        attendance:
                            attendanceData[member['id'].toString()] ?? false,
                        onAttendanceChanged: (isPresent) {
                          _markAttendance(member['id'].toString(), isPresent);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _submitWeeklyReport,
        label: const Text('Submit'),
        icon: const Icon(Icons.send),
      ),
    );
  }
}

class AttendanceItem extends StatelessWidget {
  final Map<String, dynamic> member;
  final bool attendance;
  final Function(bool?) onAttendanceChanged;

  const AttendanceItem({
    Key? key,
    required this.member,
    required this.attendance,
    required this.onAttendanceChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(member['name']),
      value: attendance,
      onChanged: onAttendanceChanged,
    );
  }
}
