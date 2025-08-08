import '../entities/habit.dart';
import '../repositories/habit_repository.dart';

class GetHabitsUseCase {
  final HabitRepository repository;

  GetHabitsUseCase(this.repository);

  Future<List<Habit>> execute(String userId) async {
    return await repository.getHabits(userId);
  }
}
