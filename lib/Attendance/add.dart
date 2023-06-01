import 'package:flutter/material.dart';
import 'package:hyaw_mahider/services/api-service.dart';

class TakeAttendanceScreen extends StatefulWidget {
  const TakeAttendanceScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TakeAttendanceScreenState createState() => _TakeAttendanceScreenState();
}

class _TakeAttendanceScreenState extends State<TakeAttendanceScreen> {
  DateTime? selectedWeek;
  List<String> studentList = [
    'Student 1',
    'Student 2',
    'Student 3',
    // Add more student names as per your requirement
  ];
  Map<String, bool> attendanceData = {};
  final APIService apiService = APIService();
  late Map<String, dynamic>? data = {};
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

  @override
  void initState() {
    super.initState();
  }

  void _initializeAttendanceData() {
    fetchAttendanceData();
    attendanceData.clear();
    for (String student in studentList) {
      attendanceData[student] = false;
    }
  }

  void _markAttendance(String student, bool? isPresent) {
    setState(() {
      attendanceData[student] = isPresent ?? false;
    });
  }

  void _submitAttendance() {
    // Here you can handle the submission of attendance data
  }

  void fetchAttendanceData() async {
    try {
      final attendanceResponse = await apiService.getData('attendance');

      if (attendanceResponse is Map<String, dynamic>) {
        setState(() {
          data = attendanceResponse;
        });
      } else {
        throw Exception('Invalid response format');
      }
      // Process the attendanceData
    } catch (e) {
      // Handle the error
    }
  }

  void submitAttendanceData(Map<String, dynamic> attendanceData) async {
    try {
      // Process the response
    } catch (e) {
      // Handle the error
    }
  }

  void updateAttendanceData(
      String attendanceId, Map<String, dynamic> updatedData) async {
    try {
      // ignore: unused_local_variable
      final response =
          await apiService.updateData('attendance', attendanceId, updatedData);
      // Process the response
    } catch (e) {
      // Handle the error
    }
  }

  void deleteAttendanceData(String attendanceId) async {
    try {
      await apiService.deleteData('attendance', attendanceId);
      // Data successfully deleted
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
              itemCount: studentList.length,
              itemBuilder: (context, index) {
                String student = studentList[index];
                return AttendanceItem(
                  student: student,
                  attendance: attendanceData[student] ?? false,
                  onAttendanceChanged: (isPresent) {
                    _markAttendance(student, isPresent);
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
          )
        ],
      ),
    );
  }
}

class WeekSelector extends StatefulWidget {
  final DateTime? selectedWeek;
  final Function(BuildContext) selectWeek;

  const WeekSelector(
      {super.key, required this.selectedWeek, required this.selectWeek});

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
  final String student;
  final bool attendance;
  final Function(bool) onAttendanceChanged;

  const AttendanceItem({
    super.key,
    required this.student,
    required this.attendance,
    required this.onAttendanceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(student),
      trailing: Checkbox(
        value: attendance,
        onChanged: (value) => onAttendanceChanged(value ?? false),
      ),
    );
  }
}