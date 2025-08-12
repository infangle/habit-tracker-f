// habit.dart

class Habit {
  final int id;
  final int userId;
  final String name;
  final bool completed;

  Habit({
    required this.id,
    required this.userId,
    required this.name,
    required this.completed,
  });
  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      completed: json['completed'],
    );
  }
  Map<String, dynamic> toJson() {
    return {'id': id, 'userId': userId, 'name': name, 'completed': completed};
  }
}
