import '../entities/habit.dart';
import '../repositories/habit_repository.dart';

class GetHabitsUseCase {
  final HabitRepository repository;

  GetHabitsUseCase(this.repository);

  Stream<List<Habit>> execute(String userId) {
    return repository.getHabits(userId);
  }
}
