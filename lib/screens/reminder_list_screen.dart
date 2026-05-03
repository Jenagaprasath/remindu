import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final Set<String> _selectedIds = {};
  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  bool get _isSelecting => _selectedIds.isNotEmpty;

  List<Reminder> get _filteredReminders {
    if (_searchQuery.isEmpty) return _reminders;
    return _reminders
        .where((r) =>
            r.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadReminders() async {
    final reminders = await StorageService.loadReminders();
    setState(() {
      _reminders = reminders;
      _loading = false;
    });
  }

  Future<void> _deleteSelected() async {
    for (final id in _selectedIds) {
      await StorageService.deleteReminder(id);
      await NotificationService.cancelReminder(id);
    }
    setState(() => _selectedIds.clear());
    _loadReminders();
  }

  void _onLongPress(Reminder reminder) {
    HapticFeedback.mediumImpact();
    setState(() => _selectedIds.add(reminder.id));
  }

  void _onTap(Reminder reminder) async {
    if (_isSelecting) {
      setState(() {
        if (_selectedIds.contains(reminder.id)) {
          _selectedIds.remove(reminder.id);
        } else {
          _selectedIds.add(reminder.id);
        }
      });
    } else {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ReminderSettingScreen(existingReminder: reminder),
        ),
      );
      if (result == true) _loadReminders();
    }
  }

  void _clearSelection() {
    setState(() => _selectedIds.clear());
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchQuery = '';
        _searchController.clear();
      }
    });
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
      bottomNavigationBar:
          _isSelecting ? _buildDeleteBar() : _buildBottomNav(),
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
          leading: _isSelecting
              ? Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: IconButton(
                    icon: const Icon(Icons.close_rounded,
                        color: AppColors.primary),
                    onPressed: _clearSelection,
                  ),
                )
              : _isSearching
                  ? Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_rounded,
                            color: AppColors.primary),
                        onPressed: _toggleSearch,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: IconButton(
                        icon: const Icon(Icons.menu_rounded,
                            color: AppColors.primary),
                        onPressed: () {},
                      ),
                    ),
          title: _isSelecting
              ? Text(
                  '${_selectedIds.length} selected',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                )
              : _isSearching
                  ? TextField(
                      controller: _searchController,
                      autofocus: true,
                      onChanged: (val) =>
                          setState(() => _searchQuery = val),
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search reminders...',
                        hintStyle: GoogleFonts.manrope(
                          fontSize: 16,
                          color: AppColors.onSurfaceVariant,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    )
                  : null,
          actions: [
            if (!_isSelecting)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: IconButton(
                  icon: Icon(
                    _isSearching
                        ? Icons.close_rounded
                        : Icons.search_rounded,
                    color: AppColors.primary,
                  ),
                  onPressed: _toggleSearch,
                ),
              ),
          ],
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
    if (_reminders.isEmpty) return _buildEmptyFull();
    if (_isSearching && _filteredReminders.isEmpty) {
      return _buildNoResults();
    }
    return _buildList();
  }

  Widget _buildEmptyFull() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.notifications_none_rounded,
            size: 64,
            color: AppColors.surfaceContainerHighest,
          ),
          const SizedBox(height: 16),
          Text(
            'No Reminders Yet',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.surfaceContainerHighest,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Tap NEW to create your first reminder",
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 64,
            color: AppColors.surfaceContainerHighest,
          ),
          const SizedBox(height: 16),
          Text(
            'No Results',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.surfaceContainerHighest,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No reminders match "$_searchQuery"',
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    final reminders = _filteredReminders;
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
          top: 100, left: 24, right: 24, bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!_isSearching) _buildHeader(),
          if (_isSearching) _buildSearchHeader(),
          const SizedBox(height: 32),
          ...reminders.asMap().entries.map((entry) {
            final index = entry.key;
            final reminder = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildReminderCard(reminder, index),
            );
          }),
          if (!_isSearching) ...[
            const SizedBox(height: 48),
            _buildEmptyState(),
          ],
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
              width: 8,
              height: 8,
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

  Widget _buildSearchHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _searchQuery.isEmpty
              ? 'Type to search your reminders'
              : '${_filteredReminders.length} result${_filteredReminders.length == 1 ? '' : 's'} for "$_searchQuery"',
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildReminderCard(Reminder reminder, int index) {
    final isSelected = _selectedIds.contains(reminder.id);

    return GestureDetector(
      onLongPress: () => _onLongPress(reminder),
      onTap: () => _onTap(reminder),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryContainer.withOpacity(0.4)
              : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(28),
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 2)
              : Border.all(color: Colors.transparent, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary
                  .withOpacity(isSelected ? 0.08 : 0.04),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isSelected
                  ? Container(
                      key: const ValueKey('selected'),
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_rounded,
                          color: AppColors.onPrimary, size: 22),
                    )
                  : Container(
                      key: const ValueKey('icon'),
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _repeatColor(reminder.repeatType)
                            .withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        _repeatIcon(reminder.repeatType),
                        color: _repeatColor(reminder.repeatType),
                        size: 22,
                      ),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _isSearching && _searchQuery.isNotEmpty
                      ? _buildHighlightedText(reminder.title)
                      : Text(
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
                color: _repeatColor(reminder.repeatType)
                    .withOpacity(0.1),
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
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: 50 * index))
        .slideY(begin: 0.05);
  }

  Widget _buildHighlightedText(String text) {
    final query = _searchQuery.toLowerCase();
    final lowerText = text.toLowerCase();
    final start = lowerText.indexOf(query);
    if (start == -1) {
      return Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        ),
      );
    }
    final end = start + query.length;
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: text.substring(0, start),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          TextSpan(
            text: text.substring(start, end),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              backgroundColor: AppColors.primaryContainer.withOpacity(0.4),
            ),
          ),
          TextSpan(
            text: text.substring(end),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
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
          Text(
            'FIN',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 64,
              fontWeight: FontWeight.w900,
              color: AppColors.surfaceContainerHighest,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "That's everything for now.",
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _buildDeleteBar() {
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
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _clearSelection,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: const StadiumBorder(),
                side: BorderSide(
                    color: AppColors.outlineVariant.withOpacity(0.3)),
              ),
              child: Text(
                'CANCEL',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.red.shade400,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _deleteSelected,
                icon: const Icon(Icons.delete_outline_rounded,
                    color: Colors.white, size: 20),
                label: Text(
                  'DELETE ${_selectedIds.length}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: const StadiumBorder(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
                    Text(
                      'NEW',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onPrimary,
                        letterSpacing: 2,
                      ),
                    ),
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