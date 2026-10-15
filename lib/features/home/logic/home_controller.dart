import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/timesheet_entry_model.dart';

abstract class MicrosoftGraphService {
  String? get accessToken;
  Future<void> setAccessToken(String token);
  Future<List<TimesheetEntryModel>> fetchTimesheetFromExcel();
  Future<void> seedInitialExcelData();
  TimesheetEntryModel? getLocalEntry(DateTime date);
  void updateTimesheetRow(TimesheetEntryModel entry);
}

class HomeController extends GetxController {
  final MicrosoftGraphService? _graphService;

  HomeController({MicrosoftGraphService? graphService})
      : _graphService = graphService;

  static const List<String> _dayNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  final Rx<DateTime> _selectedDate = DateTime.now().obs;
  DateTime get selectedDate => _selectedDate.value;

  final Rxn<DateTime> _checkInTime = Rxn<DateTime>();
  DateTime? get checkInTime => _checkInTime.value;

  final Rxn<DateTime> _checkOutTime = Rxn<DateTime>();
  DateTime? get checkOutTime => _checkOutTime.value;

  final RxBool _isCheckedIn = false.obs;
  bool get isCheckedIn => _isCheckedIn.value;

  final RxBool _isCheckedOut = false.obs;
  bool get isCheckedOut => _isCheckedOut.value;

  final RxString _activityRemark = ''.obs;
  String get activityRemark => _activityRemark.value;

  final RxBool _isSyncing = false.obs;
  bool get isSyncing => _isSyncing.value;

  final RxBool _isSynced = false.obs;
  bool get isSynced => _isSynced.value;

  final RxInt _selectedTab = 0.obs;
  int get selectedTab => _selectedTab.value;

  final TextEditingController remarkTextController = TextEditingController();
  final TextEditingController tokenTextController = TextEditingController();

  bool get hasAccessToken =>
      _graphService?.accessToken != null &&
      _graphService!.accessToken!.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  @override
  void onClose() {
    remarkTextController.dispose();
    tokenTextController.dispose();
    super.onClose();
  }

  Future<void> _initializeData() async {
    await _graphService?.seedInitialExcelData();
    await _graphService?.fetchTimesheetFromExcel();
    _loadStateForSelectedDate();
  }

  String get selectedDayName => _dayNames[_selectedDate.value.weekday - 1];

  String get excelFormattedDate =>
      '${_selectedDate.value.month}/${_selectedDate.value.day}/${_selectedDate.value.year}';

  bool get isWeekend =>
      _selectedDate.value.weekday == DateTime.saturday ||
      _selectedDate.value.weekday == DateTime.sunday;

  String get checkInDisplay {
    final time = _checkInTime.value;
    if (time == null) return '--:--';
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m WIB';
  }

  String get checkOutDisplay {
    final outTime = _checkOutTime.value;
    if (outTime != null) {
      final h = outTime.hour.toString().padLeft(2, '0');
      final m = outTime.minute.toString().padLeft(2, '0');
      return '$h:$m WIB';
    }
    final inTime = _checkInTime.value;
    if (inTime != null) {
      final target = inTime.add(const Duration(hours: 9));
      final h = target.hour.toString().padLeft(2, '0');
      final m = target.minute.toString().padLeft(2, '0');
      return '$h:$m WIB';
    }
    return '--:--';
  }

  String get totalWorkingHours {
    final inTime = _checkInTime.value;
    if (inTime == null) return '--:--';

    final outTime = _checkOutTime.value;
    if (outTime == null) return '8:00';

    final diff = outTime.difference(inTime);
    if (diff <= const Duration(hours: 1)) {
      return '0:00';
    }

    final effective = diff - const Duration(hours: 1);
    final hours = effective.inHours;
    final minutes = (effective.inMinutes % 60).toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  void checkIn([DateTime? customTime]) {
    if (_isCheckedIn.value && customTime == null) return;
    final time = customTime ?? DateTime.now();
    _checkInTime.value = time;
    _isCheckedIn.value = true;
    _saveCurrentState();
  }

  void checkOut([DateTime? customTime]) {
    if (!_isCheckedIn.value) {
      Get.snackbar(
        'Warning',
        'Please start working first',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    final time = customTime ?? DateTime.now();
    _checkOutTime.value = time;
    _isCheckedOut.value = true;
    _saveCurrentState();
  }

  void nextDay() {
    _selectedDate.value = _selectedDate.value.add(const Duration(days: 1));
    _loadStateForSelectedDate();
  }

  void previousDay() {
    _selectedDate.value = _selectedDate.value.subtract(const Duration(days: 1));
    _loadStateForSelectedDate();
  }

  void setDate(DateTime date) {
    _selectedDate.value = date;
    _loadStateForSelectedDate();
  }

  void setActivityRemark(String remark) {
    _activityRemark.value = remark;
    _saveCurrentState();
  }

  void resetAttendance() {
    _checkInTime.value = null;
    _checkOutTime.value = null;
    _isCheckedIn.value = false;
    _isCheckedOut.value = false;
    _activityRemark.value = '';
    _isSynced.value = false;
    remarkTextController.clear();
    _saveCurrentState();
  }

  void setTab(int index) {
    _selectedTab.value = index;
  }

  Future<void> updateAccessToken(String token) async {
    await _graphService?.setAccessToken(token.trim());
    await refreshFromExcel();
  }

  Future<void> refreshFromExcel() async {
    if (_graphService == null) return;
    _isSyncing.value = true;
    final entries = await _graphService.fetchTimesheetFromExcel();
    _isSyncing.value = false;
    _loadStateForSelectedDate();

    Get.snackbar(
      'Information',
      entries.isNotEmpty
          ? 'Successfully loaded ${entries.length} attendance records'
          : 'Local data has been updated',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _saveCurrentState() {
    if (_graphService == null) return;
    final entry = _buildCurrentEntry();
    _graphService.updateTimesheetRow(entry);
  }

  void _loadStateForSelectedDate() {
    final entry = _graphService?.getLocalEntry(_selectedDate.value);
    if (entry != null) {
      if (entry.startTime != null && entry.startTime!.isNotEmpty) {
        final parts = entry.startTime!.split(':');
        if (parts.length == 2) {
          final h = int.tryParse(parts[0]) ?? 0;
          final m = int.tryParse(parts[1]) ?? 0;
          _checkInTime.value = DateTime(
            _selectedDate.value.year,
            _selectedDate.value.month,
            _selectedDate.value.day,
            h,
            m,
          );
          _isCheckedIn.value = true;
        }
      } else {
        _checkInTime.value = null;
        _isCheckedIn.value = false;
      }

      if (entry.endTime != null && entry.endTime!.isNotEmpty) {
        final parts = entry.endTime!.split(':');
        if (parts.length == 2) {
          final h = int.tryParse(parts[0]) ?? 0;
          final m = int.tryParse(parts[1]) ?? 0;
          _checkOutTime.value = DateTime(
            _selectedDate.value.year,
            _selectedDate.value.month,
            _selectedDate.value.day,
            h,
            m,
          );
          _isCheckedOut.value = true;
        }
      } else {
        _checkOutTime.value = null;
        _isCheckedOut.value = false;
      }

      _activityRemark.value = entry.activityRemark ?? '';
      remarkTextController.text = _activityRemark.value;
      _isSynced.value = entry.isSynced;
    } else {
      _checkInTime.value = null;
      _checkOutTime.value = null;
      _isCheckedIn.value = false;
      _isCheckedOut.value = false;
      _activityRemark.value = '';
      _isSynced.value = false;
      remarkTextController.clear();
    }
  }

  TimesheetEntryModel _buildCurrentEntry() {
    String? startStr;
    if (_checkInTime.value != null) {
      startStr =
          '${_checkInTime.value!.hour}:${_checkInTime.value!.minute.toString().padLeft(2, '0')}';
    }

    String? endStr;
    if (_checkOutTime.value != null) {
      endStr =
          '${_checkOutTime.value!.hour}:${_checkOutTime.value!.minute.toString().padLeft(2, '0')}';
    }

    return TimesheetEntryModel(
      date: _selectedDate.value,
      dayName: selectedDayName,
      startTime: startStr,
      endTime: endStr,
      totalHours: _isCheckedIn.value ? totalWorkingHours : null,
      activityRemark:
          _activityRemark.value.isEmpty ? null : _activityRemark.value,
      isSynced: _isSynced.value,
    );
  }
}
