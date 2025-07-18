// Efficient ScrollingWheelController for better state management
import 'package:flutter/material.dart';
import 'package:task_wizard/Features/Shared/Constants/Theme/my_colors.dart';
import 'package:task_wizard/Features/Shared/Constants/app_sizes.dart';

class FrequencySelector extends StatefulWidget {
  const FrequencySelector({
    super.key,
    required this.onNumberChanged,
    required this.ontypeChanged,
    this.initialFrequency = 'Daily',
  });
  final Function(int) onNumberChanged;
  final Function(String) ontypeChanged;
  final String initialFrequency;
  @override
  State<FrequencySelector> createState() => _FrequencySelectorState();
}

class _FrequencySelectorState extends State<FrequencySelector> {
  int selectedNumber = 1;
  late String selectedFrequency;
  final List<int> numbers = List.generate(30, (index) => index + 1);
  final List<String> frequencies = ['Daily', 'Weekly', 'Monthly', 'Yearly'];

  @override
  void initState() {
    selectedFrequency = widget.initialFrequency;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Sizes.p8),
      color: MYColors.greyCardColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Frequency', style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Every'),
              // Number wheel
              SizedBox(
                width: 80,
                height: 150,
                child: ListWheelScrollView(
                  itemExtent: 50,
                  perspective: 0.005,
                  diameterRatio: 1.5,
                  physics: FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    
                      selectedNumber = numbers[index];
                    
                    widget.onNumberChanged(numbers[index]);
                  },
                  children:
                      numbers.map((number) {
                        return _buildWheelItem(
                          number.toString(),
                          number == selectedNumber,
                        );
                      }).toList(),
                ),
              ),
              SizedBox(width: 20),
              // Frequency wheel
              SizedBox(
                width: 120,
                height: 150,
                child: ListWheelScrollView(
                  itemExtent: 50,
                  perspective: 0.005,
                  diameterRatio: 1.5,
                  physics: FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    
                      selectedFrequency = frequencies[index];
                    
                      widget.ontypeChanged(frequencies[index]);
                  },
                  children:
                      frequencies.map((frequency) {
                        return _buildWheelItem(
                          frequency,
                          frequency == selectedFrequency,
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWheelItem(String text, bool isSelected) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: isSelected ? 24 : 18,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.blue : Colors.grey,
        ),
      ),
    );
  }
}
