import '../entities/habit.dart';
import '../repositories/habit_repository.dart';

class GetHabitsUseCase {
  final HabitRepository _habitRepository;

  GetHabitsUseCase(this._habitRepository);

  Stream<List<Habit>> execute(String userId) {
    return _habitRepository.getHabits(userId);
  }
}
