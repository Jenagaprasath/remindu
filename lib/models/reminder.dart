class Reminder {
  final String id;
  final String title;
  final String? subtitle;
  final DateTime dateTime;
  final String? tag;
  final bool isHighPriority;
  bool isCompleted;

  Reminder({
    required this.id,
    required this.title,
    this.subtitle,
    required this.dateTime,
    this.tag,
    this.isHighPriority = false,
    this.isCompleted = false,
  });
}

final List<Reminder> sampleReminders = [
  Reminder(
    id: '1',
    title: 'Morning meditation and intentional breathing session',
    subtitle: '8:30 AM • Daily Routine',
    dateTime: DateTime.now().copyWith(hour: 8, minute: 30),
    tag: 'High Priority',
    isHighPriority: true,
  ),
  Reminder(
    id: '2',
    title: 'Weekly flower market run',
    subtitle: 'Saturdays',
    dateTime: DateTime.now().copyWith(hour: 10, minute: 0),
    tag: 'Personal',
  ),
  Reminder(
    id: '3',
    title: 'Finalize project proposal',
    subtitle: 'Due Tomorrow',
    dateTime: DateTime.now().copyWith(hour: 17, minute: 0),
    tag: 'Work',
  ),
  Reminder(
    id: '4',
    title: 'Pick up specialty coffee beans',
    subtitle: 'Today, 4:00 PM',
    dateTime: DateTime.now().copyWith(hour: 16, minute: 0),
    tag: 'Errands',
  ),
];