
import 'package:flutter/material.dart';

class MonthlyDatePickerWidget extends StatefulWidget {
  const MonthlyDatePickerWidget({super.key, required this.onDaysChanged});
  final Function(List<int>) onDaysChanged;
  @override
  State<MonthlyDatePickerWidget> createState() =>
      _MonthlyDatePickerWidgetState();
}

class _MonthlyDatePickerWidgetState extends State<MonthlyDatePickerWidget> {
  final List<int> selectedDays = [10];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Monthly on the '),
              ...selectedDays.map((day) => Text('${day}th')),
            ],
          ),
          SizedBox(height: 8.0),
          SizedBox(
            height: 150,
            child: GridView.count(
              crossAxisCount: 7,
              childAspectRatio: 1.0,
              children: List.generate(31, (index) {
                final day = index + 1;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selectedDays.contains(day)) {
                        selectedDays.remove(day);
                      } else {
                        selectedDays.add(day);
                      }

                      widget.onDaysChanged.call(selectedDays);
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          selectedDays.contains(day)
                              ? Colors.blue
                              : Colors.transparent,
                    ),
                    child: Center(
                      child: Text(
                        day.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          
          
        ],
      ),
    );
  }
}
