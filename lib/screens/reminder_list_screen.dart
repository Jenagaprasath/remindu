import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../models/reminder.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';
import 'reminder_setting_screen.dart';

class ReminderListScreen extends StatefulWidget {
  const ReminderListScreen({super.key});

  @override
  State<ReminderListScreen> createState() => _ReminderListScreenState();
}

class _ReminderListScreenState extends State<ReminderListScreen> {
  List<Reminder> _reminders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    final reminders = await StorageService.loadReminders();
    setState(() {
      _reminders = reminders;
      _loading = false;
    });
  }

  Future<void> _deleteReminder(Reminder reminder) async {
    await StorageService.deleteReminder(reminder.id);
    await NotificationService.cancelReminder(reminder.id);
    _loadReminders();
  }

  Future<void> _goToNewReminder() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ReminderSettingScreen()),
    );
    if (result == true) _loadReminders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: _loading ? _buildLoading() : _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(72),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.7),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.05),
              blurRadius: 20,
            ),
          ],
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: IconButton(
              icon: const Icon(Icons.menu_rounded, color: AppColors.primary),
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }

  Widget _buildBody() {
    return _reminders.isEmpty ? _buildEmptyFull() : _buildList();
  }

  Widget _buildEmptyFull() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('NO REMINDERS',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 64,
                fontWeight: FontWeight.w900,
                color: AppColors.surfaceContainerHighest,
              )),
          const SizedBox(height: 8),
          Text("Tap NEW to create your first reminder",
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurfaceVariant,
              )),
        ],
      ),
    );
  }

  Widget _buildList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
          top: 100, left: 24, right: 24, bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 32),
          ..._reminders.asMap().entries.map((entry) {
            final index = entry.key;
            final reminder = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildReminderCard(reminder, index),
            );
          }),
          const SizedBox(height: 48),
          _buildEmptyState(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily\nCurations',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 48,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
            height: 1.1,
            letterSpacing: -1.5,
          ),
        ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: 8, height: 8,
              decoration: const BoxDecoration(
                color: AppColors.tertiary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${_reminders.length} reminder${_reminders.length == 1 ? '' : 's'} saved',
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ).animate().fadeIn(delay: 200.ms),
      ],
    );
  }

  Widget _buildReminderCard(Reminder reminder, int index) {
    return Dismissible(
      key: Key(reminder.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _deleteReminder(reminder),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(28),
        ),
        child: const Icon(Icons.delete_outline_rounded,
            color: Colors.red, size: 28),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: _repeatColor(reminder.repeatType).withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(_repeatIcon(reminder.repeatType),
                  color: _repeatColor(reminder.repeatType), size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reminder.subtitleText,
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _repeatColor(reminder.repeatType).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                reminder.repeatLabel,
                style: GoogleFonts.manrope(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: _repeatColor(reminder.repeatType),
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 100 * index))
        .slideY(begin: 0.05);
  }

  Color _repeatColor(RepeatType type) {
    switch (type) {
      case RepeatType.once:
        return AppColors.tertiary;
      case RepeatType.daily:
        return AppColors.primary;
      case RepeatType.weekly:
        return const Color(0xFF4CAF50);
      case RepeatType.monthly:
        return const Color(0xFFFF9800);
      case RepeatType.yearly:
        return const Color(0xFFE91E63);
    }
  }

  IconData _repeatIcon(RepeatType type) {
    switch (type) {
      case RepeatType.once:
        return Icons.looks_one_rounded;
      case RepeatType.daily:
        return Icons.repeat_rounded;
      case RepeatType.weekly:
        return Icons.view_week_rounded;
      case RepeatType.monthly:
        return Icons.calendar_month_rounded;
      case RepeatType.yearly:
        return Icons.auto_awesome_rounded;
    }
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.surfaceContainerHighest,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        children: [
          Text('FIN',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 64,
                fontWeight: FontWeight.w900,
                color: AppColors.surfaceContainerHighest,
              )),
          const SizedBox(height: 8),
          Text("That's everything for now.",
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurfaceVariant,
              )),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.only(
          left: 24, right: 24, bottom: 28, top: 12),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.7),
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _goToNewReminder,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryContainer],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 48, vertical: 18),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add_rounded,
                        color: AppColors.onPrimary, size: 20),
                    const SizedBox(width: 8),
                    Text('NEW',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.onPrimary,
                          letterSpacing: 2,
                        )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}