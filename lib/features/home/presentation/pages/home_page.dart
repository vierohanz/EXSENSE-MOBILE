import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/input_bottom_sheet.dart';
import '../../logic/home_controller.dart';
import '../widgets/home_bottom_wave.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate,
      firstDate: DateTime(2025, 1, 1),
      lastDate: DateTime(2030, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.setDate(picked);
    }
  }

  Future<void> _selectCustomTime(BuildContext context, bool isCheckIn) async {
    final initial = isCheckIn
        ? (controller.checkInTime ?? DateTime.now())
        : (controller.checkOutTime ?? DateTime.now());

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final date = controller.selectedDate;
      final newTime = DateTime(
        date.year,
        date.month,
        date.day,
        picked.hour,
        picked.minute,
      );
      if (isCheckIn) {
        controller.checkIn(newTime);
      } else {
        controller.checkOut(newTime);
      }
    }
  }

  void _showConnectionSettings(BuildContext context) {
    AppInputBottomSheet.show(
      context: context,
      title: 'Token',
      controller: controller.tokenTextController,
      hintText: 'Fill your token here...',
      onSubmit: controller.updateAccessToken,
    );
  }

  void _showActivityRemarkDialog(BuildContext context) {
    AppInputBottomSheet.show(
      context: context,
      title: 'Activity Note',
      subtitle:
          '${controller.selectedDayName}, ${controller.excelFormattedDate}',
      controller: controller.remarkTextController,
      hintText: 'Write your activity for today...',
      onSubmit: controller.setActivityRemark,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: HomeBottomWave(),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.help_outline_rounded,
                            color: Color(0xFF64748B),
                            size: 30,
                          ),
                          onPressed: () => _showConnectionSettings(context),
                        ),
                      ),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.20),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'R',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 350.ms),
                  const Gap(24),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        height: 1.25,
                        letterSpacing: -0.5,
                      ),
                      children: const [
                        TextSpan(text: 'Hi Rais,\n'),
                        TextSpan(
                          text: 'Be ready to absence\nin office?',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 100.ms, duration: 400.ms)
                      .slideY(begin: 0.06, end: 0, curve: Curves.easeOut),
                  const Gap(22),
                  Obx(
                    () => Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => _selectDate(context),
                            borderRadius: BorderRadius.circular(8),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: controller.isWeekend
                                        ? const Color(0xFFFEF3C7)
                                        : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    controller.selectedDayName,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: controller.isWeekend
                                          ? const Color(0xFFD97706)
                                          : const Color(0xFF0F172A),
                                    ),
                                  ),
                                ),
                                const Gap(10),
                                Text(
                                  controller.excelFormattedDate,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const Gap(4),
                                const Icon(
                                  Icons.calendar_today_rounded,
                                  size: 15,
                                  color: Color(0xFF94A3B8),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                icon: const Icon(
                                  Icons.chevron_left_rounded,
                                  color: Color(0xFF64748B),
                                  size: 22,
                                ),
                                onPressed: controller.previousDay,
                              ),
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                icon: const Icon(
                                  Icons.chevron_right_rounded,
                                  color: Color(0xFF64748B),
                                  size: 22,
                                ),
                                onPressed: controller.nextDay,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 150.ms, duration: 400.ms),
                  const Gap(24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Absence',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                  const Gap(14),
                  Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: _CleanAttendanceCard(
                            title: 'Start',
                            time: controller.checkInDisplay,
                            isActive: !controller.isCheckedIn,
                            isDone: controller.isCheckedIn,
                            icon: Icons.login_rounded,
                            onTap: () {
                              if (!controller.isCheckedIn) {
                                controller.checkIn();
                              } else {
                                _selectCustomTime(context, true);
                              }
                            },
                          ),
                        ),
                        const Gap(14),
                        Expanded(
                          child: _CleanAttendanceCard(
                            title: 'End',
                            time: controller.checkOutDisplay,
                            isActive: controller.isCheckedIn &&
                                !controller.isCheckedOut,
                            isDone: controller.isCheckedOut,
                            icon: Icons.logout_rounded,
                            onTap: () {
                              if (controller.isCheckedIn &&
                                  !controller.isCheckedOut) {
                                controller.checkOut();
                              } else if (controller.isCheckedOut) {
                                _selectCustomTime(context, false);
                              } else {
                                controller.checkOut();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 250.ms, duration: 400.ms),
                  const Gap(20),
                  Obx(
                    () => InkWell(
                      onTap: () => _showActivityRemarkDialog(context),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.edit_note_rounded,
                              color: Color(0xFF64748B),
                              size: 22,
                            ),
                            const Gap(12),
                            Expanded(
                              child: Text(
                                controller.activityRemark.isEmpty
                                    ? 'Activity note'
                                    : controller.activityRemark,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: controller.activityRemark.isEmpty
                                      ? FontWeight.w500
                                      : FontWeight.w600,
                                  color: controller.activityRemark.isEmpty
                                      ? const Color(0xFF94A3B8)
                                      : const Color(0xFF0F172A),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
                  Gap(HomeBottomWave.contentClearanceFor(context)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

typedef HomeView = HomePage;

class _CleanAttendanceCard extends StatelessWidget {
  final String title;
  final String time;
  final bool isActive;
  final bool isDone;
  final IconData icon;
  final VoidCallback onTap;

  const _CleanAttendanceCard({
    required this.title,
    required this.time,
    required this.isActive,
    required this.isDone,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive ? AppColors.primary : const Color(0xFFE2E8F0),
            ),
            boxShadow: [
              BoxShadow(
                color: isActive
                    ? AppColors.primary.withValues(alpha: 0.16)
                    : Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    icon,
                    size: 22,
                    color: isActive ? Colors.white : const Color(0xFF64748B),
                  ),
                  if (isDone)
                    Icon(
                      Icons.check_circle_rounded,
                      size: 16,
                      color: isActive ? Colors.white : const Color(0xFF10B981),
                    ),
                ],
              ),
              const Gap(16),
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.white : AppColors.textPrimary,
                ),
              ),
              const Gap(6),
              Text(
                time,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                  color: isActive ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
