import 'package:flutter/material.dart';
import '../../../models/habit.dart';
import '../../../core/constants/app_colors.dart';

class ProgressSummary extends StatelessWidget {
  final List<Habit> habits;

  const ProgressSummary({super.key, required this.habits});

  Map<DateTime, int> getMonthlyCompletionData() {
    final Map<DateTime, int> data = {};
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);

    for (final habit in habits) {
      if (habit.isCompleted && habit.completedDate != null) {
        final date = DateTime(
          habit.completedDate!.year,
          habit.completedDate!.month,
          habit.completedDate!.day,
        );

        // Only include data from current month
        if (date.year == currentMonth.year &&
            date.month == currentMonth.month) {
          data[date] = (data[date] ?? 0) + 1;
        }
      }
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final monthlyData = getMonthlyCompletionData();

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Progress',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Heatmap Calendar
            Container(
              height: 200,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7, // 7 days in a week
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                ),
                itemCount: 35, // 5 weeks view
                itemBuilder: (context, index) {
                  final now = DateTime.now();
                  final firstDay = DateTime(now.year, now.month, 1);
                  final startDate = firstDay.subtract(
                    Duration(days: firstDay.weekday),
                  );
                  final currentDate = startDate.add(Duration(days: index));

                  final completionCount = monthlyData[currentDate] ?? 0;
                  final isCurrentMonth = currentDate.month == now.month;

                  return Container(
                    decoration: BoxDecoration(
                      color: _getColorForCount(completionCount, isCurrentMonth),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        currentDate.day.toString(),
                        style: TextStyle(
                          fontSize: 10,
                          color: isCurrentMonth ? Colors.black : Colors.grey,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 16),

            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('0', Colors.grey[200]!),
                SizedBox(width: 8),
                _buildLegendItem(
                  '1',
                  AppColors.onboarding_background.withOpacity(0.3),
                ),
                SizedBox(width: 8),
                _buildLegendItem(
                  '2-3',
                  AppColors.onboarding_background.withOpacity(0.6),
                ),
                SizedBox(width: 8),
                _buildLegendItem('4+', AppColors.onboarding_background),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForCount(int count, bool isCurrentMonth) {
    if (!isCurrentMonth) return Colors.grey[100]!;

    if (count == 0) return Colors.grey[200]!;
    if (count == 1) return AppColors.onboarding_background.withOpacity(0.3);
    if (count <= 3) return AppColors.onboarding_background.withOpacity(0.6);
    return AppColors.onboarding_background;
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
