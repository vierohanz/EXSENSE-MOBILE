class TimesheetEntryModel {
  final DateTime date;
  final String dayName;
  final String? startTime;
  final String? endTime;
  final String? totalHours;
  final String? activityRemark;
  final bool isSynced;

  const TimesheetEntryModel({
    required this.date,
    required this.dayName,
    this.startTime,
    this.endTime,
    this.totalHours,
    this.activityRemark,
    this.isSynced = false,
  });

  TimesheetEntryModel copyWith({
    DateTime? date,
    String? dayName,
    String? startTime,
    String? endTime,
    String? totalHours,
    String? activityRemark,
    bool? isSynced,
  }) {
    return TimesheetEntryModel(
      date: date ?? this.date,
      dayName: dayName ?? this.dayName,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      totalHours: totalHours ?? this.totalHours,
      activityRemark: activityRemark ?? this.activityRemark,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  String get formattedExcelDate => '${date.month}/${date.day}/${date.year}';

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'dayName': dayName,
      'startTime': startTime ?? '',
      'endTime': endTime ?? '',
      'totalHours': totalHours ?? '',
      'activityRemark': activityRemark ?? '',
      'isSynced': isSynced,
    };
  }

  factory TimesheetEntryModel.fromJson(Map<String, dynamic> json) {
    return TimesheetEntryModel(
      date: DateTime.parse(json['date'] as String),
      dayName: json['dayName'] as String,
      startTime: (json['startTime'] as String?)?.isEmpty == true
          ? null
          : json['startTime'] as String?,
      endTime: (json['endTime'] as String?)?.isEmpty == true
          ? null
          : json['endTime'] as String?,
      totalHours: (json['totalHours'] as String?)?.isEmpty == true
          ? null
          : json['totalHours'] as String?,
      activityRemark: (json['activityRemark'] as String?)?.isEmpty == true
          ? null
          : json['activityRemark'] as String?,
      isSynced: json['isSynced'] as bool? ?? false,
    );
  }
}

typedef TimesheetEntry = TimesheetEntryModel;
