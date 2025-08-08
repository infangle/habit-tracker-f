import '../repositories/habit_repository.dart';

class DeleteHabitUseCase {
  final HabitRepository _habitRepository;

  DeleteHabitUseCase(this._habitRepository);

  Future<void> execute(String userId, String habitId) async {
    await _habitRepository.deleteHabit(userId, habitId);
  }
}
