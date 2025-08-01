class Habit {
  final String id;
  final String name;
  final String frequency;
  final DateTime? startDate;

  Habit({
    required this.id,
    required this.name,
    required this.frequency,
    this.startDate,
  });
}
