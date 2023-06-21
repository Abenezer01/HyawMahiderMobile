import 'package:flutter/material.dart';

class MemberStatisticsPage extends StatelessWidget {
  final String memberName;
  final List<bool> attendanceData;
  final List<DateTime> attendanceDates;

  MemberStatisticsPage({
    required this.memberName,
    required this.attendanceData,
    required this.attendanceDates,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(memberName),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: attendanceData.isNotEmpty
            ? Column(
                children: [
                  Text('Attendance Statistics'),
                  SizedBox(height: 16.0),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 10,
                        childAspectRatio:
                            1.0, // Set aspect ratio to make items square
                        crossAxisSpacing: 8.0, // Add spacing between columns
                        mainAxisSpacing: 8.0, // Add spacing between rows
                      ),
                      itemCount: attendanceDates.length,
                      itemBuilder: (context, index) {
                        final date = attendanceDates[index];
                        final attendanceIndex =
                            attendanceData.length > index ? index : 0;
                        final attendance = attendanceData[attendanceIndex];
                        final weekNumber = getWeekNumber(date);

                        return Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: attendance
                                ? Colors.lightGreen
                                : Colors.redAccent,
                            shape: BoxShape.rectangle,
                          ),
                          child: Text(
                            weekNumber.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            : Center(
                child: Text('No attendance data available'),
              ),
      ),
    );
  }

  int getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysPassed = date.difference(firstDayOfYear).inDays;
    final weekNumber = (daysPassed / 7).ceil();

    return weekNumber;
  }
}
