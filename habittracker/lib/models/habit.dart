class Habit {
  final String id;
  final String name;
  final String frequency;
  final DateTime? startDate;
  bool isCompleted;
  DateTime? completedDate;

  Habit({
    required this.id,
    required this.name,
    required this.frequency,
    this.startDate,
    this.isCompleted = false,
    this.completedDate,
  });
}
