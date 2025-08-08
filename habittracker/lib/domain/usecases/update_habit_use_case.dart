import '../entities/habit.dart';
import '../repositories/habit_repository.dart';

class UpdateHabitUseCase {
  final HabitRepository _habitRepository;

  UpdateHabitUseCase(this._habitRepository);

  Future<void> execute(String userId, Habit habit) async {
    await _habitRepository.updateHabit(userId, habit);
  }
}
