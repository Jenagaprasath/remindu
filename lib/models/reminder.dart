enum RepeatType { once, daily, weekly, monthly, yearly }

class Reminder {
  final String id;
  final String title;
  final DateTime dateTime;
  final RepeatType repeatType;
  bool isCompleted;

  Reminder({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.repeatType,
    this.isCompleted = false,
  });

  String get repeatLabel {
    switch (repeatType) {
      case RepeatType.once:
        return 'ONCE';
      case RepeatType.daily:
        return 'DAILY';
      case RepeatType.weekly:
        return 'WEEKLY';
      case RepeatType.monthly:
        return 'MONTHLY';
      case RepeatType.yearly:
        return 'YEARLY';
    }
  }

  String get subtitleText {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final hour = dateTime.hour > 12
        ? dateTime.hour - 12
        : dateTime.hour == 0
            ? 12
            : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    final timeStr = '$hour:$minute $period';
    final dateStr =
        '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
    return '$timeStr • $dateStr • $repeatLabel';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'dateTime': dateTime.toIso8601String(),
        'repeatType': repeatType.index,
        'isCompleted': isCompleted,
      };

  factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
        id: json['id'],
        title: json['title'],
        dateTime: DateTime.parse(json['dateTime']),
        repeatType: RepeatType.values[json['repeatType']],
        isCompleted: json['isCompleted'] ?? false,
      );
}