class TaskData {

  TaskData({
    required this.title,
    required this.description,
    required this.dateRange,
    required this.recurrence,
    required this.priority,
    required this.category,
  });

  factory TaskData.fromList(List<dynamic> data) {
    return TaskData(
      title: data[0] as String,
      description: data[1] as String,
      dateRange: data[2] as String,
      recurrence: data[3] as String,
      priority: data.length > 4 ? data[4] as String? : null,
      category: data.length > 5 ? data[5] as String? : null,
    );
  }
  final String title;
  final String description;
  final String dateRange;
  final String recurrence;
  final String? priority;
  final String? category;

  DateTime get startDate {
    final dates = dateRange.split(':');
    return DateTime.parse(dates[0]);
  }

  DateTime get endDate {
    final dates = dateRange.split(':');
    return DateTime.parse(dates[1]);
  }
}
