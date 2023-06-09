import 'package:flutter/material.dart';
import 'package:hyaw_mahider/services/api-service.dart';

class TakeAttendanceScreen extends StatefulWidget {
  const TakeAttendanceScreen({Key? key}) : super(key: key);

  @override
  _TakeAttendanceScreenState createState() => _TakeAttendanceScreenState();
}

class _TakeAttendanceScreenState extends State<TakeAttendanceScreen> {
  DateTime? selectedWeek;
  List<String> memberList = [];
  Map<String, bool> attendanceData = {};
  final APIService apiService = APIService();
  Map<String, dynamic>? data = null;

  @override
  void initState() {
    super.initState();
    _initializeAttendanceData();
  }

  void _initializeAttendanceData() {
    attendanceData.clear();
    for (String member in memberList) {
      attendanceData[member] = false;
    }
  }

  Future<void> _selectWeek(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = now.subtract(Duration(days: now.weekday - 1));
    final DateTime? picked = await showDatePicker(
      context: context,
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

  Future<void> fetchAttendanceData() async {
    try {
      final formattedSelectedWeek =
          selectedWeek != null ? selectedWeek!.toIso8601String() : '';
      final attendanceResponse =
          await apiService.getData('attendance?week=$formattedSelectedWeek');

      if (attendanceResponse is Map<String, dynamic>) {
        setState(() {
          data = attendanceResponse;
          memberList =
              data?['data'] != null ? List<String>.from(data?['data']) : [];
        });

        // Check if attendance data exists for the selected week
        final attendanceTaken = data?['attendance_taken'] ?? false;
        if (attendanceTaken) {
          // Attendance has already been taken for the selected week
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Attendance Taken'),
                content: const Text(
                    'Attendance has already been taken for the selected week.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      // Handle the error
    }
  }

  void _markAttendance(String member, bool? isPresent) {
    setState(() {
      attendanceData[member] = isPresent ?? false;
    });
  }

  void _submitAttendance() {
    // Here you can handle the submission of attendance data
    final Map<String, dynamic> attendanceData = {
      'week': selectedWeek!.toIso8601String(),
      'attendance': this.attendanceData,
    };
    submitAttendanceData(attendanceData);
  }

  Future<void> submitAttendanceData(Map<String, dynamic> attendanceData) async {
    try {
      // Process the response
      final response = await apiService.postData('attendance', attendanceData);
      if (response != null) {
        // Attendance submitted successfully
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Attendance Submitted'),
              content:
                  const Text('Attendance has been submitted successfully.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('Failed to submit attendance');
      }
    } catch (e) {
      // Handle the error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance App'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WeekSelector(selectedWeek: selectedWeek, selectWeek: _selectWeek),
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
          Expanded(
            child: ListView.builder(
              itemCount: memberList.length,
              itemBuilder: (context, index) {
                String member = memberList[index];
                return AttendanceItem(
                  member: member,
                  attendance: attendanceData[member] ?? false,
                  onAttendanceChanged: (isPresent) {
                    _markAttendance(member, isPresent);
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _submitAttendance,
            child: Text(data?.isEmpty ?? true
                ? 'Submit'
                : data?['message'] ?? 'Submit'),
          ),
        ],
      ),
    );
  }
}

class WeekSelector extends StatefulWidget {
  final DateTime? selectedWeek;
  final Function(BuildContext) selectWeek;

  const WeekSelector({
    Key? key,
    required this.selectedWeek,
    required this.selectWeek,
  }) : super(key: key);

  @override
  _WeekSelectorState createState() => _WeekSelectorState();
}

class _WeekSelectorState extends State<WeekSelector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => widget.selectWeek(context),
          child: Text(widget.selectedWeek != null
              ? 'Selected Week: ${widget.selectedWeek!.toString()}'
              : 'Select Week'),
        ),
      ],
    );
  }
}

class AttendanceItem extends StatelessWidget {
  final String member;
  final bool attendance;
  final Function(bool) onAttendanceChanged;

  const AttendanceItem({
    Key? key,
    required this.member,
    required this.attendance,
    required this.onAttendanceChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(member),
      trailing: Checkbox(
        value: attendance,
        onChanged: (value) => onAttendanceChanged(value ?? false),
      ),
    );
  }
}
