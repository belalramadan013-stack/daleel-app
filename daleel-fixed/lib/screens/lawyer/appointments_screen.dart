import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class AppointmentModel {
  final String id;
  final String title;
  final String type; // جلسة، استشارة، اجتماع، أخرى
  final DateTime dateTime;
  final String? caseId;
  final String? caseTitle;
  final String? clientName;
  final String location;
  final String notes;
  final bool isCompleted;
  final bool reminderEnabled;
  final int reminderHoursBefore;
  final bool soundAlertEnabled;
  final String soundType; // default, urgent, gentle, custom
  final bool deviceNotificationEnabled;

  AppointmentModel({
    required this.id,
    required this.title,
    required this.type,
    required this.dateTime,
    this.caseId,
    this.caseTitle,
    this.clientName,
    this.location = '',
    this.notes = '',
    this.isCompleted = false,
    this.reminderEnabled = true,
    this.reminderHoursBefore = 24,
    this.soundAlertEnabled = true,
    this.soundType = 'urgent',
    this.deviceNotificationEnabled = true,
  });

  AppointmentModel copyWith({
    bool? isCompleted,
    String? notes,
    bool? reminderEnabled,
    int? reminderHoursBefore,
    bool? soundAlertEnabled,
    String? soundType,
    bool? deviceNotificationEnabled,
  }) {
    return AppointmentModel(
      id: id,
      title: title,
      type: type,
      dateTime: dateTime,
      caseId: caseId,
      caseTitle: caseTitle,
      clientName: clientName,
      location: location,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderHoursBefore: reminderHoursBefore ?? this.reminderHoursBefore,
      soundAlertEnabled: soundAlertEnabled ?? this.soundAlertEnabled,
      soundType: soundType ?? this.soundType,
      deviceNotificationEnabled: deviceNotificationEnabled ?? this.deviceNotificationEnabled,
    );
  }

  bool get isSession => type == 'جلسة';

  String get reminderText {
    if (!reminderEnabled) return 'التذكير معطل';
    if (reminderHoursBefore >= 24) {
      final days = reminderHoursBefore ~/ 24;
      return 'تذكير قبل $days يوم';
    }
    return 'تذكير قبل $reminderHoursBefore ساعة';
  }
}

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final List<AppointmentModel> _appointments = [
    AppointmentModel(
      id: '1',
      title: 'جلسة قضية فصل تعسفي',
      type: 'جلسة',
      dateTime: DateTime.now().add(const Duration(days: 2, hours: 10)),
      caseTitle: 'قضية فصل تعسفي',
      clientName: 'محمد أحمد',
      location: 'المحكمة العمالية - الرياض',
      reminderEnabled: true,
      reminderHoursBefore: 24,
      soundAlertEnabled: true,
      soundType: 'urgent',
    ),
    AppointmentModel(
      id: '2',
      title: 'استشارة عميل جديد',
      type: 'استشارة',
      dateTime: DateTime.now().add(const Duration(days: 1, hours: 14)),
      clientName: 'سارة خالد',
      location: 'المكتب',
    ),
    AppointmentModel(
      id: '3',
      title: 'اجتماع مع شركة النور',
      type: 'اجتماع',
      dateTime: DateTime.now().add(const Duration(days: 5, hours: 11)),
      caseTitle: 'نزاع عقد توريد',
      clientName: 'شركة النور',
      location: 'مقر الشركة',
    ),
  ];

  String _filter = 'القادمة'; // القادمة، اليوم، الكل

  List<AppointmentModel> get _filtered {
    final now = DateTime.now();
    switch (_filter) {
      case 'اليوم':
        return _appointments.where((a) {
          return a.dateTime.year == now.year &&
              a.dateTime.month == now.month &&
              a.dateTime.day == now.day;
        }).toList();
      case 'القادمة':
        return _appointments
            .where((a) => a.dateTime.isAfter(now) && !a.isCompleted)
            .toList()
          ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
      default:
        return List.from(_appointments)
          ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المواعيد'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddAppointment,
          ),
        ],
      ),
      body: Column(
        children: [
          // فلاتر
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _FilterBtn(
                  label: 'القادمة',
                  selected: _filter == 'القادمة',
                  onTap: () => setState(() => _filter = 'القادمة'),
                ),
                const SizedBox(width: 8),
                _FilterBtn(
                  label: 'اليوم',
                  selected: _filter == 'اليوم',
                  onTap: () => setState(() => _filter = 'اليوم'),
                ),
                const SizedBox(width: 8),
                _FilterBtn(
                  label: 'الكل',
                  selected: _filter == 'الكل',
                  onTap: () => setState(() => _filter = 'الكل'),
                ),
              ],
            ),
          ),

          // تنبيه ذكي للجلسات
          if (_filter == 'القادمة')
            Builder(
              builder: (context) {
                final upcomingSessions = _filtered
                    .where((a) => a.isSession && a.reminderEnabled)
                    .toList();
                if (upcomingSessions.isEmpty) return const SizedBox.shrink();

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.notifications_active, color: Colors.orange),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'تنبيهات صوتية مفعّلة لـ ${upcomingSessions.length} جلسة قادمة',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

          Expanded(
            child: _filtered.isEmpty
                ? const Center(child: Text('لا توجد مواعيد'))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final appt = _filtered[index];
                      return _AppointmentCard(
                        appointment: appt,
                        onToggleComplete: () {
                          setState(() {
                            final idx =
                                _appointments.indexWhere((a) => a.id == appt.id);
                            if (idx != -1) {
                              _appointments[idx] = appt.copyWith(
                                isCompleted: !appt.isCompleted,
                              );
                            }
                          });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _getSoundLabel(String type) {
    switch (type) {
      case 'urgent':
        return 'عاجل';
      case 'gentle':
        return 'هادئ';
      case 'custom':
        return 'مخصص';
      default:
        return 'عادي';
    }
  }

  int _getNearestDays() {
    if (_filtered.isEmpty) return 0;
    final nearest = _filtered.first.dateTime;
    return nearest.difference(DateTime.now()).inDays;
  }

  void _showAddAppointment() {
    final titleController = TextEditingController();
    String type = 'استشارة';
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('موعد جديد'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'عنوان الموعد'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: type,
                decoration: const InputDecoration(labelText: 'النوع'),
                items: ['جلسة', 'استشارة', 'اجتماع', 'أخرى']
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => type = v ?? type,
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('التاريخ والوقت'),
                subtitle: Text(
                  '${selectedDate.day}/${selectedDate.month} - ${selectedDate.hour}:${selectedDate.minute.toString().padLeft(2, '0')}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: ctx,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null && ctx.mounted) {
                    final time = await showTimePicker(
                      context: ctx,
                      initialTime: TimeOfDay.fromDateTime(selectedDate),
                    );
                    if (time != null) {
                      selectedDate = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      );
                      (ctx as Element).markNeedsBuild();
                    }
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                setState(() {
                  _appointments.add(AppointmentModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: titleController.text,
                    type: type,
                    dateTime: selectedDate,
                  ));
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }
}

class _FilterBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterBtn({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppTheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? AppTheme.primary : AppTheme.border,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? Colors.white : AppTheme.textPrimary,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback onToggleComplete;

  const _AppointmentCard({
    required this.appointment,
    required this.onToggleComplete,
  });

  Color _typeColor() {
    switch (appointment.type) {
      case 'جلسة':
        return Colors.red;
      case 'استشارة':
        return Colors.blue;
      case 'اجتماع':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPast = appointment.dateTime.isBefore(DateTime.now());

    return Opacity(
      opacity: appointment.isCompleted || isPast ? 0.6 : 1,
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _typeColor(),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _typeColor().withOpacity(0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              appointment.type,
                              style: TextStyle(
                                color: _typeColor(),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Checkbox(
                            value: appointment.isCompleted,
                            onChanged: (_) => onToggleComplete(),
                            activeColor: AppTheme.primary,
                          ),
                        ],
                      ),
                      Text(
                        appointment.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${appointment.dateTime.day}/${appointment.dateTime.month} - ${appointment.dateTime.hour}:${appointment.dateTime.minute.toString().padLeft(2, '0')}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (appointment.clientName != null)
                        Text(
                          appointment.clientName!,
                          style: const TextStyle(fontSize: 13),
                        ),
                      if (appointment.isSession) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              appointment.soundAlertEnabled
                                  ? Icons.volume_up
                                  : Icons.volume_off,
                              size: 14,
                              color: appointment.soundAlertEnabled
                                  ? Colors.orange
                                  : Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              appointment.soundAlertEnabled
                                  ? 'صوت: ${_getSoundLabel(appointment.soundType)}'
                                  : 'الصوت معطل',
                              style: TextStyle(
                                fontSize: 12,
                                color: appointment.soundAlertEnabled
                                    ? Colors.orange
                                    : Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              appointment.deviceNotificationEnabled
                                  ? Icons.notifications_active
                                  : Icons.notifications_off,
                              size: 14,
                              color: appointment.deviceNotificationEnabled
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              appointment.deviceNotificationEnabled
                                  ? 'إشعار الجهاز'
                                  : 'بدون إشعار',
                              style: TextStyle(
                                fontSize: 12,
                                color: appointment.deviceNotificationEnabled
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
