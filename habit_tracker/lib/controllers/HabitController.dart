import 'package:get/get.dart';

class HabitController extends GetxController {
  RxList<String> habits = <String>[].obs;

  void addHabit(String habitName) {
    habits.add(habitName);
  }

  void removeHabit(String habitName) {
    habits.remove(habitName);
  }

  void updateHabit(int index, String newHabitName) {
    habits[index] = newHabitName;
  }
}
