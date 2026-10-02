import 'package:flutter/material.dart';
import '../../theme/pawly_colors.dart';
import '../../theme/pawly_typography.dart';
import '../../theme/app_tokens.dart';
import '../../widgets/widgets.dart';
import '../../repositories/pawly_repository.dart';
import '../../models/models.dart';

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

    final routines = widget.repository.activePetRoutines.where((r) {
      return r.date == selectedDateStr;
    }).toList();

    final appointments = widget.repository.activePetAppointments.where((a) {
      return a.date == selectedDateStr;
    }).toList();

    final medications = widget.repository.activePetMedications;

    return Scaffold(
      backgroundColor: PawlyColors.background,
      appBar: PawlyAppBar(title: '${pet.name}’s Calendar'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Month Selector Header (8px Card)
              PawlyCard(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left_rounded, color: PawlyColors.black),
                      onPressed: _prevMonth,
                      visualDensity: VisualDensity.compact,
                    ),
                    Text(
                      _formatMonthYear(_selectedMonth),
                      style: PawlyTypography.titleMedium,
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded, color: PawlyColors.black),
                      onPressed: _nextMonth,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Calendar Grid Box (8px Card)
              PawlyCard(
                padding: const EdgeInsets.all(14),
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

              const SizedBox(height: 20),

              // Agenda for Selected Day
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Agenda for ${_selectedDay.month}/${_selectedDay.day}/${_selectedDay.year}',
                    style: PawlyTypography.titleSmall,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: PawlyColors.softGrey,
                      borderRadius: AppRadius.rSm,
                      border: Border.all(color: PawlyColors.border, width: 0.8),
                    ),
                    child: Text(
                      '${routines.length + appointments.length} events',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: PawlyColors.black,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              if (routines.isEmpty && appointments.isEmpty)
                const PawlyCard(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.event_available_rounded, color: PawlyColors.black, size: 20),
                      SizedBox(width: 12),
                      Expanded(
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
                    margin: const EdgeInsets.only(bottom: 8),
                    child: PawlyCard(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          DateBubble(
                            month: 'OCT',
                            day: appt.date.split('-').last,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appt.purpose,
                                  style: PawlyTypography.titleSmall,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${appt.time} • ${appt.clinic}',
                                  style: PawlyTypography.bodySmall,
                                ),
                                if (appt.vetName.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    'With ${appt.vetName}',
                                    style: PawlyTypography.caption,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const Icon(Icons.medical_services_outlined, color: PawlyColors.black, size: 18),
                        ],
                      ),
                    ),
                  )),

              // Routines
              ...routines.map((routine) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: CareTimelineItem(
                      time: routine.time,
                      title: routine.title,
                      subtitle: '${routine.category.displayName} • ${routine.recurrence}',
                      isCompleted: routine.isCompleted,
                      assignedTo: routine.assignedTo,
                      onToggle: () => widget.repository.toggleRoutine(routine.id),
                    ),
                  )),

              const SizedBox(height: 16),

              // Active Medications
              if (medications.isNotEmpty) ...[
                const Text('ONGOING MEDICATIONS', style: PawlyTypography.eyebrow),
                const SizedBox(height: 8),
                ...medications.map((m) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: PawlyCard(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: PawlyColors.softGrey,
                                borderRadius: AppRadius.rSm,
                              ),
                              child: const Icon(Icons.medication_outlined, color: PawlyColors.black, size: 16),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    m.name,
                                    style: PawlyTypography.titleSmall,
                                  ),
                                  Text(
                                    '${m.dosage} • ${m.frequency}',
                                    style: PawlyTypography.caption,
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
    final leadingBlanks = firstDayOfMonth.weekday % 7;

    final List<Widget> dayWidgets = [];

    for (int i = 0; i < leadingBlanks; i++) {
      dayWidgets.add(const SizedBox(width: 38, height: 38));
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_selectedMonth.year, _selectedMonth.month, day);
      final isSelected = date.year == _selectedDay.year &&
          date.month == _selectedDay.month &&
          date.day == _selectedDay.day;

      final dateStr = _formatDateString(date);

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
              color: isSelected ? PawlyColors.black : Colors.transparent,
              borderRadius: AppRadius.rSm,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  '$day',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? Colors.white : PawlyColors.black,
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
                            width: 3,
                            height: 3,
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : PawlyColors.charcoal,
                              shape: BoxShape.circle,
                            ),
                          ),
                        if (hasAppts)
                          Container(
                            width: 3,
                            height: 3,
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white70 : PawlyColors.black,
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
          style: PawlyTypography.labelSmall.copyWith(fontSize: 10),
        ),
      ),
    );
  }
}
