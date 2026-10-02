import 'package:flutter/material.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../widgets/widgets.dart';
import '../../repositories/pawly_repository.dart';
import '../../models/care_routine.dart';

class PetCalendarScreen extends StatefulWidget {
  final PawlyRepository repository;

  const PetCalendarScreen({super.key, required this.repository});

  @override
  State<PetCalendarScreen> createState() => _PetCalendarScreenState();
}

class _PetCalendarScreenState extends State<PetCalendarScreen> {
  late DateTime _selectedMonth;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    // Default to October 2026 to match realistic sample dataset
    _selectedMonth = DateTime(2026, 10, 1);
    _selectedDay = DateTime(2026, 10, 2);
  }

  void _prevMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 1);
    });
  }

  String _formatMonthYear(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _formatDateString(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  @override
  Widget build(BuildContext context) {
    final pet = widget.repository.activePet;
    final selectedDateStr = _formatDateString(_selectedDay);

    // Filter routines for pet
    final routines = widget.repository.activePetRoutines.where((r) {
      return r.date == selectedDateStr;
    }).toList();

    // Filter appointments for pet
    final appointments = widget.repository.activePetAppointments.where((a) {
      return a.date == selectedDateStr;
    }).toList();

    // Filter medications
    final medications = widget.repository.activePetMedications;

    return Scaffold(
      backgroundColor: PawlyColors.creamBg,
      appBar: AppBar(
        backgroundColor: PawlyColors.creamBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: PawlyColors.espresso),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${pet.name}’s Calendar',
          style: PawlyTypography.titleMedium,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Month Selector Header
              PawlyBubble(
                backgroundColor: PawlyColors.surfaceWarm,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left_rounded, color: PawlyColors.espresso),
                      onPressed: _prevMonth,
                      visualDensity: VisualDensity.compact,
                    ),
                    Text(
                      _formatMonthYear(_selectedMonth),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: PawlyColors.espresso,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded, color: PawlyColors.espresso),
                      onPressed: _nextMonth,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Calendar Grid Box
              PawlyBubble(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Day of week labels
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _WeekDayLabel('S'),
                        _WeekDayLabel('M'),
                        _WeekDayLabel('T'),
                        _WeekDayLabel('W'),
                        _WeekDayLabel('T'),
                        _WeekDayLabel('F'),
                        _WeekDayLabel('S'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildMonthGrid(),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Agenda for Selected Day
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Agenda for ${_selectedDay.month}/${_selectedDay.day}/${_selectedDay.year}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: PawlyColors.espresso,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: PawlyColors.forestLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${routines.length + appointments.length} events',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: PawlyColors.forest,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              if (routines.isEmpty && appointments.isEmpty)
                PawlyBubble(
                  backgroundColor: PawlyColors.surfaceWarm,
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: PawlyColors.sageLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.event_available_rounded, color: PawlyColors.forest, size: 20),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Text(
                          'No scheduled appointments or care routines on this day.',
                          style: PawlyTypography.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),

              // Appointments
              ...appointments.map((appt) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: PawlyBubble(
                      backgroundColor: PawlyColors.terracottaLight,
                      borderColor: PawlyColors.terracotta.withOpacity(0.3),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          DateBubble(
                            month: 'OCT',
                            day: appt.date.split('-').last,
                            color: PawlyColors.terracotta,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appt.purpose,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: PawlyColors.espresso,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${appt.time} • ${appt.clinic}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: PawlyColors.terracotta,
                                  ),
                                ),
                                if (appt.vetName.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    'With ${appt.vetName}',
                                    style: const TextStyle(fontSize: 12, color: PawlyColors.warmGrey),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const Icon(Icons.medical_services_outlined, color: PawlyColors.terracotta, size: 22),
                        ],
                      ),
                    ),
                  )),

              // Routines
              ...routines.map((routine) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: PawlyBubble(
                      backgroundColor: routine.isCompleted ? PawlyColors.surfaceWarm : Colors.white,
                      borderColor: PawlyColors.border,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: PawlyColors.forestLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              routine.time,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: PawlyColors.forest,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  routine.title,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    decoration: routine.isCompleted ? TextDecoration.lineThrough : null,
                                    color: routine.isCompleted ? PawlyColors.mutedGrey : PawlyColors.espresso,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${routine.category.displayName} • ${routine.recurrence}',
                                  style: const TextStyle(fontSize: 12, color: PawlyColors.warmGrey),
                                ),
                              ],
                            ),
                          ),
                          if (routine.isCompleted)
                            const Icon(Icons.check_circle_rounded, color: PawlyColors.forest, size: 22),
                        ],
                      ),
                    ),
                  )),

              const SizedBox(height: 20),

              // Active Medications Banner
              if (medications.isNotEmpty) ...[
                const Text(
                  'Ongoing Medications',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: PawlyColors.espresso,
                  ),
                ),
                const SizedBox(height: 10),
                ...medications.map((m) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: PawlyBubble(
                        backgroundColor: PawlyColors.honeyLight,
                        borderColor: PawlyColors.butterYellow,
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            const Icon(Icons.medication_outlined, color: PawlyColors.espresso, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    m.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: PawlyColors.espresso,
                                    ),
                                  ),
                                  Text(
                                    '${m.dosage} • ${m.frequency}',
                                    style: const TextStyle(fontSize: 12, color: PawlyColors.espresso),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthGrid() {
    final firstDayOfMonth = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final daysInMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0).day;
    final leadingBlanks = firstDayOfMonth.weekday % 7; // Sunday = 0

    final List<Widget> dayWidgets = [];

    // Empty blank slots
    for (int i = 0; i < leadingBlanks; i++) {
      dayWidgets.add(const SizedBox(width: 38, height: 38));
    }

    // Days
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_selectedMonth.year, _selectedMonth.month, day);
      final isSelected = date.year == _selectedDay.year &&
          date.month == _selectedDay.month &&
          date.day == _selectedDay.day;

      final dateStr = _formatDateString(date);

      // Check if routines exist on this date
      final hasRoutines = widget.repository.activePetRoutines.any((r) => r.date == dateStr);
      final hasAppts = widget.repository.activePetAppointments.any((a) => a.date == dateStr);

      dayWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedDay = date;
            });
          },
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isSelected ? PawlyColors.forest : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  '$day',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? Colors.white : PawlyColors.espresso,
                  ),
                ),
                if (hasRoutines || hasAppts)
                  Positioned(
                    bottom: 4,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (hasRoutines)
                          Container(
                            width: 4,
                            height: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : PawlyColors.forest,
                              shape: BoxShape.circle,
                            ),
                          ),
                        if (hasAppts)
                          Container(
                            width: 4,
                            height: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            decoration: BoxDecoration(
                              color: isSelected ? PawlyColors.butterYellow : PawlyColors.terracotta,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      alignment: WrapAlignment.start,
      children: dayWidgets,
    );
  }
}

class _WeekDayLabel extends StatelessWidget {
  final String label;

  const _WeekDayLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: PawlyColors.warmGrey,
          ),
        ),
      ),
    );
  }
}
