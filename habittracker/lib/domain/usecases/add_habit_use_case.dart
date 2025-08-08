import '../entities/habit.dart';
import '../repositories/habit_repository.dart';

class AddHabitUseCase {
  final HabitRepository _habitRepository;

  AddHabitUseCase(this._habitRepository);

  Future<void> execute(String userId, Habit habit) async {
    await _habitRepository.addHabit(userId, habit);
  }
}
